//
//  HCollView+Refresh.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import MJRefresh

// MARK: - Command Pattern for Refresh Operations

/// 刷新命令协议
protocol HCollRefreshCommandProtocol {
    /// 执行命令
    func execute()
}

/// 下拉刷新命令
@MainActor
class HCollRefreshCommand: HCollRefreshCommandProtocol {
    private weak var collView: HCollView?
    private let completion: () -> Void
    
    init(collView: HCollView, completion: @escaping () -> Void) {
        self.collView = collView
        self.completion = completion
    }
    
    func execute() {
        guard let collView = collView else { return }
        collView.pageNo = 1
        collView.mj_header?.beginRefreshing(completionBlock: completion)
    }
}

/// 上拉加载更多命令
@MainActor
class HCollLoadMoreCommand: HCollRefreshCommandProtocol {
    private weak var collView: HCollView?
    private let completion: () -> Void
    
    init(collView: HCollView, completion: @escaping () -> Void) {
        self.collView = collView
        self.completion = completion
    }
    
    func execute() {
        guard let collView = collView else { return }
        collView.mj_footer?.beginRefreshing(completionBlock: completion)
    }
}

/// 停止刷新命令
@MainActor
class HCollStopRefreshCommand: HCollRefreshCommandProtocol {
    private weak var collView: HCollView?
    private let completion: () -> Void
    
    init(collView: HCollView, completion: @escaping () -> Void) {
        self.collView = collView
        self.completion = completion
    }
    
    func execute() {
        collView?.mj_header?.endRefreshing(completionBlock: completion)
    }
}

/// 停止加载更多命令
@MainActor
class HCollStopLoadMoreCommand: HCollRefreshCommandProtocol {
    private weak var collView: HCollView?
    private let completion: () -> Void
    
    init(collView: HCollView, completion: @escaping () -> Void) {
        self.collView = collView
        self.completion = completion
    }
    
    func execute() {
        collView?.mj_footer?.endRefreshing(completionBlock: completion)
    }
}

// MARK: - Refresh and Load More
extension HCollView {
    
    /// 更新下拉刷新头部
    private func updateRefreshHeader() {
        if let refreshBlock = refreshBlock {
            self.mj_header = HCollRefresh.refreshHeaderWithStyle(
                refreshHeaderStyle,
                block: { [weak self] in
                    guard let self = self else { return }
                    self.pageNo = 1
                    refreshBlock()
                },
                isAutomaticallyChangeAlpha: true
            )
        } else {
            self.mj_header = nil
        }
    }
    
    /// 更新上拉加载更多底部
    private func updateLoadMoreFooter() {
        if let loadMoreBlock = loadMoreBlock {
            self.mj_footer = HCollRefresh.refreshFooterWithStyle(
                refreshFooterStyle,
                block: { [weak self] in
                    guard let self = self else { return }
                    self.pageNo += 1
                    if self.pageSize * self.pageNo < self.totalNo {
                        loadMoreBlock()
                    } else {
                        self.mj_footer?.endRefreshing()
                    }
                },
                isAutomaticallyHidden: false
            )
        } else {
            self.mj_footer = nil
        }
    }
    
    /// 设置自定义下拉刷新头部
    /// - Parameters:
    ///   - customView: 自定义刷新视图
    ///   - block: 刷新回调
    func setCustomRefreshHeader(_ customView: UIView, block: @escaping () -> Void) {
        self.refreshBlock = block
        self.mj_header = HCollRefresh.customRefreshHeader(block: block, customView: customView)
    }
    
    /// 设置自定义上拉加载更多底部
    /// - Parameters:
    ///   - customView: 自定义加载视图
    ///   - block: 加载更多回调
    func setCustomLoadMoreFooter(_ customView: UIView, block: @escaping () -> Void) {
        self.loadMoreBlock = block
        self.mj_footer = HCollRefresh.customRefreshFooter(block: block, customView: customView)
    }

    /// Block refresh & loadMore
    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard self.refreshBlock != nil else { return }
        let command = HCollRefreshCommand(collView: self, completion: completion)
        command.execute()
    }

    /// Stop refresh
    func endRefreshing(_ completion: @escaping () -> Void) {
        let command = HCollStopRefreshCommand(collView: self, completion: completion)
        command.execute()
    }

    func endLoadMore(_ completion: @escaping () -> Void) {
        let command = HCollStopLoadMoreCommand(collView: self, completion: completion)
        command.execute()
    }
    
    /// 触发上拉加载更多
    func beginLoadMore(_ completion: @escaping () -> Void) {
        guard self.loadMoreBlock != nil else { return }
        let command = HCollLoadMoreCommand(collView: self, completion: completion)
        command.execute()
    }
    
    /// 检查是否需要预加载
    internal func checkPreload() {
        guard let preloadBlock = preloadBlock else { return }
        guard mj_footer?.isRefreshing != true else { return }

        let contentHeight = contentSize.height
        guard contentHeight > 0 else { return }

        let scrollHeight = bounds.height
        let offsetY = contentOffset.y
        let preloadDistance = max(contentHeight * HCollView.Constants.defaultPreloadDistanceRatio, HCollView.Constants.minPreloadDistance)

        // Only trigger when scrolled past the preload threshold
        let isPastThreshold = offsetY + scrollHeight >= contentHeight - preloadDistance
        let wasPastThreshold = lastPreloadTriggered

        // Use a hysteresis guard: only fire on the rising edge of passing the threshold
        if isPastThreshold, !wasPastThreshold {
            lastPreloadTriggered = true
            preloadBlock()
        } else if !isPastThreshold {
            lastPreloadTriggered = false
        }
    }
}
