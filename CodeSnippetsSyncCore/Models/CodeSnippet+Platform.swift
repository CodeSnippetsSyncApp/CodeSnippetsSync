//
//  PlatformFamily.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/28.
//

import Foundation

public extension CodeSnippet {
    enum Platform: String, Codable {
        case all = ""
        case driverKit = "driverkit"
        case iOS = "iphoneos"
        case macOS = "macosx"
        case tvOS = "appletvos"
        case watchOS = "watchos"

        public static var defaultValue: Self { .all }

        public var stringValue: String {
            switch self {
            case .all:
                "All"
            case .driverKit:
                "DriverKit"
            case .iOS:
                "iOS"
            case .macOS:
                "macOS"
            case .tvOS:
                "tvOS"
            case .watchOS:
                "watchOS"
            }
        }
    }
}
