//
//  View.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import AppKit

class View: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
