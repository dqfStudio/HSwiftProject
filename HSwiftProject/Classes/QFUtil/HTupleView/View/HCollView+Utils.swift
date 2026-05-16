//
//  HCollView+Utils.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import MJRefresh

/// 重新加载管理类
///
/// 用于跟踪和管理 HCollView 的刷新状态
class HCollReload {
    /// 是否正在刷新
    var isRefresh = false
    /// 是否需要刷新
    var needRefresh = false
    
    /// 重置状态
    func reset() {
        isRefresh = false
        needRefresh = false
    }
    
    /// 标记为需要刷新
    func markAsNeedRefresh() {
        needRefresh = true
    }
    
    /// 标记为正在刷新
    func markAsRefreshing() {
        isRefresh = true
        needRefresh = false
    }
    
    /// 标记为刷新完成
    func markAsRefreshCompleted() {
        isRefresh = false
        needRefresh = false
    }
}

/// 刷新工具类
///
/// 用于创建和配置 MJRefresh 刷新控件
class HCollRefresh {
    /// 根据指定的样式创建下拉刷新头部
    /// - Parameters:
    ///   - style: 刷新头部样式
    ///   - block: 刷新回调
    ///   - isAutomaticallyChangeAlpha: 是否自动改变透明度
    /// - Returns: 配置好的 MJRefreshHeader 实例
    static func refreshHeaderWithStyle(_ style: HCollRefreshHeaderStyle, block: @escaping () -> Void, isAutomaticallyChangeAlpha: Bool = true) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.isAutomaticallyChangeAlpha = isAutomaticallyChangeAlpha
        
        // 根据样式设置不同的颜色
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
    
    /// 根据指定的样式创建上拉加载更多底部
    /// - Parameters:
    ///   - style: 加载更多底部样式
    ///   - block: 加载更多回调
    ///   - isAutomaticallyHidden: 是否自动隐藏
    /// - Returns: 配置好的 MJRefreshFooter 实例
    static func refreshFooterWithStyle(_ style: HCollRefreshFooterStyle, block: @escaping () -> Void, isAutomaticallyHidden: Bool = false) -> MJRefreshFooter {
        let footer: MJRefreshFooter
        
        switch style {
        case .style1:
            footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
        case .style2:
            footer = MJRefreshBackNormalFooter(refreshingBlock: block)
        }
        
        footer.isAutomaticallyHidden = isAutomaticallyHidden
        return footer
    }
    
    /// 创建自定义下拉刷新头部
    /// - Parameters:
    ///   - block: 刷新回调
    ///   - customView: 自定义刷新视图
    /// - Returns: 配置好的 MJRefreshHeader 实例
    static func customRefreshHeader(block: @escaping () -> Void, customView: UIView) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header.addSubview(customView)
        return header
    }
    
    /// 创建自定义上拉加载更多底部
    /// - Parameters:
    ///   - block: 加载更多回调
    ///   - customView: 自定义加载视图
    /// - Returns: 配置好的 MJRefreshFooter 实例
    static func customRefreshFooter(block: @escaping () -> Void, customView: UIView) -> MJRefreshFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: block)
        footer.addSubview(customView)
        return footer
    }
    
    @objc private static func refreshAction() {
        // 空实现，仅用于自定义头部的刷新回调
    }
}
