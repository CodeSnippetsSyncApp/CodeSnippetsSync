//
//  CodeSnippet.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/28.
//

import Foundation

struct CodeSnippet: Codable {
    let completionPrefix: String

    let completionScopes: [String]

    let contents: String

    let identifier: String

    let language: String

    let summary: String

    let title: String

    let userSnippet: Bool

    let version: Int

    let platformFamily: String?

    var cloudKitSystemFields: Data?

    var modifiedDate: Date = .now
}

extension CodeSnippet {
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
