//
//  HFlowView+Refresh.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  下拉刷新、上拉加载、接近底部预加载。依赖 MJRefresh。
//

import UIKit
import MJRefresh

typealias HFlowRefreshBlock = () -> Void
typealias HFlowLoadMoreBlock = () -> Void

private struct HFlowRefreshKeys {
    static var refreshBlock: UInt8 = 0
    static var loadMoreBlock: UInt8 = 0
    static var refreshHeaderStyle: UInt8 = 0
    static var refreshFooterStyle: UInt8 = 0
}

extension HFlowView {

    /// 赋值后自动挂下拉 header；置 nil 则卸掉。触发时会把 `pageNo` 重置为 1。
    var refreshBlock: HFlowRefreshBlock? {
        get { objc_getAssociatedObject(self, &HFlowRefreshKeys.refreshBlock) as? HFlowRefreshBlock }
        set {
            objc_setAssociatedObject(self, &HFlowRefreshKeys.refreshBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateRefreshHeader()
        }
    }

    /// 赋值后自动挂上拉 footer；置 nil 则卸掉。没有更多页时 `endRefreshingWithNoMoreData`，不会加 `pageNo`。
    var loadMoreBlock: HFlowLoadMoreBlock? {
        get { objc_getAssociatedObject(self, &HFlowRefreshKeys.loadMoreBlock) as? HFlowLoadMoreBlock }
        set {
            objc_setAssociatedObject(self, &HFlowRefreshKeys.loadMoreBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLoadMoreFooter()
        }
    }

    var isRefreshHeaderInstalled: Bool { mj_header != nil }
    var isLoadMoreFooterInstalled: Bool { mj_footer != nil }

    var refreshHeaderStyle: HFlowRefreshHeaderStyle {
        get {
            guard let value = objc_getAssociatedObject(self, &HFlowRefreshKeys.refreshHeaderStyle) as? NSNumber else { return .gray }
            return HFlowRefreshHeaderStyle(rawValue: value.intValue) ?? .gray
        }
        set {
            objc_setAssociatedObject(self, &HFlowRefreshKeys.refreshHeaderStyle, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateRefreshHeader()
        }
    }

    var refreshFooterStyle: HFlowRefreshFooterStyle {
        get {
            guard let value = objc_getAssociatedObject(self, &HFlowRefreshKeys.refreshFooterStyle) as? NSNumber else { return .style1 }
            return HFlowRefreshFooterStyle(rawValue: value.intValue) ?? .style1
        }
        set {
            objc_setAssociatedObject(self, &HFlowRefreshKeys.refreshFooterStyle, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLoadMoreFooter()
        }
    }

    /// Core `scrollViewDidScroll` 钩子，选择器名勿改。
    @objc func hflow_refresh_didScroll() {
        guard preloadEnabled else { return }
        checkPreload()
    }

    /// Memory 释放钩子，选择器名勿改。
    @objc func hflow_refresh_clearBlocks() {
        refreshBlock = nil
        loadMoreBlock = nil
    }

    /// Config 钩子，选择器名勿改。
    @objc func hflow_config_applyRefresh(_ payload: NSDictionary) {
        if let value = payload["header"] as? Int {
            refreshHeaderStyle = HFlowRefreshHeaderStyle(rawValue: value) ?? .gray
        }
        if let value = payload["footer"] as? Int {
            refreshFooterStyle = HFlowRefreshFooterStyle(rawValue: value) ?? .style1
        }
    }

    private func updateRefreshHeader() {
        if refreshBlock != nil {
            mj_header = HFlowRefresh.refreshHeaderWithStyle(
                refreshHeaderStyle,
                block: { [weak self] in
                    self?.performRefresh()
                }
            )
        } else {
            mj_header = nil
        }
    }

    private func updateLoadMoreFooter() {
        if loadMoreBlock != nil {
            mj_footer = HFlowRefresh.refreshFooterWithStyle(
                refreshFooterStyle,
                block: { [weak self] in
                    _ = self?.performLoadMoreIfNeeded()
                }
            )
        } else {
            mj_footer = nil
        }
    }

    func setCustomRefreshHeader(_ customView: UIView, block: @escaping () -> Void) {
        objc_setAssociatedObject(self, &HFlowRefreshKeys.refreshBlock, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        mj_header = HFlowRefresh.customRefreshHeader(block: { [weak self] in
            self?.performRefresh()
        }, customView: customView)
    }

    func setCustomLoadMoreFooter(_ customView: UIView, block: @escaping () -> Void) {
        objc_setAssociatedObject(self, &HFlowRefreshKeys.loadMoreBlock, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        mj_footer = HFlowRefresh.customRefreshFooter(block: { [weak self] in
            _ = self?.performLoadMoreIfNeeded()
        }, customView: customView)
    }

    func performRefresh() {
        pageNo = 1
        lastPreloadTriggered = false
        mj_footer?.resetNoMoreData()
        refreshBlock?()
    }

    /// 先看 `hasMorePages`，没有更多则 `endRefreshingWithNoMoreData` 并返回 false，避免先加页再发现没数据。
    @discardableResult
    func performLoadMoreIfNeeded() -> Bool {
        guard loadMoreBlock != nil else { return false }
        guard hasMorePages else {
            mj_footer?.endRefreshingWithNoMoreData()
            return false
        }
        pageNo += 1
        loadMoreBlock?()
        return true
    }

    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard refreshBlock != nil else { return }
        pageNo = 1
        lastPreloadTriggered = false
        mj_footer?.resetNoMoreData()
        mj_header?.beginRefreshing(completionBlock: completion)
    }

    func beginRefreshing() {
        beginRefreshing {}
    }

    func endRefreshing(_ completion: @escaping () -> Void) {
        mj_header?.endRefreshing(completionBlock: completion)
    }

    func endRefreshing() {
        endRefreshing {}
    }

    func beginLoadMore(_ completion: @escaping () -> Void) {
        guard loadMoreBlock != nil else { return }
        mj_footer?.beginRefreshing(completionBlock: completion)
    }

    func endLoadMore(_ completion: @escaping () -> Void) {
        if hasMorePages {
            mj_footer?.endRefreshing(completionBlock: completion)
        } else {
            mj_footer?.endRefreshingWithNoMoreData()
            completion()
        }
    }

    func endLoadingMore() {
        endLoadMore {}
    }

    func endRefreshingWithNoMoreData() {
        mj_footer?.endRefreshingWithNoMoreData()
    }

    func resetNoMoreData() {
        mj_footer?.resetNoMoreData()
    }

    func setupRefreshControl(tintColor: UIColor = .gray, title: String? = nil, handler: @escaping () -> Void) {
        _ = tintColor
        _ = title
        refreshHeaderStyle = .gray
        refreshBlock = handler
    }

    func setupLoadMore(handler: @escaping () -> Void) {
        refreshFooterStyle = .style1
        loadMoreBlock = handler
    }

    /// 接近底部时触发 `preloadBlock`，不增加 `pageNo`，与 footer 加载互相独立。
    internal func checkPreload() {
        guard let preloadBlock else { return }
        guard hasMorePages else { return }
        guard mj_footer?.isRefreshing != true else { return }

        let contentHeight = contentSize.height
        guard contentHeight > 0 else { return }

        let scrollHeight = bounds.height
        let offsetY = contentOffset.y
        let bottomInset = adjustedContentInset.bottom
        let preloadDistance = max(
            contentHeight * Constants.defaultPreloadDistanceRatio,
            Constants.minPreloadDistance
        )

        let isPastThreshold = offsetY + scrollHeight - bottomInset >= contentHeight - preloadDistance
        if isPastThreshold, !lastPreloadTriggered {
            lastPreloadTriggered = true
            preloadBlock()
        } else if !isPastThreshold {
            lastPreloadTriggered = false
        }
    }
}
