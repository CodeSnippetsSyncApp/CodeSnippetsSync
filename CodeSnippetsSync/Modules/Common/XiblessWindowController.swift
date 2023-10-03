//
//  WindowController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import AppKit

class XiblessWindowController<Window: NSWindow>: NSWindowController {
    lazy var contentWindow = Window()

    init() {
        super.init(window: nil)
        window = contentWindow
        setupWindow()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWindow() {}
}
