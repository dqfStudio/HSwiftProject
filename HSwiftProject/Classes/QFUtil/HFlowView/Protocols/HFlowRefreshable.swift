//
//  HFlowRefreshable.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 刷新回调类型
typealias HFlowRefreshBlock = () -> Void

/// 加载更多回调类型
typealias HFlowLoadMoreBlock = () -> Void

/// 刷新协议
///
/// 定义了刷新相关的方法，用于实现依赖注入
protocol HFlowRefreshable {
    /// 设置下拉刷新
    /// - Parameters:
    ///   - headerStyle: 刷新头部样式
    ///   - block: 刷新回调
    func setupRefresh(headerStyle: HFlowRefreshHeaderStyle, block: @escaping HFlowRefreshBlock)
    
    /// 设置上拉加载更多
    /// - Parameters:
    ///   - footerStyle: 刷新尾部样式
    ///   - block: 加载更多回调
    func setupLoadMore(footerStyle: HFlowRefreshFooterStyle, block: @escaping HFlowLoadMoreBlock)
    
    /// 开始下拉刷新
    func beginRefreshing(_ completion: @escaping () -> Void)
    
    /// 结束下拉刷新
    func endRefreshing(_ completion: @escaping () -> Void)
    
    /// 结束上拉加载更多
    func endLoadMore(_ completion: @escaping () -> Void)
    
    /// 结束加载更多（无更多数据）
    func endLoadMoreWithNoMoreData(_ completion: @escaping () -> Void)
    
    /// 重置无更多数据状态
    func resetNoMoreData(_ completion: @escaping () -> Void)
}
