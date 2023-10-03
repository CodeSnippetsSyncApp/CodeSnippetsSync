//
//  AppDelegate.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/6/3.
//

import Cocoa
import Combine
import CodeSnippetsSyncCore

@main
final class AppDelegate: NSObject, NSApplicationDelegate, Logging {
    static let log = makeLogger()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Sandbox.shared.authorize()
        Navigator.shared.showWindowAccordingAuthorizationStatus()
        MainStatusItemController.shared.setup()
    }

    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
        Storage.shared.processRemoteChangeNotification(with: userInfo)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            Navigator.shared.showWindowAccordingAuthorizationStatus()
        }
        return true
    }
}
