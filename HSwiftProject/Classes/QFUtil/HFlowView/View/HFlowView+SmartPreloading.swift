//
//  HFlowView+SmartPreloading.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 智能预加载策略枚举
enum HFlowSmartPreloadStrategy {
    case fixedDistance    // 固定距离预加载
    case dynamicDistance  // 动态距离预加载
    case predictive       // 预测性预加载
    case adaptive         // 自适应预加载
}

/// 智能预加载配置结构体
struct HFlowSmartPreloadConfig {
    /// 预加载策略
    var strategy: HFlowSmartPreloadStrategy
    /// 预加载距离（像素）
    var preloadDistance: CGFloat
    /// 预加载阈值（行数）
    var preloadThreshold: Int
    /// 是否启用智能预测
    var enablePredictive: Bool
    /// 预测窗口大小
    var predictiveWindow: Int
    
    /// 默认配置
    static let `default` = HFlowSmartPreloadConfig(
        strategy: .adaptive,
        preloadDistance: 300.0,
        preloadThreshold: 3,
        enablePredictive: true,
        predictiveWindow: 5
    )
}

/// 滚动状态结构体
struct HFlowScrollState {
    /// 滚动速度
    var velocity: CGFloat
    /// 滚动方向
    var direction: HFlowScrollDirection
    /// 滚动位置
    var position: CGFloat
    /// 滚动时间
    var timestamp: TimeInterval
}

/// 滚动方向枚举
enum HFlowScrollDirection {
    case up
    case down
    case none
}

/// HFlowView 智能预加载扩展
///
/// 为 HFlowView 提供智能预加载功能，根据用户滚动行为和设备状态智能预测预加载时机
///
/// 实现功能：
/// 1. 支持多种预加载策略
/// 2. 智能预测用户滚动行为
/// 3. 根据滚动速度和方向调整预加载时机
/// 4. 适应不同网络环境和设备性能

// 关联对象的键
private var enableSmartPreloadingKey: UInt8 = 0
private var smartPreloadConfigKey: UInt8 = 0
private var scrollStateKey: UInt8 = 0
private var isPreloadingKey: UInt8 = 0
private var predictedIndexPathsKey: UInt8 = 0
private var velocityHistoryKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Smart Preloading Properties
    
    /// 是否启用智能预加载
    public var enableSmartPreloading: Bool {
        get {
            if let enable = objc_getAssociatedObject(self, &enableSmartPreloadingKey) as? Bool {
                return enable
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &enableSmartPreloadingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 智能预加载配置
    public var smartPreloadConfig: HFlowSmartPreloadConfig {
        get {
            if let config = objc_getAssociatedObject(self, &smartPreloadConfigKey) as? HFlowSmartPreloadConfig {
                return config
            }
            return HFlowSmartPreloadConfig.default
        }
        set {
            objc_setAssociatedObject(self, &smartPreloadConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 滚动状态
    private var scrollState: HFlowScrollState {
        get {
            if let state = objc_getAssociatedObject(self, &scrollStateKey) as? HFlowScrollState {
                return state
            }
            return HFlowScrollState(velocity: 0, direction: .none, position: 0, timestamp: 0)
        }
        set {
            objc_setAssociatedObject(self, &scrollStateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预加载状态
    private var isPreloading: Bool {
        get {
            if let preloading = objc_getAssociatedObject(self, &isPreloadingKey) as? Bool {
                return preloading
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &isPreloadingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预测的预加载索引路径
    private var predictedIndexPaths: [IndexPath] {
        get {
            if let paths = objc_getAssociatedObject(self, &predictedIndexPathsKey) as? [IndexPath] {
                return paths
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &predictedIndexPathsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 滚动速度历史
    private var velocityHistory: [CGFloat] {
        get {
            if let history = objc_getAssociatedObject(self, &velocityHistoryKey) as? [CGFloat] {
                return history
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &velocityHistoryKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 最大速度历史记录数
    private static let maxVelocityHistoryCount = 10
    
    // MARK: - Smart Preloading Methods
    
    /// 初始化智能预加载
    func setupSmartPreloading() {
        // 监听滚动事件
        // 这里可以通过代理方法或通知来监听滚动事件
    }
    
    /// 处理滚动事件，更新滚动状态
    /// - Parameter scrollView: 滚动视图
    func handleScrollForSmartPreloading(_ scrollView: UIScrollView) {
        guard enableSmartPreloading else { return }
        
        // 计算滚动方向
        let newPosition = scrollView.contentOffset.y
        let direction: HFlowScrollDirection
        if newPosition > scrollState.position {
            direction = .down
        } else if newPosition < scrollState.position {
            direction = .up
        } else {
            direction = .none
        }
        
        // 计算滚动速度
        let currentTime = Date().timeIntervalSince1970
        let timeDelta = max(0.01, currentTime - scrollState.timestamp)
        let velocity = abs(newPosition - scrollState.position) / CGFloat(timeDelta)
        
        // 更新滚动状态
        scrollState = HFlowScrollState(
            velocity: velocity,
            direction: direction,
            position: newPosition,
            timestamp: currentTime
        )
        
        // 更新速度历史
        updateVelocityHistory(velocity)
        
        // 检查是否需要预加载
        checkSmartPreloading()
    }
    
    /// 更新速度历史
    /// - Parameter velocity: 当前滚动速度
    private func updateVelocityHistory(_ velocity: CGFloat) {
        velocityHistory.append(velocity)
        if velocityHistory.count > HFlowView.maxVelocityHistoryCount {
            velocityHistory.removeFirst()
        }
    }
    
    /// 获取平均滚动速度
    /// - Returns: 平均滚动速度
    private func getAverageVelocity() -> CGFloat {
        return velocityHistory.reduce(0, +) / CGFloat(velocityHistory.count)
    }
    
    /// 检查是否需要智能预加载
    private func checkSmartPreloading() {
        guard !isPreloading, scrollState.direction == .down else { return }
        
        // 根据预加载策略检查是否需要预加载
        switch smartPreloadConfig.strategy {
        case .fixedDistance:
            checkFixedDistancePreloading()
        case .dynamicDistance:
            checkDynamicDistancePreloading()
        case .predictive:
            checkPredictivePreloading()
        case .adaptive:
            checkAdaptivePreloading()
        }
    }
    
    /// 检查固定距离预加载
    private func checkFixedDistancePreloading() {
        let contentHeight = contentSize.height
        let scrollHeight = bounds.height
        let offsetY = contentOffset.y
        
        if offsetY + scrollHeight >= contentHeight - smartPreloadConfig.preloadDistance {
            triggerSmartPreloading()
        }
    }
    
    /// 检查动态距离预加载
    private func checkDynamicDistancePreloading() {
        let contentHeight = contentSize.height
        let scrollHeight = bounds.height
        let offsetY = contentOffset.y
        
        // 根据滚动速度调整预加载距离
        let averageVelocity = getAverageVelocity()
        let dynamicDistance = min(smartPreloadConfig.preloadDistance + averageVelocity * 10,
                                  contentHeight * 0.5)
        
        if offsetY + scrollHeight >= contentHeight - dynamicDistance {
            triggerSmartPreloading()
        }
    }
    
    /// 检查预测性预加载
    private func checkPredictivePreloading() {
        guard smartPreloadConfig.enablePredictive else { 
            checkFixedDistancePreloading()
            return 
        }
        
        // 预测用户可能滚动到的位置
        predictPreloadIndexPaths()
        
        // 检查是否需要预加载
        let visibleIndexPaths = indexPathsForVisibleRows ?? []
        guard !visibleIndexPaths.isEmpty else { return }
        
        // 找到最后一个可见的 indexPath
        var lastVisibleIndexPath = visibleIndexPaths[0]
        for indexPath in visibleIndexPaths {
            if indexPath.section > lastVisibleIndexPath.section || 
               (indexPath.section == lastVisibleIndexPath.section && indexPath.row > lastVisibleIndexPath.row) {
                lastVisibleIndexPath = indexPath
            }
        }
        
        // 检查是否接近预测的预加载位置
        for predictedIndexPath in predictedIndexPaths {
            if predictedIndexPath.section == lastVisibleIndexPath.section && 
               predictedIndexPath.row - lastVisibleIndexPath.row <= smartPreloadConfig.preloadThreshold {
                triggerSmartPreloading()
                break
            }
        }
    }
    
    /// 检查自适应预加载
    private func checkAdaptivePreloading() {
        // 结合多种策略
        let contentHeight = contentSize.height
        let scrollHeight = bounds.height
        let offsetY = contentOffset.y
        let averageVelocity = getAverageVelocity()
        
        // 根据滚动速度和设备性能调整预加载距离
        let dynamicDistance = min(smartPreloadConfig.preloadDistance + averageVelocity * 10,
                                  contentHeight * 0.5)
        
        // 同时检查固定距离和动态距离
        if offsetY + scrollHeight >= contentHeight - min(dynamicDistance, smartPreloadConfig.preloadDistance * 2) {
            triggerSmartPreloading()
        }
    }
    
    /// 预测预加载索引路径
    private func predictPreloadIndexPaths() {
        predictedIndexPaths.removeAll()
        
        let visibleIndexPaths = indexPathsForVisibleRows ?? []
        guard !visibleIndexPaths.isEmpty else { return }
        
        // 找到最后一个可见的 indexPath
        var lastVisibleIndexPath = visibleIndexPaths[0]
        for indexPath in visibleIndexPaths {
            if indexPath.section > lastVisibleIndexPath.section || 
               (indexPath.section == lastVisibleIndexPath.section && indexPath.row > lastVisibleIndexPath.row) {
                lastVisibleIndexPath = indexPath
            }
        }
        
        // 预测接下来可能滚动到的 indexPath
        let sections = numberOfSections
        let rowsInLastSection = numberOfRows(inSection: lastVisibleIndexPath.section)
        
        for i in 1...smartPreloadConfig.predictiveWindow {
            let nextRow = lastVisibleIndexPath.row + i
            if nextRow < rowsInLastSection {
                predictedIndexPaths.append(IndexPath(row: nextRow, section: lastVisibleIndexPath.section))
            } else if lastVisibleIndexPath.section < sections - 1 {
                let nextSection = lastVisibleIndexPath.section + 1
                let rowsInNextSection = numberOfRows(inSection: nextSection)
                if rowsInNextSection > 0 {
                    predictedIndexPaths.append(IndexPath(row: 0, section: nextSection))
                }
            } else {
                break
            }
        }
    }
    
    /// 触发智能预加载
    private func triggerSmartPreloading() {
        guard !isPreloading, let preloadBlock = preloadManager.preloadBlock else { return }
        
        isPreloading = true
        
        // 触发预加载回调
        preloadBlock()
        
        // 延迟重置预加载状态，避免频繁触发
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isPreloading = false
        }
    }
    
    /// 重置智能预加载状态
    func resetSmartPreloadingState() {
        isPreloading = false
        scrollState = HFlowScrollState(velocity: 0, direction: .none, position: 0, timestamp: 0)
        velocityHistory.removeAll()
        predictedIndexPaths.removeAll()
    }
}
