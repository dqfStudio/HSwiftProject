//
//  HFlowRefreshManager.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import MJRefresh

/// HFlowView 刷新管理器
///
/// 负责管理 HFlowView 的刷新和加载更多功能，遵循HFlowRefreshable协议
class HFlowRefreshManager: HFlowRefreshable {
    
    // MARK: - Properties
    
    /// 下拉刷新回调
    var refreshBlock: HFlowRefreshBlock?
    
    /// 上拉加载更多回调
    var loadMoreBlock: HFlowLoadMoreBlock?
    
    /// 刷新头部样式
    var refreshHeaderStyle: HFlowRefreshHeaderStyle = .gray
    
    /// 刷新尾部样式
    var refreshFooterStyle: HFlowRefreshFooterStyle = .style1
    
    /// 页码
    var pageNo: Int = 1
    
    /// 每页数量
    var pageSize: Int = 20
    
    /// 总数据量
    var totalNo: Int = 0
    
    /// 所属的 HFlowView
    private weak var flowView: HFlowView?
    
    // MARK: - Initialization
    
    /// 初始化刷新管理器
    /// - Parameter flowView: 所属的 HFlowView
    init(flowView: HFlowView) {
        self.flowView = flowView
    }
    
    // MARK: - Public Methods
    
    /// 设置下拉刷新
    /// - Parameters:
    ///   - headerStyle: 刷新头部样式
    ///   - block: 刷新回调
    func setupRefresh(headerStyle: HFlowRefreshHeaderStyle, block: @escaping HFlowRefreshBlock) {
        self.refreshHeaderStyle = headerStyle
        self.refreshBlock = block
        updateRefreshHeader()
    }
    
    /// 设置上拉加载更多
    /// - Parameters:
    ///   - footerStyle: 刷新尾部样式
    ///   - block: 加载更多回调
    func setupLoadMore(footerStyle: HFlowRefreshFooterStyle, block: @escaping HFlowLoadMoreBlock) {
        self.refreshFooterStyle = footerStyle
        self.loadMoreBlock = block
        updateLoadMoreFooter()
    }
    
    /// 更新下拉刷新头部
    func updateRefreshHeader() {
        guard let flowView = flowView else { return }
        
        if let refreshBlock = refreshBlock {
            flowView.mj_header = HFlowRefresh.refreshHeaderWithStyle(
                refreshHeaderStyle,
                block: {
                    self.pageNo = 1
                    refreshBlock()
                },
                isAutomaticallyChangeAlpha: true
            )
        } else {
            flowView.mj_header = nil
        }
    }
    
    /// 更新上拉加载更多底部
    func updateLoadMoreFooter() {
        guard let flowView = flowView else { return }
        
        if let loadMoreBlock = loadMoreBlock {
            flowView.mj_footer = HFlowRefresh.refreshFooterWithStyle(
                refreshFooterStyle,
                block: {
                    self.pageNo += 1
                    if self.pageSize * (self.pageNo - 1) < self.totalNo {
                        loadMoreBlock()
                    } else {
                        flowView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                },
            )
        } else {
            flowView.mj_footer = nil
        }
    }
    
    /// 开始下拉刷新
    func beginRefreshing(_ completion: @escaping () -> Void) {
        guard let flowView = flowView, refreshBlock != nil else { return }
        pageNo = 1
        flowView.mj_header?.beginRefreshing(completionBlock: completion)
    }
    
    /// 结束下拉刷新
    func endRefreshing(_ completion: @escaping () -> Void) {
        flowView?.mj_header?.endRefreshing(completionBlock: completion)
    }
    
    /// 结束上拉加载更多
    func endLoadMore(_ completion: @escaping () -> Void) {
        flowView?.mj_footer?.endRefreshing(completionBlock: completion)
    }
    
    /// 结束加载更多（无更多数据）
    func endLoadMoreWithNoMoreData(_ completion: @escaping () -> Void) {
        flowView?.mj_footer?.endRefreshingWithNoMoreData()
        completion()
    }
    
    /// 重置无更多数据状态
    func resetNoMoreData(_ completion: @escaping () -> Void) {
        flowView?.mj_footer?.resetNoMoreData()
        completion()
    }
}
