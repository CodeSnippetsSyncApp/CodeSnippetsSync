//
//  AppStatusItemController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/9/30.
//

import AppKit
import StatusItemController
import MenuBuilder
import CodeSnippetsSyncResources

class MainStatusItemController: StatusItemController {
    public static let shared = MainStatusItemController()

    private init() {
        super.init(image: SymbolBuilder(.curlybraces).font(16, weight: .regular).build())
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
                .image(SymbolBuilder(.arrowTriangle2Circlepath).build())
                .onSelect {
                    Storage.shared.dispatch(.fetchCloudChanges)
                }
            MenuItem(L10n.MainStatusItem.showMainWindow)
                .image(SymbolBuilder(.gaugeMedium).build())
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
                .image(SymbolBuilder(.power).build())
                .onSelect { [unowned self] in
                    quit()
                }
        }
    }
}
