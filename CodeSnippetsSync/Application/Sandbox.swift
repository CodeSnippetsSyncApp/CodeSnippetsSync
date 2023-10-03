//
//  Sandbox.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import AppKit
import Combine
import Defaults
import URLCompatibilityKit
import CodeSnippetsSyncResources

extension Sandbox {
    private enum Constants {
        static let defaultXcodeUserDataDirectory = defaultDeveloperURL.appending(path: "Xcode/UserData/")
        static let defaultXcodeCodeSnippetsDirectory = defaultDeveloperURL.appending(path: "Xcode/UserData/CodeSnippets/")
        static var defaultDeveloperURL: URL = {
            var homeDirectory = NSHomeDirectory()
            let sandboxPrefix = "/Library/Containers/"

            if homeDirectory.contains(sandboxPrefix) {
                if let range = homeDirectory.range(of: sandboxPrefix) {
                    homeDirectory = String(homeDirectory[..<range.lowerBound])
                }
            }

            return URL(fileURLWithPath: "\(homeDirectory)/Library/Developer/")
        }()
    }
}

class Sandbox: Logging {
    static let log = makeLogger()

    static let shared = Sandbox()

    private init() {}
    
    let workingDirectoryURL = Constants.defaultXcodeCodeSnippetsDirectory

    @Published
    var status: Status = .unknown

    enum Status: Hashable {
        case available
        case restricted(Error)
        case unknown
    }

    enum Error: Swift.Error, Hashable {
        case incorrectDirectory
        case failedToCreateDirectory
        case unauthorizedDirectory
        case unselectedDirectory
    }

    func authorize() {
        do {
            try startAccessingSecurityScopedResource()
            try checkWorkingDirectory()
            status = .available
            Task {
                do {
                    try await Storage.shared.start()
                    await NSApplication.shared.registerForRemoteNotifications()
                } catch {
                    log.error("\(error, privacy: .public)")
                }
            }
        } catch {
            if let error = error as? Error {
                status = .restricted(error)
            }
        }
    }

    private func startAccessingSecurityScopedResource(for workingDirectoryURL: URL = Constants.defaultXcodeUserDataDirectory) throws {
        if let bookmarkData = Preferences.workingDirectoryBookmark, let url = resolvingBookmarkData(with: bookmarkData), url.startAccessingSecurityScopedResource() {
            return
        }
        
        let openPanel = NSOpenPanel().then {
            $0.message = L10n.Sandbox.OpenPanel.message
            $0.prompt = L10n.Sandbox.OpenPanel.prompt
            $0.directoryURL = workingDirectoryURL
            $0.canChooseFiles = false
            $0.canChooseDirectories = true
            $0.allowsMultipleSelection = false
            $0.runModal()
        }

        guard let selectedDirectoryURL = openPanel.url else {
            throw Error.unselectedDirectory
        }

        guard selectedDirectoryURL == workingDirectoryURL else {
            throw Error.incorrectDirectory
        }

        guard let bookmarkData = saveBookmarkData(for: selectedDirectoryURL), let resolvedDirectoryURL = resolvingBookmarkData(with: bookmarkData), resolvedDirectoryURL.startAccessingSecurityScopedResource() else {
            throw Error.unauthorizedDirectory
        }

        print(resolvedDirectoryURL)
    }

    private func checkWorkingDirectory() throws {
        if FileManager.default.fileExists(atPath: Constants.defaultXcodeCodeSnippetsDirectory.path) {
            return
        }

        do {
            try FileManager.default.createDirectory(at: Constants.defaultXcodeCodeSnippetsDirectory, withIntermediateDirectories: false)
        } catch {
            log.error("\(error)")
            throw Error.failedToCreateDirectory
        }
    }

    @discardableResult
    private func saveBookmarkData(for url: URL) -> Data? {
        do {
            let bookmarkData = try url.bookmarkData(options: .withSecurityScope)
            Preferences.workingDirectoryBookmark = bookmarkData
            return bookmarkData
        } catch {
            log.error("\(error)")
            return nil
        }
    }

    private func resolvingBookmarkData(with bookmarkData: Data) -> URL? {
        do {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
            if isStale {
                // bookmarks could become stale as the OS changes
                saveBookmarkData(for: url)
            }
            return url
        } catch {
            log.error("\(error)")
            return nil
        }
    }
}
