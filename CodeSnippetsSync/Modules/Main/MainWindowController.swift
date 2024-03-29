//
//  MainWindowController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/26.
//

import AppKit
import UIFoundation

class MainWindowController: XiblessWindowController<Window>, NSWindowDelegate {

    lazy var mainSplitViewController = MainSplitViewController()

    override func setupWindow() {
        super.setupWindow()
        
        contentViewController = mainSplitViewController
        
        contentWindow.do {
            $0.titlebarAppearsTransparent = true
            $0.delegate = self
            $0.box.positionCenter()
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.setActivationPolicy(.accessory)
        return true
    }
}
