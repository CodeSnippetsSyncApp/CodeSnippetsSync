//
//  CodeSnippet+Hashable.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import Foundation

extension CodeSnippet: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    @AllSatisfy
    public static func == (lhs: CodeSnippet, rhs: CodeSnippet) -> Bool {
        isEqual(lhs: lhs, rhs: rhs, keyPath: \.identifier)
    }

    public static func isEqual<T, P: Equatable>(lhs: T, rhs: T, keyPath: KeyPath<T, P>) -> Bool {
        lhs[keyPath: keyPath] == rhs[keyPath: keyPath]
    }
}
