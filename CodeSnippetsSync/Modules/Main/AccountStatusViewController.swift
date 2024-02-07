//
//  AccountStatusView.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/9/30.
//

import AppKit
import Combine
import SnapKit
import SFSymbol
import UIFoundation
import UIFoundationToolbox
import FrameworkToolbox
import ViewHierarchyBuilder
import CodeSnippetsSyncCore
import CodeSnippetsSyncResources

class AccountStatusViewController: XiblessViewController<NSView> {
    let indicator = NSView()

    let titleLabel = NSTextField(labelWithString: "")

    let imageView = NSImageView()

    lazy var contentStackView = HStackView {
        indicator
            .size(width: 10, height: 10)
        Spacer(spacing: 10)
        titleLabel
        Spacer(spacing: 10)
        imageView
    }

    var cancellables: Set<AnyCancellable> = []


    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.hierarchy {
            contentStackView
        }

        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        indicator.do {
            $0.wantsLayer = true
            $0.layer?.cornerRadius = 5
        }

        titleLabel.do {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .labelColor
        }

        Storage.shared.$accountStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                updateAccountStatus()
            }
            .store(in: &cancellables)

        updateAccountStatus()
    }

    func updateAccountStatus() {
        indicator.layer?.backgroundColor = Storage.shared.accountStatus.statusColor.cgColor
        titleLabel.stringValue = Storage.shared.accountStatus.stringValue
        imageView.image = SFSymbol(systemName: Storage.shared.accountStatus.statusSymbolName).pointSize(19, weight: .regular).nsImage
    }
}

extension AccountStatus {
    var stringValue: String {
        switch self {
        case .available:
            L10n.AccountStatus.available
        case .couldNotDetermine:
            L10n.AccountStatus.couldNotDetermine
        case .noAccount:
            L10n.AccountStatus.noAccount
        case .restricted:
            L10n.AccountStatus.restricted
        case .unknown:
            L10n.AccountStatus.unknown
        }
    }

    var statusColor: NSColor {
        switch self {
        case .unknown:
            "#61625E".nsColor
        case .available:
            "#61C453".nsColor
        case .couldNotDetermine,
             .restricted:
            "#F4BE4F".nsColor
        case .noAccount:
            "#EC6A5E".nsColor
        }
    }

    var statusSymbolName: SFSymbol.SystemSymbolName {
        switch self {
        case .unknown:
            .boltHorizontalIcloud
        case .available:
            .checkmarkIcloud
        case .couldNotDetermine,
             .restricted:
            .exclamationmarkIcloud
        case .noAccount:
            .xmarkIcloud
        }
    }
}
