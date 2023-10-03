//
//  Comparable.swift
//  CodeSnippetsSync
//
//  Created by JH on 2023/10/3.
//

import Foundation

extension CodeSnippet: Comparable {
    public static func < (lhs: CodeSnippet, rhs: CodeSnippet) -> Bool {
        lhs.title < rhs.title
    }
}
