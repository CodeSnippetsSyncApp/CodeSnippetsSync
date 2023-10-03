//
//  MainWindowController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/26.
//

import AppKit
import AppKitToolbox

class MainWindowController: XiblessWindowController<Window>, NSWindowDelegate, Logging {
    static let log = makeLogger()

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
