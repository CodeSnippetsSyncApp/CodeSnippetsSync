//
//  ViewController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/30.
//

import AppKit

class XibViewController: NSViewController {
    init() {
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
