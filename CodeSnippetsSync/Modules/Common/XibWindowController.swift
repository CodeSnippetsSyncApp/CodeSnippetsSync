//
//  XibWindowController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import AppKit

class XibWindowController: NSWindowController {
    override var windowNibName: NSNib.Name? { String(describing: Self.self) }
}
