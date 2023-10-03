//
//  CodeSnippetCellView.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/30.
//

import AppKit
import SnapKit
import StackViewBuilder

extension CodeSnippetListViewController {
    class CellView: NSTableCellView {
        let titleLabel = NSTextField(labelWithString: "")

        let iconImageView = NSImageView()

        lazy var stackView = HStackView(spacing: 0) {
            iconImageView
                .contentHugging(h: 251)
            Spacer(spacing: 10)
            titleLabel
                .contentCompressionResistance(h: 749)
        }

        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            identifier = .init(String(describing: Self.self))

            addSubview(stackView)

            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            titleLabel.do {
                $0.textColor = .labelColor
                $0.font = .systemFont(ofSize: 14, weight: .regular)
            }

            iconImageView.do {
                $0.image = SymbolBuilder(.curlybracesSquareFill).hierarchicalColor(.labelColor).font(30, weight: .medium).build()
            }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(for codeSnippet: CodeSnippet) {
            titleLabel.stringValue = codeSnippet.title
        }
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, xrOS 1.0, *)
#Preview {
    CodeSnippetListViewController.CellView().then {
        $0.titleLabel.stringValue = "Title"
    }
}
