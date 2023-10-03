//
//  CodeSnippet+Codable.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import Foundation

public extension CodeSnippet {
    enum CodingKeys: String, CodingKey {
        case completionPrefix = "IDECodeSnippetCompletionPrefix"
        case completionScopes = "IDECodeSnippetCompletionScopes"
        case contents = "IDECodeSnippetContents"
        case identifier = "IDECodeSnippetIdentifier"
        case language = "IDECodeSnippetLanguage"
        case summary = "IDECodeSnippetSummary"
        case title = "IDECodeSnippetTitle"
        case userSnippet = "IDECodeSnippetUserSnippet"
        case version = "IDECodeSnippetVersion"
        case platformFamily = "IDECodeSnippetPlatformFamily"
    }
}
