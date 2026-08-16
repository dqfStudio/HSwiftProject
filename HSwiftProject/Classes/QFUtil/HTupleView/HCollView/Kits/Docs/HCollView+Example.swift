//
//  HCollView+Example.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//
//  演示代理数据、空态、下拉刷新 / 上拉加载。
//

import UIKit

/// 演示代理数据、空态、下拉刷新 / 上拉加载。
final class HCollViewExampleViewController: UIViewController, HCollViewDelegate {

    private var items: [String] = []
    private lazy var collView = HCollView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "HCollView Example"

        collView.frame = view.bounds
        collView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collView.delegate = self
        collView.apply(HCollViewConfig(pageSize: 10, totalNo: 25))
        view.addSubview(collView)

        let empty = UILabel()
        empty.text = "暂无数据"
        empty.textAlignment = .center
        empty.textColor = .secondaryLabel
        collView.emptyView = empty

        collView.refreshBlock = { [weak self] in
            self?.reloadFirstPage()
        }
        collView.loadMoreBlock = { [weak self] in
            self?.loadNextPage()
        }

        reloadFirstPage()
    }

    private func reloadFirstPage() {
        items = (0..<10).map { "Item \($0)" }
        collView.pageNo = 1
        collView.reloadData()
        collView.endRefreshing {}
    }

    private func loadNextPage() {
        let start = items.count
        items.append(contentsOf: (start..<(start + 10)).map { "Item \($0)" })
        collView.reloadData()
        collView.endLoadMore {}
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        items.count
    }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: collView.width(for: indexPath.section), height: 56)
    }

    func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath) {
        let cell = coll.reuseCell(HCollBaseCell.self, false, indexPath)
        cell.contentView.backgroundColor = .secondarySystemBackground
        if cell.contentView.viewWithTag(101) == nil {
            let label = UILabel(frame: cell.contentView.bounds.insetBy(dx: 16, dy: 0))
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.tag = 101
            cell.contentView.addSubview(label)
        }
        (cell.contentView.viewWithTag(101) as? UILabel)?.text = items[indexPath.item]
    }
}
