//
//  AuthorizationViewController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/1.
//

import AppKit
import MagicLoading
import CodeSnippetsSyncResources

class AuthorizationViewController: XibViewController {
    @MagicViewLoading @IBOutlet var titleLabel: NSTextField
    @MagicViewLoading @IBOutlet var detailLabel: NSTextField
    @MagicViewLoading @IBOutlet var authorizationButton: NSButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.stringValue = L10n.Authorization.title
        detailLabel.stringValue = L10n.Authorization.detail
        authorizationButton.title = L10n.Authorization.authorization
    }
    
    
    @IBAction func performAuthorize(_ sender: Any) {
        Sandbox.shared.authorize()
    }
}
