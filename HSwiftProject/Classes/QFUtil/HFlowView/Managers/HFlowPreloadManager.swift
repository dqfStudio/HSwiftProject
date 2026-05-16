//
//  HFlowPreloadManager.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 预加载回调类型
typealias HFlowPreloadBlock = () -> Void

/// HFlowView 预加载管理器
///
/// 负责管理 HFlowView 的预加载功能
@MainActor
class HFlowPreloadManager {
    
    // MARK: - Constants
    
    private enum Constants {
        /// 预加载阈值
        static let preloadingThreshold = 3
        
        /// 加载更多触发阈值
        static let loadMoreThreshold: CGFloat = 100.0
    }
    
    // MARK: - Properties
    
    /// 是否启用预加载
    var enablePreloading = true
    
    /// 预加载阈值（滚动时提前加载的行数）
    var preloadingThreshold = Constants.preloadingThreshold
    
    /// 预加载回调
    var preloadBlock: HFlowPreloadBlock?
    
    /// 预加载距离比例
    var preloadDistanceRatio: CGFloat = 0.3
    
    /// 最小预加载距离
    var minPreloadDistance: CGFloat = 100.0
    
    /// 最后预加载的页码
    var lastPreloadPage: Int = 0
    
    /// 所属的 HFlowView
    private weak var flowView: HFlowView?
    
    // MARK: - Initialization
    
    /// 初始化预加载管理器
    /// - Parameter flowView: 所属的 HFlowView
    init(flowView: HFlowView) {
        self.flowView = flowView
    }
    
    // MARK: - Public Methods
    
    /// 检查是否需要预加载
    func checkPreload() {
        guard enablePreloading, let preloadBlock = preloadBlock else { return }
        guard let flowView = flowView else { return }

        // 确保不在加载更多中，避免重复触发
        guard flowView.mj_footer?.isRefreshing != true else { return }

        // 计算内容高度和滚动位置
        let contentHeight = flowView.contentSize.height
        let scrollHeight = flowView.bounds.height
        let offsetY = flowView.contentOffset.y

        // 计算预加载距离
        let preloadDistance = max(contentHeight * preloadDistanceRatio, minPreloadDistance)

        // 当滚动到距离底部预加载距离时触发预加载
        if offsetY + scrollHeight >= contentHeight - preloadDistance {
            // 使用页码去重，避免重复触发
            let totalNo = flowView.refreshManager.totalNo
            let pageSize = flowView.refreshManager.pageSize
            guard totalNo > 0 else { return }
            let currentPage = (totalNo - 1) / pageSize + 1
            if lastPreloadPage < currentPage {
                lastPreloadPage = currentPage
                preloadBlock()
            }
        }
    }
    
    /// 检查是否需要预加载（基于可见单元格）
    func checkPreloading() {
        guard enablePreloading, let preloadBlock = preloadBlock else { return }
        guard let flowView = flowView else { return }
        guard let visibleIndexPaths = flowView.indexPathsForVisibleRows else { return }
        guard !visibleIndexPaths.isEmpty else { return }
        
        // 找到最后一个可见的 indexPath
        var lastVisibleIndexPath = visibleIndexPaths[0]
        for indexPath in visibleIndexPaths {
            if indexPath.section > lastVisibleIndexPath.section || 
               (indexPath.section == lastVisibleIndexPath.section && indexPath.row > lastVisibleIndexPath.row) {
                lastVisibleIndexPath = indexPath
            }
        }
        
        // 检查是否需要预加载
        let sections = flowView.numberOfSections
        let rowsInLastSection = flowView.numberOfRows(inSection: lastVisibleIndexPath.section)
        
        // 如果当前是最后一个 section，且接近底部，则触发预加载
        if lastVisibleIndexPath.section == sections - 1 && 
           lastVisibleIndexPath.row >= rowsInLastSection - preloadingThreshold {
            // 触发预加载回调
            preloadBlock()
        }
    }
    
    /// 重置预加载状态
    func resetPreloadState() {
        lastPreloadPage = 0
    }
}
