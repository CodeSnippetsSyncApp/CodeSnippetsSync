//
//  CodeSnippet.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/28.
//

import Foundation

public struct CodeSnippet: Codable {
    public let completionPrefix: String

    public let completionScopes: [String]

    public let contents: String

    public let identifier: String

    public let language: String

    public let summary: String

    public let title: String

    public let userSnippet: Bool

    public let version: Int

    public let platformFamily: String?

    public var cloudKitSystemFields: Data?

    public var modifiedDate: Date = .now
}

public extension CodeSnippet {
    var availabilitys: [Availability] {
        completionScopes.compactMap { Availability(rawValue: $0) }
    }

    var platform: Platform {
        if let rawValue = platformFamily, let platform = Platform(rawValue: rawValue) {
            platform
        } else {
            .all
        }
    }

    var sourceLanguage: Language {
        Language(rawValue: language) ?? .plain
    }

    static let fileExtension: String = "codesnippet"
}
