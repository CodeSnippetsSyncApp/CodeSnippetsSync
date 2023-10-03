//
//  CodeSnippet+Language.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import Foundation

public extension CodeSnippet {
    enum Language: String, Codable {
        case c = "Xcode.SourceCodeLanguage.C" // swiftlint:disable:this identifier_name
        case cPlusPlus = "Xcode.SourceCodeLanguage.C-Plus-Plus"
        case generic = "Xcode.SourceCodeLanguage.Generic"
        case javascript = "Xcode.SourceCodeLanguage.JavaScript"
        case json = "Xcode.SourceCodeLanguage.JSON"
        case plain = "Xcode.SourceCodeLanguage.Plain"
        case markdown = "Xcode.SourceCodeLanguage.Markdown"
        case objc = "Xcode.SourceCodeLanguage.Objective-C"
        case python = "Xcode.SourceCodeLanguage.Python"
        case regularExpression = "Xcode.SourceCodeLanguage.RegularExpression"
        case rcProject = "Xcode.SourceCodeLanguage.RC-Project"
        case swift = "Xcode.SourceCodeLanguage.Swift"
        case xml = "Xcode.SourceCodeLanguage.XML"

        public var stringValue: String {
            switch self {
            case .c:
                "C"
            case .cPlusPlus:
                "C++"
            case .generic:
                "Generic"
            case .javascript:
                "JavaScript"
            case .json:
                "JSON"
            case .plain:
                "Plain"
            case .markdown:
                "Markdown"
            case .objc:
                "Objective-C"
            case .python:
                "Python"
            case .regularExpression:
                "RegularExpression"
            case .rcProject:
                "RC-Project"
            case .swift:
                "Swift"
            case .xml:
                "XML"
            }
        }
    }
}
