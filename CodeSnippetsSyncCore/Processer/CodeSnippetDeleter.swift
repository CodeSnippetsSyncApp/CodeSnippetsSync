//
//  CodeSnippetDeleter.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation

public struct CodeSnippetDeleter: Logging {
    public static let log = makeLogger()

    public let codeSnippetFiles: [CodeSnippetFile]

    @discardableResult
    public func delete() async -> [CodeSnippetFile] {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                var results: [CodeSnippetFile] = []
                for codeSnippetFile in codeSnippetFiles {
                    do {
                        try FileManager.default.removeItem(at: codeSnippetFile.url)
                        results.append(codeSnippetFile)
                    } catch {
                        log.error("\(error)")
                    }
                }

                continuation.resume(returning: results)
            }
        }
    }
}
