//
//  CodeSnippetWriter.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation

public struct CodeSnippetWriter: Logging {
    public static let log = makeLogger()

    public enum Format {
        case title
        case id
        case custom(String)

        public func filename(for codeSnippet: CodeSnippet) -> String {
            switch self {
            case .title:
                return "\(codeSnippet.title).\(CodeSnippet.fileExtension)"
            case .id:
                return "\(codeSnippet.identifier).\(CodeSnippet.fileExtension)"
            case let .custom(string):
                return "\(string).\(CodeSnippet.fileExtension)"
            }
        }
    }

    public let directory: URL

    public let codeSnippets: [CodeSnippet]

    public let filenameFormat: Format

    public func write() async -> [CodeSnippetFile] {
        await withCheckedContinuation { contiunation in
            DispatchQueue.global().async {
                var results: [CodeSnippetFile] = []

                for codeSnippet in codeSnippets {
                    do {
                        let encoder = PropertyListEncoder()
                        encoder.outputFormat = .xml
                        let data = try encoder.encode(codeSnippet)
                        let writeURL = directory.appendingPathComponent(filenameFormat.filename(for: codeSnippet))
                        try data.write(to: writeURL)
                        results.append(.init(url: writeURL, model: codeSnippet))
                    } catch {
                        log.error("\(error)")
                    }
                }

                contiunation.resume(returning: results)
            }
        }
    }
}
