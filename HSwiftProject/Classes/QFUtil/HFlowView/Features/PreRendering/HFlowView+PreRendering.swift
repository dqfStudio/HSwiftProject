//
//  HFlowView+PreRendering.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//
//  可选：系统 prefetch + 附近行图片尺寸预取。默认关闭（无业务 URL 源时默认开启只会空跑）。
//

import UIKit

private var hflowEnablePreRenderingKey: UInt8 = 0

extension HFlowView {

    private enum PreRenderingConstants {
        static let preRenderCount = 2
    }

    /// 默认关闭。打开后接管系统 `prefetchDataSource`；附近行尚无 cell 时只能预取已可见 URL。
    var enablePreRendering: Bool {
        get { (objc_getAssociatedObject(self, &hflowEnablePreRenderingKey) as? NSNumber)?.boolValue ?? false }
        set {
            objc_setAssociatedObject(self, &hflowEnablePreRenderingKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applyPreRenderingEnabled()
        }
    }

    /// Core `setup` 钩子，选择器名勿改。
    @objc func hflow_prerender_setup() {
        applyPreRenderingEnabled()
    }

    /// Core `willDisplay` 钩子，选择器名勿改。
    @objc func hflow_prerender_willDisplay(_ indexPath: IndexPath) {
        guard enablePreRendering else { return }
        prefetchNearbyRows(around: indexPath)
    }

    @objc func hflow_prerender_didScroll() {
        guard enablePreRendering else { return }
        if !isDragging && !isDecelerating {
            preRenderVisibleCells()
        }
    }

    @objc func hflow_prerender_clear() {}

    func preRenderVisibleCells() {
        guard enablePreRendering else { return }
        for indexPath in indexPathsForVisibleRows ?? [] {
            prefetchNearbyRows(around: indexPath)
        }
    }

    func preRenderCells(at indexPaths: [IndexPath]) {
        guard enablePreRendering else { return }
        let valid = validRowIndexPaths(from: indexPaths)
        guard let first = valid.first else { return }
        invokeFeature(HFlowFeatureSelector.imageSizeWillDisplay, with: first)
    }

    private func applyPreRenderingEnabled() {
        isPrefetchingEnabled = enablePreRendering
        prefetchDataSource = enablePreRendering ? self : nil
    }

    private func prefetchNearbyRows(around indexPath: IndexPath) {
        var paths: [IndexPath] = []
        let count = PreRenderingConstants.preRenderCount
        let rows = numberOfRows(inSection: indexPath.section)
        for i in 1...count {
            let next = IndexPath(row: indexPath.row + i, section: indexPath.section)
            if next.row < rows { paths.append(next) }
            let prev = IndexPath(row: indexPath.row - i, section: indexPath.section)
            if prev.row >= 0 { paths.append(prev) }
        }
        guard let first = paths.first else { return }
        invokeFeature(HFlowFeatureSelector.imageSizeWillDisplay, with: first)
    }
}

extension HFlowView: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard enablePreRendering, let first = indexPaths.first else { return }
        invokeFeature(HFlowFeatureSelector.imageSizeWillDisplay, with: first)
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {}
}
