//
//  HCollView+SmartPreloading.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 智能预加载扩展
///
/// 根据用户浏览习惯和行为模式，智能预测并预加载可能需要的数据
extension HCollView {
    
    /// 智能预加载管理器
    class SmartPreloadingManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 预加载队列
        private let preloadQueue = DispatchQueue(label: "com.hcollview.preload", qos: .userInitiated, attributes: .concurrent)
        
        /// 预加载的数据
        private var preloadedData: [Int: Any] = [:]
        
        /// 用户浏览历史
        private var browsingHistory: [Int] = []
        
        /// 预加载距离
        var preloadDistance: CGFloat = 200.0
        
        /// 是否启用智能预加载
        var isEnabled: Bool = true
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 检查是否需要预加载
        /// - Returns: 是否需要预加载
        func shouldPreload() -> Bool {
            guard let collectionView = collectionView else { return false }
            guard isEnabled else { return false }
            
            let contentHeight = collectionView.contentSize.height
            let scrollViewHeight = collectionView.bounds.height
            let offsetY = collectionView.contentOffset.y
            
            return contentHeight - offsetY - scrollViewHeight < preloadDistance
        }
        
        /// 预加载数据
        /// - Parameters:
        ///   - indexPaths: 要预加载的索引路径
        ///   - preloadBlock: 预加载闭包
        func preloadData(at indexPaths: [IndexPath], preloadBlock: @escaping (IndexPath) -> Void) {
            preloadQueue.async {
                for indexPath in indexPaths {
                    preloadBlock(indexPath)
                }
            }
        }
        
        /// 预加载即将可见的数据
        /// - Parameter preloadBlock: 预加载闭包
        func preloadUpcomingData(preloadBlock: @escaping (IndexPath) -> Void) {
            guard let collectionView = collectionView else { return }
            
            // 获取当前可见的索引路径
            let visibleIndexPaths = collectionView.indexPathsForVisibleItems
            
            // 计算即将可见的索引路径
            var upcomingIndexPaths: [IndexPath] = []
            
            for indexPath in visibleIndexPaths {
                // 预加载下方的数据
                for i in 1...5 {
                    let upcomingIndexPath = IndexPath(item: indexPath.item + i, section: indexPath.section)
                    if upcomingIndexPath.item < collectionView.numberOfItems(inSection: upcomingIndexPath.section) {
                        upcomingIndexPaths.append(upcomingIndexPath)
                    }
                }
                
                // 预加载上方的数据
                for i in 1...2 {
                    let upcomingIndexPath = IndexPath(item: indexPath.item - i, section: indexPath.section)
                    if upcomingIndexPath.item >= 0 {
                        upcomingIndexPaths.append(upcomingIndexPath)
                    }
                }
            }
            
            // 去重
            let uniqueIndexPaths = Array(Set(upcomingIndexPaths))
            
            // 预加载
            if !uniqueIndexPaths.isEmpty {
                preloadData(at: uniqueIndexPaths, preloadBlock: preloadBlock)
            }
        }
        
        /// 记录浏览历史
        /// - Parameter indexPath: 浏览的索引路径
        func recordBrowsingHistory(_ indexPath: IndexPath) {
            let key = indexPath.section * 10000 + indexPath.item
            
            // 移除已存在的记录
            browsingHistory.removeAll { $0 == key }
            
            // 添加到历史记录开头
            browsingHistory.insert(key, at: 0)
            
            // 限制历史记录数量
            if browsingHistory.count > 50 {
                browsingHistory.removeLast(browsingHistory.count - 50)
            }
        }
        
        /// 预测用户可能浏览的数据
        /// - Returns: 预测的索引路径数组
        func predictBrowsingData() -> [IndexPath] {
            guard let collectionView = collectionView else { return [] }
            
            // 基于浏览历史预测
            var predictedIndexPaths: [IndexPath] = []
            
            // 分析浏览历史，找出用户的浏览模式
            // 这里可以实现更复杂的预测算法
            
            // 简单示例：预测用户可能会继续浏览当前section的下一个item
            if let lastKey = browsingHistory.first {
                let section = lastKey / 10000
                let item = lastKey % 10000
                
                let nextIndexPath = IndexPath(item: item + 1, section: section)
                if nextIndexPath.item < collectionView.numberOfItems(inSection: nextIndexPath.section) {
                    predictedIndexPaths.append(nextIndexPath)
                }
            }
            
            return predictedIndexPaths
        }
        
        /// 缓存预加载的数据
        /// - Parameters:
        ///   - data: 预加载的数据
        ///   - indexPath: 索引路径
        func cachePreloadedData(_ data: Any, for indexPath: IndexPath) {
            let key = indexPath.section * 10000 + indexPath.item
            preloadedData[key] = data
        }
        
        /// 获取预加载的数据
        /// - Parameter indexPath: 索引路径
        /// - Returns: 预加载的数据
        func getPreloadedData(for indexPath: IndexPath) -> Any? {
            let key = indexPath.section * 10000 + indexPath.item
            return preloadedData[key]
        }
        
        /// 清除预加载缓存
        func clearPreloadCache() {
            preloadedData.removeAll()
        }
        
        /// 清除浏览历史
        func clearBrowsingHistory() {
            browsingHistory.removeAll()
        }
    }
    
    /// 智能预加载管理器
    var smartPreloadingManager: SmartPreloadingManager {
        get {
            if let manager = objc_getAssociatedObject(self, &smartPreloadingManagerKey) as? SmartPreloadingManager {
                return manager
            } else {
                let manager = SmartPreloadingManager(collectionView: self)
                objc_setAssociatedObject(self, &smartPreloadingManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &smartPreloadingManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用智能预加载
    /// - Parameter preloadDistance: 预加载距离
    func enableSmartPreloading(preloadDistance: CGFloat = 200.0) {
        smartPreloadingManager.isEnabled = true
        smartPreloadingManager.preloadDistance = preloadDistance
        
        // 监听滚动事件，在滚动时检查是否需要预加载
        // UIScrollView.didScrollNotification 不存在，使用 UIScrollViewDelegate 替代
        self.delegate = self
    }
    
    /// 禁用智能预加载
    func disableSmartPreloading() {
        smartPreloadingManager.isEnabled = false
        smartPreloadingManager.clearPreloadCache()
        smartPreloadingManager.clearBrowsingHistory()
        
        // 移除滚动事件监听
        // UIScrollView.didScrollNotification 不存在
    }
    
    /// 预加载数据
    /// - Parameters:
    ///   - indexPaths: 要预加载的索引路径
    ///   - preloadBlock: 预加载闭包
    func preloadData(at indexPaths: [IndexPath], preloadBlock: @escaping (IndexPath) -> Void) {
        smartPreloadingManager.preloadData(at: indexPaths, preloadBlock: preloadBlock)
    }
    
    /// 记录浏览历史
    /// - Parameter indexPath: 浏览的索引路径
    func recordBrowsingHistory(_ indexPath: IndexPath) {
        smartPreloadingManager.recordBrowsingHistory(indexPath)
    }
    
    /// 获取预加载的数据
    /// - Parameter indexPath: 索引路径
    /// - Returns: 预加载的数据
    func getPreloadedData(for indexPath: IndexPath) -> Any? {
        return smartPreloadingManager.getPreloadedData(for: indexPath)
    }
    
    /// 清除预加载缓存
    func clearPreloadCache() {
        smartPreloadingManager.clearPreloadCache()
    }
    
    /// 滚动时检查是否需要预加载
    @objc private func scrollViewDidScroll() {
        if smartPreloadingManager.shouldPreload() {
            // 这里可以实现预加载逻辑
            // 示例：smartPreloadingManager.preloadUpcomingData { indexPath in /* 预加载逻辑 */ }
        }
    }
}

// 关联对象键
private var smartPreloadingManagerKey: UInt8 = 0
