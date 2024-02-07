//
//  AppStatusItemController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/9/30.
//

import AppKit
import MenuBuilder
import StatusItemController
import CodeSnippetsSyncCore
import CodeSnippetsSyncResources
import SFSymbol

class MainStatusItemController: StatusItemController {
    public static let shared = MainStatusItemController()

    private init() {
        super.init(image: SFSymbol(systemName: .curlybraces).pointSize(16, weight: .regular).nsImage)
    }

    public func setup() {}

    override func leftClickAction() {
        openMenu()
    }

    override func rightClickAction() {
        openMenu()
    }

    override func buildMenu() -> NSMenu {
        NSMenu {
            MenuItem(L10n.MainStatusItem.forceSync)
                .image(SFSymbol(systemName: .arrowTriangle2Circlepath).nsImage)
                .onSelect {
                    Storage.shared.dispatch(.fetchCloudChanges)
                }
            MenuItem(L10n.MainStatusItem.showMainWindow)
                .image(SFSymbol(systemName: .gauge).nsImage)
                .onSelect {
                    NSApplication.shared.setActivationPolicy(.regular)
                    if #available(macOS 14.0, *) {
                        NSApplication.shared.activate()
                    } else {
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }

                    Navigator.shared.showWindowAccordingAuthorizationStatus()
                }
            MenuItem(L10n.MainStatusItem.quit)
                .image(SFSymbol(systemName: .power).nsImage)
                .onSelect { [unowned self] in
                    quit()
                }
        }
    }
}
