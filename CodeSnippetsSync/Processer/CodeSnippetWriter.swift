//
//  CodeSnippetWriter.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation

struct CodeSnippetWriter {
    enum Format {
        case title
        case id
        case custom(String)

        func filename(for codeSnippet: CodeSnippet) -> String {
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

    let directory: URL

    let codeSnippets: [CodeSnippet]

    let filenameFormat: Format

    func write() async throws {
        try await withCheckedThrowingContinuation { contiunation in
            DispatchQueue.global().async {
                do {
                    for codeSnippet in codeSnippets {
                        let encoder = PropertyListEncoder()
                        encoder.outputFormat = .xml
                        let data = try encoder.encode(codeSnippet)
                        try data.write(to: directory.appendingPathComponent(filenameFormat.filename(for: codeSnippet)))
                    }
                    contiunation.resume()
                } catch {
                    contiunation.resume(throwing: error)
                }
            }
        }
    }
}

