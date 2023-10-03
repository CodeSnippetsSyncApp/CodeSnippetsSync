//
//  AppNavigator.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/9/24.
//

import Foundation
import AppKit
import Combine

class Navigator {
    static let shared = Navigator()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        Sandbox.shared.$status
            .dropFirst()
            .sink { [unowned self] status in
                switch status {
                case .available:
                    closeWindow(forScene: .authorization)
                    showWindow(forScene: .main)
                default:
                    closeWindow(forScene: .main)
                    showWindow(forScene: .authorization)
                }
            }
            .store(in: &cancellables)
    }

    enum WindowScene {
        case authorization
        case main
    }

    enum ViewScene {
        case sync
    }

    enum Transition {
        case modal
        case sheet
        case popover(positioningRect: NSRect, positioningView: NSView, preferredEdge: NSRectEdge, behavior: NSPopover.Behavior)
    }

    private var windowControllers: [WindowScene: NSWindowController] = [:]

    private func viewController(forScene scene: ViewScene) -> NSViewController {
        return NSViewController()
    }

    private func windowController(forScene scene: WindowScene) -> NSWindowController {
        if let windowController = windowControllers[scene] {
            return windowController
        }
        let windowController: NSWindowController
        switch scene {
        case .authorization:
            windowController = StoryboardScene.Authorization.authorizationWindowController.instantiate()
        case .main:
            windowController = MainWindowController()
        }
        windowControllers[scene] = windowController
        return windowController
    }

    func showWindow(forScene scene: WindowScene) {
        windowController(forScene: scene).showWindow(self)
    }

    func showWindowAccordingAuthorizationStatus() {
        switch Sandbox.shared.status {
        case .available:
            showWindow(forScene: .main)
        default:
            showWindow(forScene: .authorization)
        }
    }

    func closeWindow(forScene scene: WindowScene) {
        windowController(forScene: scene).close()
    }

    func present(forScene scene: ViewScene, sender: NSViewController, transition: Transition, preferredContentSize: NSSize) {
        let showViewController = viewController(forScene: scene)
        showViewController.preferredContentSize = preferredContentSize
        switch transition {
        case .modal:
            sender.presentAsModalWindow(showViewController)
        case .sheet:
            sender.presentAsSheet(showViewController)
        case let .popover(positioningRect: positioningRect, positioningView: positioningView, preferredEdge: preferredEdge, behavior: behavior):
            sender.present(showViewController, asPopoverRelativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge, behavior: behavior)
        }
    }

    func dismiss(sender: NSViewController) {
        sender.dismiss(self)
    }
}
