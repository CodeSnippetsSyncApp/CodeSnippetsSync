//
//  CodeSnippet+Hashable.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import Foundation

extension CodeSnippet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(completionPrefix)
        hasher.combine(completionScopes)
        hasher.combine(contents)
        hasher.combine(identifier)
        hasher.combine(language)
        hasher.combine(summary)
        hasher.combine(title)
        hasher.combine(userSnippet)
        hasher.combine(version)
        hasher.combine(platformFamily)
    }

    @AllSatisfy
    static func == (lhs: CodeSnippet, rhs: CodeSnippet) -> Bool {
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.completionPrefix)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.completionScopes)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.contents)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.identifier)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.language)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.summary)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.title)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.userSnippet)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.version)
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.platformFamily)
    }

    static func isEqual<T, P: Equatable>(lhs: T, rhs: T, keyPath: KeyPath<T, P>) -> Bool {
        lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
    }
}
