//
//  MainSplitViewController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/30.
//

import AppKit
import SnapKit
import DSFToolbar
import CodeSnippetsSyncResources

class MainSplitViewController: NSSplitViewController {

    let listViewController = CodeSnippetListViewController()

    let editorViewController = CodeSnippetEditorViewController()

    var toolbarContainer: DSFToolbar?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = .init(x: 0, y: 0, width: 1280, height: 800)

        addSplitViewItem(NSSplitViewItem(sidebarWithViewController: listViewController))

        addSplitViewItem(NSSplitViewItem(viewController: editorViewController))

        listViewController.view.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(272)
        }

        editorViewController.view.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(500)
        }

        listViewController.delegate = editorViewController
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        DSFToolbar("Main.Toolbar", allowsUserCustomization: false) {
            DSFToolbar.Item(.sidebar)
                .label(L10n.MainWindow.Toolbar.sidebar)
                .tooltip(L10n.MainWindow.Toolbar.sidebar)
                .image(SymbolBuilder(.sidebarLeft).font(16, weight: .regular).build())
                .isBordered(true)
                .action { [weak self] _ in
                    guard let self = self else { return }
                    toggleSidebar(nil)
                }

            DSFToolbar.Item(.sidebarTrackingSeparator)

            DSFToolbar.View(.accountStatus, viewController: AccountStatusViewController())
                .label(L10n.MainWindow.Toolbar.iCloudStatus)
                .tooltip(L10n.MainWindow.Toolbar.iCloudStatus)
                .usingAppKitToolbarItem {
                    $0.isNavigational = true
                }

            DSFToolbar.Button(.forceSync)
                .label(L10n.MainWindow.Toolbar.forceSync)
                .tooltip(L10n.MainWindow.Toolbar.forceSync)
                .buttonType(.momentaryChange)
                .image(SymbolBuilder(.arrowTriangle2Circlepath).font(16, weight: .regular).build())
                .action { _ in

                    Storage.shared.dispatch(.fetchCloudChanges)
                }
                .width(minVal: 40)
        }
        .displayMode(.iconOnly)
        .attach(to: view, for: \.window)
        .store(in: self, for: \.toolbarContainer)
    }
}

public extension DSFToolbar {
    @discardableResult
    func attach<Object: AnyObject>(to object: Object?, for keyPath: KeyPath<Object, NSWindow?>) -> Self {
        attachedWindow = object?[keyPath: keyPath]
        return self
    }

    @discardableResult
    func store<Object: AnyObject>(in object: Object?, for keyPath: ReferenceWritableKeyPath<Object, DSFToolbar?>) -> Self {
        object?[keyPath: keyPath] = self
        return self
    }
}

extension NSToolbarItem.Identifier {
    static let sidebar = makeToolbarItemIdentifier("sidebar")
    static let uploadToCloud = makeToolbarItemIdentifier("uploadToCloud")
    static let forceSync = makeToolbarItemIdentifier("forceSync")
    static let accountStatus = makeToolbarItemIdentifier("accountStatus")
    private static func makeToolbarItemIdentifier(_ name: String) -> Self {
        .init("\(MainWindowController.self).\(NSToolbarItem.Identifier.self).\(name)")
    }
}
