//
//  AllSatisfy.swift
//  FormMaster
//
//  Created by JH on 2023/5/29.
//  Copyright © 2023 FormMaster. All rights reserved.
//

import Foundation

@resultBuilder
enum AllSatisfy {
    static func buildBlock(_ components: Bool...) -> Bool {
        return components.reduce(true) { $0 && $1 }
    }

    static func buildEither(first component: Bool) -> Bool {
        return component
    }

    static func buildEither(second component: Bool) -> Bool {
        return component
    }

    static func buildOptional(_ component: Bool?) -> Bool {
        return false
    }

    static func buildArray(_ components: [Bool]) -> Bool {
        return components.allSatisfy { $0 }
    }
}
