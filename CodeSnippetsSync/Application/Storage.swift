//
//  Storage.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/29.
//

import AppKit
import Combine
import Cirrus
import CloudKitCodable
import OrderedCollections

class Storage: Logging {
    enum Action {
        case initial([CodeSnippet])
        case addCodeSnippet(CodeSnippet)
        case fetchCloudChanges
        case cloudUpdated(Set<CodeSnippet>)
        case cloudDeleted(Set<CloudKitIdentifier>)
    }

    public static let shared = Storage()

    public static let log = makeLogger()

    @Published
    public private(set) var codeSnippets: OrderedSet<CodeSnippet> = []

    @Published
    public private(set) var accountStatus: AccountStatus = .unknown

    private let engine = SyncEngine<CodeSnippet>()

    private var cancellables: Set<AnyCancellable> = []

    public func start() async throws {
        codeSnippets = try await CodeSnippetReader(directory: Sandbox.shared.workingDirectoryURL).read()
        dispatch(.initial(codeSnippets.elements))
        engine.modelsChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] change in
                guard let self = self else { return }
                switch change {
                case let .updated(codeSnippets):
                    dispatch(.cloudUpdated(codeSnippets))
                case let .deleted(codeSnippetIDs):
                    dispatch(.cloudDeleted(codeSnippetIDs))
                }
            }
            .store(in: &cancellables)
        engine.$accountStatus.assign(to: \.accountStatus, on: self).store(in: &cancellables)
    }

    public func dispatch(_ action: Action) {
        switch action {
        case let .initial(codeSnippets):
            engine.upload(codeSnippets)
        case let .addCodeSnippet(codeSnippet):
            codeSnippets.append(codeSnippet)
            engine.upload(codeSnippet)
        case let .cloudUpdated(codeSnippetsToUpdate):
            codeSnippetsToUpdate.forEach { codeSnippets.appendOrReplace($0) }
            updatePersistentStorage()
        case let .cloudDeleted(identifiers):
            let codeSnippetsToDelete = codeSnippets.filter { identifiers.contains($0.cloudKitIdentifier) }
            codeSnippetsToDelete.forEach { codeSnippets.remove($0) }
            updatePersistentStorage()
        case .fetchCloudChanges:
            engine.forceSync()
        }
    }

    private func updatePersistentStorage() {
        Task {
            let source: OrderedDictionary<CodeSnippet, URL> = try await CodeSnippetReader(directory: Sandbox.shared.workingDirectoryURL).read()
            let target = codeSnippets
            let changeset = Differentor<CodeSnippet>(source: source.keys.elements, target: target.elements).diff()
            try await CodeSnippetWriter(directory: Sandbox.shared.workingDirectoryURL, codeSnippets: changeset.inserted + changeset.updated, filenameFormat: .id).write()
            try await CodeSnippetDeleter(codeSnippetURLs: changeset.deleted.compactMap { source[$0] }).delete()
        }
    }

    public func processRemoteChangeNotification(with userInfo: [AnyHashable: Any]) {
        engine.processRemoteChangeNotification(with: userInfo)
    }
}

extension OrderedSet where Element == CodeSnippet {
    mutating func appendOrReplace(_ item: Element) {
        if let index = firstIndex(where: { $0.cloudKitIdentifier == item.cloudKitIdentifier }) {
            remove(at: index)
        }
        append(item)
    }
}
