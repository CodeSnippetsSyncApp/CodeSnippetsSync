//
//  Preferences.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import Foundation
import Defaults

enum Preferences {
    @Default<Data?>(.init("workingDirectoryBookmark", default: nil))
    static var workingDirectoryBookmark: Data?
}
