//
//  CodeSnippetInfoView.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/10/2.
//

import AppKit
import SnapKit
import StackViewBuilder
import ViewHierarchyBuilder
import CodeSnippetsSyncResources

class CodeSnippetInfoView: View {
    class InfoRowView: View {
        let titleLabel = NSTextField(labelWithString: "")
    
        let detailLabel = NSTextField(labelWithString: "")
        
//        lazy var contentStackView = HStackView(distribution: .equalSpacing) {
//            titleLabel
//                .gravity(.leading)
//            Spacer(spacing: 10)
//            detailLabel
//                .gravity(.trailing)
//        }

        init(title: String, detail: String) {
            super.init(frame: .zero)

            titleLabel.do {
                $0.stringValue = title
                $0.textColor = .secondaryLabelColor
                $0.alignment = .right
            }
            
            detailLabel.do {
                $0.stringValue = detail
                $0.textColor = .labelColor
                $0.alignment = .left
            }
            
//            hierarchy {
//                contentStackView
//            }
//            
//            contentStackView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
            
            hierarchy {
                titleLabel
                detailLabel
            }
            
            titleLabel.snp.makeConstraints { make in
                make.right.equalTo(snp.centerX).offset(-5)
                make.centerY.equalToSuperview()
            }
            
            detailLabel.snp.makeConstraints { make in
                make.left.equalTo(snp.centerX).offset(5)
                make.centerY.equalToSuperview()
            }
        }
        
        override var intrinsicContentSize: NSSize {
            let height = max(titleLabel.intrinsicContentSize.height, detailLabel.intrinsicContentSize.height)
            let width = titleLabel.intrinsicContentSize.width + detailLabel.intrinsicContentSize.width + 10
            return NSSize(width: width, height: height)
        }
    }

    let languageRowView = InfoRowView(title: L10n.CodeSnippetInfo.language, detail: L10n.CodeSnippetInfo.language)
    
    let platformRowView = InfoRowView(title: L10n.CodeSnippetInfo.platform, detail: L10n.CodeSnippetInfo.platform)
    
    let completionRowView = InfoRowView(title: L10n.CodeSnippetInfo.completion, detail: L10n.CodeSnippetInfo.completion)
    
    let availabilityRowView = InfoRowView(title: L10n.CodeSnippetInfo.availability, detail: L10n.CodeSnippetInfo.availability)
    
    lazy var contentStackView = VStackView {
        languageRowView
        Spacer(spacing: 10)
        platformRowView
        Spacer(spacing: 10)
        completionRowView
        Spacer(spacing: 10)
        availabilityRowView
    }

    init() {
        super.init(frame: .zero)

        hierarchy {
            contentStackView
        }

        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        print(contentStackView.intrinsicContentSize)
    }

    func setCodeSnippet(_ codeSnippet: CodeSnippet) {
        languageRowView.detailLabel.stringValue = codeSnippet.sourceLanguage.stringValue
        platformRowView.detailLabel.stringValue = codeSnippet.platform.stringValue
        completionRowView.detailLabel.stringValue = codeSnippet.completionPrefix
        availabilityRowView.detailLabel.stringValue = codeSnippet.availabilitys.stringValue
    }

    func clear() {
        languageRowView.detailLabel.stringValue = ""
        platformRowView.detailLabel.stringValue = ""
        completionRowView.detailLabel.stringValue = ""
        availabilityRowView.detailLabel.stringValue = ""
    }
    
    override var intrinsicContentSize: NSSize {
        contentStackView.fittingSize
    }
}
