//
//  Availability.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/28.
//

import Foundation

extension CodeSnippet {
    enum Availability: String, Codable {
        case all = "All"
        case classImplementation = "ClassImplementation"
        case codeExpression = "CodeExpression"
        case codeBlock = "CodeBlock"
        case stringOrComment = "StringOrComment"
        case topLevel = "TopLevel"

        var stringValue: String {
            switch self {
            case .all:
                "All Scopes"
            default:
                rawValue
            }
        }
    }
}

extension Array where Element == CodeSnippet.Availability {
    var stringValue: String {
        if isEmpty {
            Element.all.stringValue
        } else if count == 1 {
            first!.stringValue
        } else {
            "\(count) Scopes"
        }
    }
}
