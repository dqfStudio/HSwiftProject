//
//  HFlowView+Example.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  演示代理数据、空态、下拉刷新 / 上拉加载。
//

import UIKit

/// 演示代理数据、空态、下拉刷新 / 上拉加载。
final class HFlowViewExampleViewController: UIViewController, HFlowViewDelegate {

    private var items: [String] = []
    private lazy var flowView = HFlowView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "HFlowView Example"

        flowView.frame = view.bounds
        flowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        flowView.delegate = self
        flowView.apply(HFlowViewConfig(pageSize: 10, totalNo: 25))
        view.addSubview(flowView)

        let empty = UILabel()
        empty.text = "暂无数据"
        empty.textAlignment = .center
        empty.textColor = .secondaryLabel
        flowView.emptyView = empty

        flowView.refreshBlock = { [weak self] in
            self?.reloadFirstPage()
        }
        flowView.loadMoreBlock = { [weak self] in
            self?.loadNextPage()
        }

        reloadFirstPage()
    }

    private func reloadFirstPage() {
        items = (0..<10).map { "Item \($0)" }
        flowView.pageNo = 1
        flowView.reloadData()
        flowView.endRefreshing {}
    }

    private func loadNextPage() {
        let start = items.count
        items.append(contentsOf: (start..<(start + 10)).map { "Item \($0)" })
        flowView.reloadData()
        flowView.endLoadMore {}
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        items.count
    }

    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        56
    }

    func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) {
        let cell = flow.reuseCell(HFlowBaseCell.self, false, indexPath)
        cell.contentView.backgroundColor = .secondarySystemBackground
        if cell.contentView.viewWithTag(101) == nil {
            let label = UILabel(frame: cell.contentView.bounds.insetBy(dx: 16, dy: 0))
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.tag = 101
            cell.contentView.addSubview(label)
        }
        (cell.contentView.viewWithTag(101) as? UILabel)?.text = items[indexPath.row]
    }
}
