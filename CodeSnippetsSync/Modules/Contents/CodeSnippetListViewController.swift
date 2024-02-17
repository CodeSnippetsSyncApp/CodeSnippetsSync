//
//  MainViewController.swift
//  XcodeSnippetsSync
//
//  Created by JH on 2023/8/29.
//

import AppKit
import SnapKit
import Combine
import UIFoundation
import UIFoundationToolbox
import CodeSnippetsSyncCore

protocol CodeSnippetListViewControllerDelegate: AnyObject {
    func codeSnippetList(_ controller: CodeSnippetListViewController, didSelectCodeSnippet codeSnippet: CodeSnippet)
}

class CodeSnippetListViewController: XiblessViewController<NSView> {
    weak var delegate: CodeSnippetListViewControllerDelegate?

    let tableView = SingleColumnTableView()

    let scrollView = NSScrollView()

    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        contentView.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.do {
            $0.drawsBackground = false
            $0.documentView = tableView
            $0.hasVerticalScroller = true
        }

        tableView.do {
            $0.dataSource = self
            $0.delegate = self
        }

        Storage.shared.$codeSnippets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension CodeSnippetListViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Storage.shared.codeSnippets.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let codeSnippet = Storage.shared.codeSnippets[row]
        let cellView = tableView.box.makeView(withType: CellView.self, onwer: self)
        cellView.configure(for: codeSnippet)
        return cellView
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        50
    }

    func tableViewSelectionIsChanging(_ notification: Notification) {
        delegate?.codeSnippetList(self, didSelectCodeSnippet: Storage.shared.codeSnippets[tableView.selectedRow])
    }
}
