//
//  Window.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import AppKit

class Window: NSWindow {
    init() {
        super.init(
            contentRect: .zero,
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .resizable,
                .fullSizeContentView,
            ],
            backing: .buffered,
            defer: false
        )
        isReleasedWhenClosed = false
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }
}
