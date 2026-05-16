//
//  HFlowView+Refresh.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import MJRefresh

// 关联对象的键
private var pageNoKey: UInt8 = 0
private var refreshBlockKey: UInt8 = 0
private var refreshHeaderStyleKey: UInt8 = 0
private var loadMoreBlockKey: UInt8 = 0
private var refreshFooterStyleKey: UInt8 = 0
private var totalNoKey: UInt8 = 0
private var pageSizeKey: UInt8 = 0
private var lastPreloadPageKey: UInt8 = 0
private var preloadBlockKey: UInt8 = 0

// 扩展 HFlowView，添加刷新相关的属性
extension HFlowView {
    /// 当前页码
    var pageNo: Int {
        get {
            if let page = objc_getAssociatedObject(self, &pageNoKey) as? Int {
                return page
            }
            return 1
        }
        set {
            objc_setAssociatedObject(self, &pageNoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 总数据量
    var totalNo: Int {
        get {
            if let total = objc_getAssociatedObject(self, &totalNoKey) as? Int {
                return total
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &totalNoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 每页数量
    var pageSize: Int {
        get {
            if let size = objc_getAssociatedObject(self, &pageSizeKey) as? Int {
                return size
            }
            return 20
        }
        set {
            objc_setAssociatedObject(self, &pageSizeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 最后预加载页码
    var lastPreloadPage: Int {
        get {
            if let page = objc_getAssociatedObject(self, &lastPreloadPageKey) as? Int {
                return page
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &lastPreloadPageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 刷新回调
    var refreshBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &refreshBlockKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &refreshBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 加载更多回调
    var loadMoreBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &loadMoreBlockKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &loadMoreBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预加载回调
    var preloadBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &preloadBlockKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &preloadBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 刷新头部样式
    var refreshHeaderStyle: HFlowRefreshHeaderStyle {
        get {
            if let style = objc_getAssociatedObject(self, &refreshHeaderStyleKey) as? HFlowRefreshHeaderStyle {
                return style
            }
            return .gray
        }
        set {
            objc_setAssociatedObject(self, &refreshHeaderStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 刷新底部样式
    var refreshFooterStyle: HFlowRefreshFooterStyle {
        get {
            if let style = objc_getAssociatedObject(self, &refreshFooterStyleKey) as? HFlowRefreshFooterStyle {
                return style
            }
            return .style1
        }
        set {
            objc_setAssociatedObject(self, &refreshFooterStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预加载相关常量
    static let defaultPreloadDistanceRatio: CGFloat = 0.3
    static let minPreloadDistance: CGFloat = 100.0
}

// MARK: - Command Pattern for Refresh Operations

/// 刷新命令协议
///
/// 定义了刷新相关命令的执行方法，用于实现命令模式。
@MainActor
protocol HFlowRefreshCommandProtocol {
    /// 执行命令
    func execute()
}

/// 下拉刷新命令
@MainActor
class HFlowRefreshCommand: HFlowRefreshCommandProtocol {
    private weak var flowView: HFlowView?
    private let completion: () -> Void
    
    init(flowView: HFlowView, completion: @escaping () -> Void) {
        self.flowView = flowView
        self.completion = completion
    }
    
    func execute() {
        guard let flowView = flowView else { return }
        flowView.pageNo = 1
        flowView.mj_header?.beginRefreshing(completionBlock: completion)
    }
}

/// 上拉加载更多命令
@MainActor
class HFlowLoadMoreCommand: HFlowRefreshCommandProtocol {
    private weak var flowView: HFlowView?
    private let completion: () -> Void
    
    init(flowView: HFlowView, completion: @escaping () -> Void) {
        self.flowView = flowView
        self.completion = completion
    }
    
    func execute() {
        guard let flowView = flowView else { return }
        flowView.mj_footer?.beginRefreshing(completionBlock: completion)
    }
}

/// 停止刷新命令
@MainActor
class HFlowStopRefreshCommand: HFlowRefreshCommandProtocol {
    private weak var flowView: HFlowView?
    private let completion: () -> Void
    
    init(flowView: HFlowView, completion: @escaping () -> Void) {
        self.flowView = flowView
        self.completion = completion
    }
    
    func execute() {
        flowView?.mj_header?.endRefreshing(completionBlock: completion)
    }
}

/// 停止加载更多命令
@MainActor
class HFlowStopLoadMoreCommand: HFlowRefreshCommandProtocol {
    private weak var flowView: HFlowView?
    private let completion: () -> Void
    
    init(flowView: HFlowView, completion: @escaping () -> Void) {
        self.flowView = flowView
        self.completion = completion
    }
    
    func execute() {
        flowView?.mj_footer?.endRefreshing(completionBlock: completion)
    }
}

// MARK: - Refresh and Load More
extension HFlowView {
    
    /// 更新下拉刷新头部
    private func updateRefreshHeader() {
        if let refreshBlock = refreshBlock {
            self.mj_header = HFlowRefresh.refreshHeaderWithStyle(
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
            self.mj_footer = HFlowRefresh.refreshFooterWithStyle(
                refreshFooterStyle,
                block: { [weak self] in
                    guard let self = self else { return }
                    self.pageNo += 1
                    if self.pageSize * (self.pageNo - 1) < self.totalNo {
                        loadMoreBlock()
                    } else {
                        self.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
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
        self.mj_header = HFlowRefresh.customRefreshHeader(block: block, customView: customView)
    }
    
    /// 设置自定义上拉加载更多底部
    /// - Parameters:
    ///   - customView: 自定义加载视图
    ///   - block: 加载更多回调
    func setCustomLoadMoreFooter(_ customView: UIView, block: @escaping () -> Void) {
        self.loadMoreBlock = block
        self.mj_footer = HFlowRefresh.customRefreshFooter(block: block, customView: customView)
    }

    /// Block refresh & loadMore
    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard self.refreshBlock != nil else { return }
        let command = HFlowRefreshCommand(flowView: self, completion: completion)
        command.execute()
    }

    /// Stop refresh
    func endRefreshing(_ completion: @escaping () -> Void) {
        let command = HFlowStopRefreshCommand(flowView: self, completion: completion)
        command.execute()
    }

    func endLoadMore(_ completion: @escaping () -> Void) {
        let command = HFlowStopLoadMoreCommand(flowView: self, completion: completion)
        command.execute()
    }
    
    /// 触发上拉加载更多
    func beginLoadMore(_ completion: @escaping () -> Void) {
        guard self.loadMoreBlock != nil else { return }
        let command = HFlowLoadMoreCommand(flowView: self, completion: completion)
        command.execute()
    }
    
    /// 结束加载更多（无更多数据）
    func endLoadMoreWithNoMoreData(_ completion: @escaping () -> Void) {
        mj_footer?.endRefreshingWithNoMoreData()
        completion()
    }
    
    /// 重置无更多数据状态
    func resetNoMoreData(_ completion: @escaping () -> Void) {
        mj_footer?.resetNoMoreData()
        completion()
    }
    
}
