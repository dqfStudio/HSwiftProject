//
//  HFlowView+Reload.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  reloadData 尾部防抖，以及短时间多次 row 刷新合并成一次 reloadRows。
//

import UIKit

extension HFlowView {

    /// 短时间内多次调用只 `reloadData` 一次（尾部防抖）。默认用 `refreshThrottleInterval`。
    func reloadIfNeeded(_ delay: TimeInterval? = nil) {
        scheduleWork(&reloadWorkItem, delay: delay ?? refreshThrottleInterval) { [weak self] in
            self?.reloadData()
        }
    }

    /// 把多次 row 刷新合并成一次 `reloadRows`。间隔默认 `itemRefreshThrottleInterval`。
    /// 防抖期间数据若已变，非法 indexPath 会改走 `reloadData`，避免越界崩溃。
    func reloadItemsIfNeeded(at indexPaths: [IndexPath], _ delay: TimeInterval? = nil) {
        guard !indexPaths.isEmpty else { return }
        pendingItemReloads.formUnion(indexPaths)
        scheduleWork(&itemReloadWorkItem, delay: delay ?? itemRefreshThrottleInterval) { [weak self] in
            guard let self else { return }
            let items = Array(self.pendingItemReloads)
            self.pendingItemReloads.removeAll()
            guard !items.isEmpty else { return }
            let valid = self.validRowIndexPaths(from: items)
            if valid.count != items.count {
                self.reloadData()
                return
            }
            self.reloadRows(at: valid, with: .none)
        }
    }

    /// 保证在主线程 `reloadData`。
    func reloadFlowData() {
        if Thread.isMainThread {
            reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }

    override func reloadData() {
        lastPreloadTriggered = false
        super.reloadData()
        invokeFeature(HFlowFeatureSelector.emptyReloadData)
    }

    /// 取消上一次尚未执行的任务，再按 delay 重新排队。
    private func scheduleWork(_ item: inout DispatchWorkItem?, delay: TimeInterval, block: @escaping () -> Void) {
        item?.cancel()
        let work = DispatchWorkItem(block: block)
        item = work
        DispatchQueue.main.asyncAfter(deadline: .now() + max(delay, 0), execute: work)
    }
}
