//
//  CodeSnippetReader.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation
import OrderedCollections

public struct CodeSnippetFile {
    public let url: URL
    public let model: CodeSnippet
}

public struct CodeSnippetReader: Logging {
    public static let log = makeLogger()

    public func readFromDirectory(_ directory: URL) async throws -> [CodeSnippetFile] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let codeSnippetsURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
                    let codeSnippets = codeSnippetsURLs.compactMap { url -> CodeSnippetFile? in
                        do {
                            return try readFromFile(url)
                        } catch {
                            log.error("\(error)")
                            return nil
                        }
                    }
                    continuation.resume(returning: codeSnippets)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func readFromFile(_ url: URL) throws -> CodeSnippetFile {
        let data = try Data(contentsOf: url)
        var codeSnippet = try PropertyListDecoder().decode(CodeSnippet.self, from: data)
        let resourceValue = try url.resourceValues(forKeys: [.contentModificationDateKey])
        if let contentModificationDate = resourceValue.contentModificationDate {
            codeSnippet.modifiedDate = contentModificationDate
        }
        return CodeSnippetFile(url: url, model: codeSnippet)
    }
}
