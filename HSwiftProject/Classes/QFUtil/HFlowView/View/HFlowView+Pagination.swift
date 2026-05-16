//
//  HFlowView+Pagination.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HFlowView 分页管理扩展
///
/// 内置分页逻辑，简化分页数据的处理
///
/// 本扩展提供了完整的分页管理功能，包括：
/// - 分页状态管理
/// - 页码和数据量跟踪
/// - 自动处理刷新和加载更多
/// - 预加载判断
extension HFlowView {
    
    /// 分页状态
    enum PaginationState {
        case idle          // 空闲状态
        case loading       // 加载中
        case refreshing    // 刷新中
        case noMoreData    // 没有更多数据
        case error         // 错误状态
    }
    
    /// 分页管理类
    ///
    /// 负责管理分页相关的状态和逻辑，包括页码、数据量、加载状态等。
    class PaginationManager {
        
        // MARK: - 属性
        
        /// 当前页码
        var currentPage: Int = 1
        
        /// 每页数量
        var pageSize: Int = 20
        
        /// 总页数
        var totalPages: Int = 0
        
        /// 总数据量
        var totalItems: Int = 0
        
        /// 分页状态
        var state: PaginationState = .idle
        
        /// 是否有更多数据
        var hasMoreData: Bool {
            return currentPage < totalPages
        }
        
        // MARK: - 方法
        
        /// 重置分页状态
        ///
        /// 将所有分页相关的状态重置为初始值，包括页码、数据量和状态。
        func reset() {
            currentPage = 1
            totalPages = 0
            totalItems = 0
            state = .idle
        }
        
        /// 开始刷新
        ///
        /// 将状态设置为刷新中，并重置页码为 1。
        func startRefreshing() {
            state = .refreshing
            currentPage = 1
        }
        
        /// 开始加载更多
        ///
        /// 如果有更多数据且当前不在加载中，则将状态设置为加载中，并增加页码。
        /// 否则，将状态设置为没有更多数据。
        func startLoadingMore() {
            if hasMoreData && state != .loading {
                state = .loading
                currentPage += 1
            } else {
                state = .noMoreData
            }
        }
        
        /// 结束加载
        /// - Parameters:
        ///   - totalItems: 总数据量
        ///   - pageSize: 每页数量
        ///
        /// 根据总数据量和每页数量计算总页数，并更新分页状态。
        func endLoading(totalItems: Int, pageSize: Int) {
            self.totalItems = totalItems
            self.pageSize = pageSize
            self.totalPages = Int(ceil(Double(totalItems) / Double(pageSize)))
            
            if hasMoreData {
                state = .idle
            } else {
                state = .noMoreData
            }
        }
        
        /// 结束加载（带错误）
        ///
        /// 将状态设置为错误状态，如果是加载更多失败，则回滚页码。
        func endLoadingWithError() {
            let wasLoadingMore = (state == .loading)
            state = .error
            if wasLoadingMore {
                currentPage = max(1, currentPage - 1)
            }
        }
    }
    
    /// 分页管理器
    ///
    /// 通过关联对象存储和获取 PaginationManager 实例，确保每个 HFlowView 实例都有自己的分页管理器。
    var paginationManager: PaginationManager {
        get {
            if let manager = objc_getAssociatedObject(self, &paginationManagerKey) as? PaginationManager {
                return manager
            } else {
                let manager = PaginationManager()
                objc_setAssociatedObject(self, &paginationManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &paginationManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 初始化分页
    /// - Parameters:
    ///   - pageSize: 每页数量，默认为 20
    ///   - initialPage: 初始页码，默认为 1
    ///   - refresh: 刷新回调，可选
    ///   - loadMore: 加载更多回调，可选
    ///
    /// 配置分页参数，并设置刷新和加载更多的回调。
    func setupPagination(pageSize: Int = 20, initialPage: Int = 1, refresh: (() -> Void)? = nil, loadMore: (() -> Void)? = nil) {
        paginationManager.pageSize = pageSize
        paginationManager.currentPage = initialPage
        
        // 配置刷新和加载更多
        if let refresh = refresh {
            self.refreshManager.setupRefresh(headerStyle: HFlowRefreshHeaderStyle.gray, block: {
                self.paginationManager.startRefreshing()
                refresh()
            })
        }
        
        if let loadMore = loadMore {
            self.refreshManager.setupLoadMore(footerStyle: HFlowRefreshFooterStyle.style1, block: {
                self.paginationManager.startLoadingMore()
                loadMore()
            })
        }
    }
    
    /// 结束刷新
    /// - Parameters:
    ///   - totalItems: 总数据量
    ///   - pageSize: 每页数量
    ///
    /// 结束刷新操作，更新分页状态，并根据是否有更多数据更新加载更多的状态。
    func endRefresh(totalItems: Int, pageSize: Int) {
        paginationManager.endLoading(totalItems: totalItems, pageSize: pageSize)
        endRefreshing {}
        
        // 更新加载更多状态
        if !paginationManager.hasMoreData {
            endLoadMoreWithNoMoreData {}
        } else {
            resetNoMoreData {}
        }
    }
    
    /// 结束加载更多
    /// - Parameters:
    ///   - totalItems: 总数据量
    ///   - pageSize: 每页数量
    ///
    /// 结束加载更多操作，更新分页状态，并根据是否有更多数据更新加载更多的状态。
    func endLoadMore(totalItems: Int, pageSize: Int) {
        paginationManager.endLoading(totalItems: totalItems, pageSize: pageSize)
        endLoadMore {}
        
        // 更新加载更多状态
        if !paginationManager.hasMoreData {
            endLoadMoreWithNoMoreData {}
        }
    }
    
    /// 结束加载（带错误）
    ///
    /// 结束加载操作，将分页状态设置为错误状态，并结束刷新和加载更多的动画。
    func endLoadingWithError() {
        paginationManager.endLoadingWithError()
        endRefreshing {}
        endLoadMore {}
    }
    
    /// 重置分页
    ///
    /// 重置分页状态，并重置加载更多的状态。
    func resetPagination() {
        paginationManager.reset()
        resetNoMoreData {}
    }
    
    /// 检查是否需要预加载
    /// - Returns: 是否需要预加载
    ///
    /// 根据当前的分页状态、是否有更多数据以及滚动位置，判断是否需要预加载数据。
    func shouldPreload() -> Bool {
        if paginationManager.state != .idle {
            return false
        }
        
        if !paginationManager.hasMoreData {
            return false
        }
        
        // 计算滚动位置
        let contentHeight = contentSize.height
        let scrollViewHeight = bounds.height
        let offsetY = contentOffset.y
        
        // 当滚动到距离底部一定距离时，触发预加载
        let preloadThreshold = scrollViewHeight * self.preloadManager.preloadDistanceRatio + self.preloadManager.minPreloadDistance
        return contentHeight - offsetY - scrollViewHeight < preloadThreshold
    }
}

// 关联对象键
private var paginationManagerKey: UInt8 = 0
