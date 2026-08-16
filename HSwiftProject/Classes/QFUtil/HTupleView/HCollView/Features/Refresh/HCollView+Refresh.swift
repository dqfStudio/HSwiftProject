//
//  HCollView+Refresh.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  下拉刷新、上拉加载、接近底部预加载。依赖 MJRefresh。
//

import UIKit
import MJRefresh

enum HCollRefreshHeaderStyle: Int {
    case gray = 0
    case red = 1
}

enum HCollRefreshFooterStyle: Int {
    case style1 = 0
    case style2 = 1
}

typealias HCollRefreshBlock = () -> Void
typealias HCollLoadMoreBlock = () -> Void

class HCollRefresh {
    static func refreshHeaderWithStyle(_ style: HCollRefreshHeaderStyle, block: @escaping () -> Void, isAutomaticallyChangeAlpha: Bool = true) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.isAutomaticallyChangeAlpha = isAutomaticallyChangeAlpha
        switch style {
        case .gray:
            header.stateLabel?.textColor = .gray
            header.lastUpdatedTimeLabel?.textColor = .lightGray
        case .red:
            header.stateLabel?.textColor = .red
            header.lastUpdatedTimeLabel?.textColor = .red
        }
        return header
    }

    static func refreshFooterWithStyle(_ style: HCollRefreshFooterStyle, block: @escaping () -> Void) -> MJRefreshFooter {
        switch style {
        case .style1:
            return MJRefreshAutoNormalFooter(refreshingBlock: block)
        case .style2:
            return MJRefreshBackNormalFooter(refreshingBlock: block)
        }
    }

    static func customRefreshHeader(block: @escaping () -> Void, customView: UIView) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.addSubview(customView)
        return header
    }

    static func customRefreshFooter(block: @escaping () -> Void, customView: UIView) -> MJRefreshFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
        footer.addSubview(customView)
        return footer
    }
}

private struct HCollRefreshKeys {
    static var refreshBlock: UInt8 = 0
    static var loadMoreBlock: UInt8 = 0
    static var refreshHeaderStyle: UInt8 = 0
    static var refreshFooterStyle: UInt8 = 0
}

extension HCollView {

    /// 赋值后自动挂下拉 header；置 nil 则卸掉。触发时会把 `pageNo` 重置为 1。
    var refreshBlock: HCollRefreshBlock? {
        get { objc_getAssociatedObject(self, &HCollRefreshKeys.refreshBlock) as? HCollRefreshBlock }
        set {
            objc_setAssociatedObject(self, &HCollRefreshKeys.refreshBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateRefreshHeader()
        }
    }

    /// 赋值后自动挂上拉 footer；置 nil 则卸掉。没有更多页时直接 end，不会加 `pageNo`。
    var loadMoreBlock: HCollLoadMoreBlock? {
        get { objc_getAssociatedObject(self, &HCollRefreshKeys.loadMoreBlock) as? HCollLoadMoreBlock }
        set {
            objc_setAssociatedObject(self, &HCollRefreshKeys.loadMoreBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLoadMoreFooter()
        }
    }

    var isRefreshHeaderInstalled: Bool { mj_header != nil }
    var isLoadMoreFooterInstalled: Bool { mj_footer != nil }

    var refreshHeaderStyle: HCollRefreshHeaderStyle {
        get {
            guard let value = objc_getAssociatedObject(self, &HCollRefreshKeys.refreshHeaderStyle) as? NSNumber else { return .gray }
            return HCollRefreshHeaderStyle(rawValue: value.intValue) ?? .gray
        }
        set {
            objc_setAssociatedObject(self, &HCollRefreshKeys.refreshHeaderStyle, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateRefreshHeader()
        }
    }

    var refreshFooterStyle: HCollRefreshFooterStyle {
        get {
            guard let value = objc_getAssociatedObject(self, &HCollRefreshKeys.refreshFooterStyle) as? NSNumber else { return .style1 }
            return HCollRefreshFooterStyle(rawValue: value.intValue) ?? .style1
        }
        set {
            objc_setAssociatedObject(self, &HCollRefreshKeys.refreshFooterStyle, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLoadMoreFooter()
        }
    }

    /// Core `scrollViewDidScroll` 钩子，选择器名勿改。
    @objc func hcoll_refresh_didScroll() {
        guard preloadEnabled else { return }
        checkPreload()
    }

    /// Memory 释放钩子，选择器名勿改。
    @objc func hcoll_refresh_clearBlocks() {
        refreshBlock = nil
        loadMoreBlock = nil
    }

    /// Config 钩子，选择器名勿改。
    @objc func hcoll_config_applyRefresh(_ payload: NSDictionary) {
        if let value = payload["header"] as? Int {
            refreshHeaderStyle = HCollRefreshHeaderStyle(rawValue: value) ?? .gray
        }
        if let value = payload["footer"] as? Int {
            refreshFooterStyle = HCollRefreshFooterStyle(rawValue: value) ?? .style1
        }
    }

    private func updateRefreshHeader() {
        if refreshBlock != nil {
            mj_header = HCollRefresh.refreshHeaderWithStyle(
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
            mj_footer = HCollRefresh.refreshFooterWithStyle(
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
        objc_setAssociatedObject(self, &HCollRefreshKeys.refreshBlock, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        mj_header = HCollRefresh.customRefreshHeader(block: { [weak self] in
            self?.performRefresh()
        }, customView: customView)
    }

    func setCustomLoadMoreFooter(_ customView: UIView, block: @escaping () -> Void) {
        objc_setAssociatedObject(self, &HCollRefreshKeys.loadMoreBlock, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        mj_footer = HCollRefresh.customRefreshFooter(block: { [weak self] in
            _ = self?.performLoadMoreIfNeeded()
        }, customView: customView)
    }

    func performRefresh() {
        pageNo = 1
        refreshBlock?()
    }

    /// 先看 `hasMorePages`，没有更多则 end 并返回 false，避免先加页再发现没数据。
    @discardableResult
    func performLoadMoreIfNeeded() -> Bool {
        guard loadMoreBlock != nil else { return false }
        guard hasMorePages else {
            mj_footer?.endRefreshing()
            return false
        }
        pageNo += 1
        loadMoreBlock?()
        return true
    }

    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard refreshBlock != nil else { return }
        pageNo = 1
        mj_header?.beginRefreshing(completionBlock: completion)
    }

    func endRefreshing(_ completion: @escaping () -> Void) {
        mj_header?.endRefreshing(completionBlock: completion)
    }

    func beginLoadMore(_ completion: @escaping () -> Void) {
        guard loadMoreBlock != nil else { return }
        mj_footer?.beginRefreshing(completionBlock: completion)
    }

    func endLoadMore(_ completion: @escaping () -> Void) {
        mj_footer?.endRefreshing(completionBlock: completion)
    }

    /// 接近底部时触发 `preloadBlock`，不增加 `pageNo`，与 footer 加载互相独立。
    internal func checkPreload() {
        guard let preloadBlock = preloadBlock else { return }
        guard mj_footer?.isRefreshing != true else { return }

        let contentHeight = contentSize.height
        guard contentHeight > 0 else { return }

        let scrollHeight = bounds.height
        let offsetY = contentOffset.y
        let preloadDistance = max(
            contentHeight * HCollView.Constants.defaultPreloadDistanceRatio,
            HCollView.Constants.minPreloadDistance
        )

        let isPastThreshold = offsetY + scrollHeight >= contentHeight - preloadDistance
        if isPastThreshold, !lastPreloadTriggered {
            lastPreloadTriggered = true
            preloadBlock()
        } else if !isPastThreshold {
            lastPreloadTriggered = false
        }
    }
}
