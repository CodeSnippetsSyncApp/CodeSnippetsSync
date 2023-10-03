//
//  CodeSnippetDeleter.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation

struct CodeSnippetDeleter {
    let codeSnippetURLs: [URL]

    func delete() async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    try codeSnippetURLs.forEach { try FileManager.default.removeItem(at: $0) }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
