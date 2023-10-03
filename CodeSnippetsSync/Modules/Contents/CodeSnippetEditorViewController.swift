//
//  CodeSnippetsEditorViewController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/30.
//

import AppKit
import SnapKit
import STTextView
import NeonPlugin
import AppKitToolbox
import StackViewBuilder
import ViewHierarchyBuilder
import NSAttributedStringBuilder
import ViewPlus
import CodeSnippetsSyncResources

class CodeSnippetEditorViewController: XiblessViewController<NSView> {
    let scrollView = NSScrollView()

    let textView = STTextView()

    let editButton = NSButton(title: "Edit", alternateTitle: "Done", buttonType: .toggle)

    let copyButton = NSButton(title: L10n.Editor.copyCodeSnippet)
    
    let infoView = CodeSnippetInfoView()
    
    let titleLabel = NSTextField(labelWithString: "")

    let summaryLabel = NSTextField(labelWithString: "")

    lazy var headerStackView = VStackView(alignment: .left) {
        titleLabel
        Spacer(spacing: 5)
        summaryLabel
    }

    lazy var controlStackView = HStackView(distribution: .gravityAreas, alignment: .centerY) {
        infoView
            .gravity(.center)
        VStackView {
            copyButton
                .gravity(.bottom)
        }
        .size(width: copyButton.intrinsicContentSize.width, height: 140)
        .gravity(.trailing)
        Spacer(spacing: 10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.hierarchy {
            headerStackView
            scrollView
            controlStackView
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(11)
            make.height.equalTo(60)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom)
            make.left.right.equalToSuperview().inset(11)
            make.bottom.equalTo(controlStackView.snp.top)
        }

        controlStackView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            
        }

        scrollView.do {
            $0.drawsBackground = false
            $0.hasHorizontalScroller = false
            $0.hasVerticalScroller = true
            $0.documentView = textView
            $0.wantsLayer = true
            $0.layer?.do {
                $0.cornerRadius = 5
            }
        }

        textView.do {
            $0.font = .monospacedSystemFont(ofSize: 13, weight: .medium)
            $0.string = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
            $0.textContainer.do {
                $0.widthTracksTextView = true
            }
            $0.showsInvisibleCharacters = false
            $0.widthTracksTextView = true
            $0.selectedLineHighlightColor = #colorLiteral(red: 0.2651031613, green: 0.2714414895, blue: 0.3192448616, alpha: 0.301919)
            $0.backgroundColor = #colorLiteral(red: 0.1254901588, green: 0.1254902184, blue: 0.1490196586, alpha: 1)
            $0.delegate = self
            $0.isEditable = false
            $0.isSelectable = false
            $0.highlightSelectedLine = false
            $0.addPlugin(NeonPlugin(theme: .xcodeDark))
        }

        editButton.do {
            $0.isEnabled = false
            $0.box.setTarget(self, action: #selector(handleEditButtonAction(_:)))
        }
        
        copyButton.do {
            $0.box.setTarget(self, action: #selector(handleCopyButtonClickAction(_:)))
        }
        
        titleLabel.do {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.placeholderString = "Title"
        }
        
        summaryLabel.do {
            $0.placeholderString = "Summary"
        }
    }

    @objc func handleEditButtonAction(_ button: NSButton) {
        switch button.state {
        case .on:
            textView.isEditable = true
        case .off:
            textView.isEditable = false
        default:
            break
        }
    }
    
    @objc func handleCopyButtonClickAction(_ button: NSButton) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textView.string, forType: .string)
    }
}

extension CodeSnippetEditorViewController: STTextViewDelegate {
    func textViewDidChangeText(_ notification: Notification) {}
}

extension CodeSnippetEditorViewController: CodeSnippetListViewControllerDelegate {
    func codeSnippetList(_ controller: CodeSnippetListViewController, didSelectCodeSnippet codeSnippet: CodeSnippet) {
        textView.string = codeSnippet.contents
        textView.didChangeText()
        textView.highlightSelectedLine = !codeSnippet.contents.isEmpty
        textView.isSelectable = true
        editButton.isEnabled = !codeSnippet.contents.isEmpty
        titleLabel.stringValue = codeSnippet.title
        summaryLabel.stringValue = codeSnippet.summary
        infoView.setCodeSnippet(codeSnippet)
    }
}

public extension Theme {
    static let xcodeDark = Theme(
        [
            "string": Theme.Value(color: Color(#colorLiteral(red: 1, green: 0.3744247854, blue: 0.3892405927, alpha: 1)), font: nil),
            "string.special": Theme.Value(color: Color(#colorLiteral(red: 1, green: 0.3744247854, blue: 0.3892405927, alpha: 1)), font: nil),
            "number": Theme.Value(color: Color(#colorLiteral(red: 1, green: 0.9162481427, blue: 0.5002774596, alpha: 1)), font: nil),
            "keyword": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "include": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "constructor": Theme.Value(color: Color(NSColor.textColor), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "keyword.function": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "keyword.return": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "variable.builtin": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "boolean": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "conditional": Theme.Value(color: Color(#colorLiteral(red: 0.9816588759, green: 0.2585779428, blue: 0.6076546311, alpha: 1)), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .bold))),
            "type": Theme.Value(color: Color(#colorLiteral(red: 0.7107879519, green: 0.9934571385, blue: 0.9343662858, alpha: 1)), font: nil),
            "function.call": Theme.Value(color: Color(#colorLiteral(red: 0.3918398023, green: 0.8417144418, blue: 0.7543572783, alpha: 1)), font: nil),
            "function.macro": Theme.Value(color: Color(#colorLiteral(red: 1, green: 0.6314126849, blue: 0.3108865619, alpha: 1)), font: nil),
            "variable": Theme.Value(color: Color(NSColor.textColor), font: nil),
            "property": Theme.Value(color: Color(#colorLiteral(red: 0.2426597476, green: 0.7430019975, blue: 0.8773110509, alpha: 1)), font: nil),
            "method": Theme.Value(color: Color(#colorLiteral(red: 0.2426597476, green: 0.7430019975, blue: 0.8773110509, alpha: 1)), font: nil),
            "parameter": Theme.Value(color: Color(NSColor.textColor), font: nil),
            "comment": Theme.Value(color: Color(#colorLiteral(red: 0.4976348877, green: 0.5490466952, blue: 0.6000126004, alpha: 1)), font: nil),
            "spell": Theme.Value(color: Color(#colorLiteral(red: 0.4976348877, green: 0.5490466952, blue: 0.6000126004, alpha: 1)), font: nil),
            "operator": Theme.Value(color: Color(NSColor.textColor), font: nil),
            "punctuation.bracket": Theme.Value(color: Color(.textColor), font: nil),
            .default: Theme.Value(color: Color(NSColor.textColor), font: Font(NSFont.monospacedSystemFont(ofSize: 0, weight: .regular))),
        ]
    )
}
