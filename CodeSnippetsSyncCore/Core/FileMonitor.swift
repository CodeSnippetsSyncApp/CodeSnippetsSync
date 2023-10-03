//
//  FileSystemMonitor.swift
//  CodeSnippetsSync
//
//  Created by JH on 2023/10/3.
//

import AppKit
import OSLog
import FSEventsWrapper

public final class FileMonitor: Logging {
    static public let shared = FileMonitor()

    static public let log = makeLogger()

    private var fileEventStream: FSEventStream?

    private var isStarted = false

    private init() {}

    public func start() {
        guard !isStarted else {
            log.info("File Monitor has already started")
            return
        }
        guard let fileEventStream = FSEventStream(
            path: Sandbox.shared.workingDirectoryURL.path,
            fsEventStreamFlags: FSEventStreamCreateFlags([
                kFSEventStreamCreateFlagIgnoreSelf,
                kFSEventStreamCreateFlagFileEvents,
                kFSEventStreamCreateFlagMarkSelf,
                kFSEventStreamCreateFlagNoDefer,
            ].or()),
            callback: handleFileEvent(with:event:)
        ) else {
            log.warning("File event stream created failed")
            return
        }

        fileEventStream.startWatching()

        isStarted = true

        self.fileEventStream = fileEventStream

        log.info("File Monitor Starting !!!")
    }

    public func stop() {
        guard isStarted else {
            log.info("File Monitor Has not been started yet")
            return
        }
        fileEventStream?.stopWatching()
        fileEventStream = nil

        log.info("File Monitor did Stop")
    }

    @Sendable
    private func handleFileEvent(with stream: FSEventStream, event: FSEvent) {
        log.info("Handle Event: \(event.debugDescription)")
        switch event {
        case let .itemCreated(path, itemType, _, fromUs),
             let .itemDataModified(path, itemType, _, fromUs):
            guard itemType == .file, !fromUs.boolValue else { return }
            do {
                let codeSnippetFile = try CodeSnippetReader().readFromFile(URL(fileURLWithPath: path))
                Storage.shared.dispatch(.addCodeSnippet(codeSnippetFile))
            } catch {
                log.error("\(error)")
            }
        case let .itemRemoved(path, itemType, _, fromUs):
            guard itemType == .file, !fromUs.boolValue else { return }
            Storage.shared.dispatch(.removeCodeSnippet(URL(fileURLWithPath: path)))
        default:
            break
        }
    }
}

extension Optional where Wrapped == Bool {
    var boolValue: Bool {
        self ?? false
    }
}

extension FSEvent.MustScanSubDirsReason: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .userDropped:
            "UserDropped"
        case .kernelDropped:
            "KernelDropped"
        case .unknown:
            "Unknown"
        }
    }
}

extension FSEvent.ItemType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .file:
            "File"
        case .dir:
            "Dir"
        case .symlink:
            "Symlink"
        case .hardlink:
            "Hardlink"
        case .lastHardlink:
            "LastHardlink"
        case .unknown:
            "Unknown"
        }
    }
}

extension FSEvent: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .generic(path, eventId, fromUs):
            "[Generic] path: \(path), eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .mustScanSubDirs(path, reason):
            "[MustScanSubDirs] path: \(path), reason: \(reason)"
        case .eventIdsWrapped:
            "[EventIDsWrapped]"
        case .streamHistoryDone:
            "[StreamHistoryDone]"
        case let .rootChanged(path, fromUs):
            "[RootChanged] path: \(path), fromUs: \(fromUs.boolValue)"
        case let .volumeMounted(path, eventId, fromUs):
            "[VolumeMounted] path: \(path), eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .volumeUnmounted(path, eventId, fromUs):
            "[VolumeUnmounted] path: \(path), eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemCreated(path, itemType, eventId, fromUs):
            "[ItemCreated] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemRemoved(path, itemType, eventId, fromUs):
            "[ItemRemoved] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemInodeMetadataModified(path, itemType, eventId, fromUs):
            "[ItemInodeMetadataModified] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemRenamed(path, itemType, eventId, fromUs):
            "[ItemRenamed] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemDataModified(path, itemType, eventId, fromUs):
            "[ItemDataModified] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemFinderInfoModified(path, itemType, eventId, fromUs):
            "[ItemFinderInfoModified] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemOwnershipModified(path, itemType, eventId, fromUs):
            "[ItemOwnershipModified] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemXattrModified(path, itemType, eventId, fromUs):
            "[ItemXattrModified] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        case let .itemClonedAtPath(path, itemType, eventId, fromUs):
            "[ItemClonedAtPath] path: \(path), itemType: \(itemType) eventID: \(eventId), fromUs: \(fromUs.boolValue)"
        }
    }
}

extension Array where Element == Int {
    func or() -> Int {
        reduce(0) { $0 | $1 }
    }
}
