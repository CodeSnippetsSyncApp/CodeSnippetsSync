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
import OSLog

public typealias AccountStatus = Cirrus.AccountStatus

public final class Storage: Logging {
    public enum Action {
        case addCodeSnippet(CodeSnippetFile)
        case removeCodeSnippet(URL)
        case modifyCodeSnippet(CodeSnippetFile)
        case reload

        case cloudUpdated(Set<CodeSnippet>)
        case cloudDeleted(Set<CloudKitIdentifier>)
        case fetchCloudChanges
    }

    public static let shared = Storage()

    public static let log = makeLogger()

    @Published
    public private(set) var codeSnippets: OrderedSet<CodeSnippet> = []

    private var urlsForCodeSnippets: OrderedDictionary<CodeSnippet, URL> = [:]

    private var codeSnippetsForURLs: OrderedDictionary<URL, CodeSnippet> = [:]

    @Published
    public private(set) var accountStatus: AccountStatus = .unknown

    private let engine = SyncEngine<CodeSnippet>()

    private var cancellables: Set<AnyCancellable> = []

    public func start() async throws {
        dispatch(.reload)

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
        case .reload:
            Task {
                let results = try await CodeSnippetReader().readFromDirectory(Sandbox.shared.workingDirectoryURL)
                var codeSnippets: OrderedSet<CodeSnippet> = []
                var urlsForCodeSnippets: OrderedDictionary<CodeSnippet, URL> = [:]
                var codeSnippetsForURLs: OrderedDictionary<URL, CodeSnippet> = [:]
                results.forEach { result in
                    codeSnippets.append(result.model)
                    urlsForCodeSnippets[result.model] = result.url
                    codeSnippetsForURLs[result.url] = result.model
                }

                codeSnippets.sort()

                self.codeSnippets = codeSnippets
                self.urlsForCodeSnippets = urlsForCodeSnippets
                self.codeSnippetsForURLs = codeSnippetsForURLs
                engine.upload(codeSnippets.elements)
            }
        case let .addCodeSnippet(codeSnippetFile):
            codeSnippets.append(codeSnippetFile.model)
            urlsForCodeSnippets[codeSnippetFile.model] = codeSnippetFile.url
            codeSnippetsForURLs[codeSnippetFile.url] = codeSnippetFile.model
            engine.upload(codeSnippetFile.model)
        case let .removeCodeSnippet(url):
            guard let codeSnippet = codeSnippetsForURLs[url] else { return }
            codeSnippets.remove(codeSnippet)
            urlsForCodeSnippets.removeValue(forKey: codeSnippet)
            codeSnippetsForURLs.removeValue(forKey: url)
            engine.delete(codeSnippet)
        case let .modifyCodeSnippet(codeSnippetFile):
            codeSnippets.updateOrAppend(codeSnippetFile.model)
            urlsForCodeSnippets[codeSnippetFile.model] = codeSnippetFile.url
            codeSnippetsForURLs[codeSnippetFile.url] = codeSnippetFile.model
            engine.upload(codeSnippetFile.model)
        case let .cloudUpdated(codeSnippetsToUpdate):
            Task {
                let results = await CodeSnippetWriter(directory: Sandbox.shared.workingDirectoryURL, codeSnippets: .init(codeSnippetsToUpdate), filenameFormat: .id).write()

                results.forEach { result in
                    codeSnippets.updateOrAppend(result.model)
                    codeSnippets.sort()
                    urlsForCodeSnippets[result.model] = result.url
                    codeSnippetsForURLs[result.url] = result.model
                }
            }
        case let .cloudDeleted(identifiers):
            Task {
                let codeSnippetsToDelete = codeSnippets.filter { identifiers.contains($0.cloudKitIdentifier) }

                let codeSnippetFilesToDelete = codeSnippetsToDelete.compactMap { codeSnippet in
                    if let url = urlsForCodeSnippets[codeSnippet] {
                        return CodeSnippetFile(url: url, model: codeSnippet)
                    } else {
                        return nil
                    }
                }

                let results = await CodeSnippetDeleter(codeSnippetFiles: codeSnippetFilesToDelete).delete()

                results.forEach { result in
                    codeSnippets.remove(result.model)
                    codeSnippets.sort()
                    urlsForCodeSnippets.removeValue(forKey: result.model)
                    codeSnippetsForURLs.removeValue(forKey: result.url)
                }
            }
        case .fetchCloudChanges:
            engine.forceSync()
        }
    }

    public func processRemoteChangeNotification(with userInfo: [AnyHashable: Any]) {
        engine.processRemoteChangeNotification(with: userInfo)
    }
}
