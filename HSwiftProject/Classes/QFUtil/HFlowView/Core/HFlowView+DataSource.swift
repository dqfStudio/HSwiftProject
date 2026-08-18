//
//  HFlowView+DataSource.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  把 flowRow / flowHeader / flowFooter 接到 UIKit DataSource。
//

import UIKit

extension HFlowView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = flowDelegate?.numberOfSectionsInFlowView?() ?? 1
        return max(sections, 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = flowDelegate?.numberOfRowsInSection?(section) ?? 0
        return max(rows, 0)
    }

    /// 先调 `flowRow`（内部 `reuseCell` 写入本次待返回实例），再把同一实例返回给 UIKit。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        pendingReuseCell = nil
        flowDelegate?.flowRow?(self, atIndexPath: indexPath)
        if let cell = pendingReuseCell {
            pendingReuseCell = nil
            cell.applyLayout()
            return cell
        }

        #if DEBUG
        assertionFailure("flowRow 必须调用 reuseCell(_:_:_:) 取出 cell")
        #endif

        let cellIdentifier = NSStringFromClass(HFlowBaseCell.self)
        if !allCellIdentifiers.contains(cellIdentifier) {
            allCellIdentifiers.insert(cellIdentifier)
            register(HFlowBaseCell.self, forCellReuseIdentifier: cellIdentifier)
        }
        let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HFlowBaseCell ?? HFlowBaseCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.indexPath = indexPath
        cell.flow = self
        cell.applyLayout()
        return cell
    }

    /// 先调 `flowHeader`。未调用 `reuseHeader` 则返回 nil（UITableView 允许）。
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        pendingReuseHeader = nil
        flowDelegate?.flowHeader?(self, inSection: section)
        if let header = pendingReuseHeader {
            pendingReuseHeader = nil
            header.applyLayout()
            return header
        }
        return nil
    }

    /// 先调 `flowFooter`。未调用 `reuseFooter` 则返回 nil。
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        pendingReuseFooter = nil
        flowDelegate?.flowFooter?(self, inSection: section)
        if let footer = pendingReuseFooter {
            pendingReuseFooter = nil
            footer.applyLayout()
            return footer
        }
        return nil
    }
}
