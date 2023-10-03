//
//  CodeSnippetReader.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation
import OrderedCollections

struct CodeSnippetReader {
    let directory: URL

    func read() async throws -> OrderedDictionary<CodeSnippet, URL> {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let codeSnippetsURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                    let codeSnippets: OrderedDictionary<CodeSnippet, URL> = try codeSnippetsURLs.reduce(into: [:]) { dict, url in
                        let data = try Data(contentsOf: url)
                        var codeSnippet = try PropertyListDecoder().decode(CodeSnippet.self, from: data)
                        let resourceValue = try url.resourceValues(forKeys: [.contentModificationDateKey])
                        if let contentModificationDate = resourceValue.contentModificationDate {
                            codeSnippet.modifiedDate = contentModificationDate
                        }
                        dict[codeSnippet] = url
                    }
                    continuation.resume(returning: codeSnippets)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @inlinable
    func read() async throws -> OrderedSet<CodeSnippet> {
        try await read().keys
    }
}

