//
//  HCollView+PreRendering.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 预渲染扩展
///
/// 实现预渲染即将可见的cell，减少滚动时的卡顿
extension HCollView {
    
    /// 预渲染管理器
    class PreRenderingManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 预渲染队列
        private let preRenderQueue = DispatchQueue(label: "com.hcollview.prerender", qos: .userInitiated)
        
        /// 预渲染的 cell 缓存
        private var preRenderedCells: [String: UICollectionViewCell] = [:]
        
        /// 预渲染的 supplementary view 缓存
        private var preRenderedSupplementaryViews: [String: UICollectionReusableView] = [:]
        
        /// 预渲染的数量
        var preRenderCount: Int = 5
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 预渲染 cell
        /// - Parameters:
        ///   - indexPaths: 索引路径数组
        ///   - reuseIdentifier: 重用标识符
        func preRenderCells(at indexPaths: [IndexPath], reuseIdentifier: String) {
            preRenderQueue.async {
                guard let collectionView = self.collectionView else { return }
                
                for indexPath in indexPaths {
                    let cacheKey = "\(reuseIdentifier)_\(indexPath.section)_\(indexPath.item)"
                    
                    // 检查是否已经预渲染
                    if self.preRenderedCells[cacheKey] == nil {
                        // 创建 cell
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                        
                        // 预渲染 cell
                        self.preRenderCell(cell, at: indexPath)
                        
                        // 缓存预渲染的 cell
                        self.preRenderedCells[cacheKey] = cell
                    }
                }
            }
        }
        
        /// 预渲染 supplementary view
        /// - Parameters:
        ///   - indexPaths: 索引路径数组
        ///   - elementKind: 元素类型
        ///   - reuseIdentifier: 重用标识符
        func preRenderSupplementaryViews(at indexPaths: [IndexPath], elementKind: String, reuseIdentifier: String) {
            preRenderQueue.async {
                guard let collectionView = self.collectionView else { return }
                
                for indexPath in indexPaths {
                    let cacheKey = "\(elementKind)_\(reuseIdentifier)_\(indexPath.section)_\(indexPath.item)"
                    
                    // 检查是否已经预渲染
                    if self.preRenderedSupplementaryViews[cacheKey] == nil {
                        // 创建 supplementary view
                        let view = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: reuseIdentifier, for: indexPath)
                        
                        // 预渲染 view
                        self.preRenderSupplementaryView(view, at: indexPath, elementKind: elementKind)
                        
                        // 缓存预渲染的 view
                        self.preRenderedSupplementaryViews[cacheKey] = view
                    }
                }
            }
        }
        
        /// 预渲染 cell
        /// - Parameters:
        ///   - cell: cell
        ///   - indexPath: 索引路径
        private func preRenderCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
            // 这里可以实现 cell 的预渲染逻辑
            // 例如：计算布局、加载图片等
            
            // 强制 cell 布局
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        /// 预渲染 supplementary view
        /// - Parameters:
        ///   - view: supplementary view
        ///   - indexPath: 索引路径
        ///   - elementKind: 元素类型
        private func preRenderSupplementaryView(_ view: UICollectionReusableView, at indexPath: IndexPath, elementKind: String) {
            // 这里可以实现 supplementary view 的预渲染逻辑
            // 例如：计算布局、加载图片等
            
            // 强制 view 布局
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
        /// 获取预渲染的 cell
        /// - Parameters:
        ///   - indexPath: 索引路径
        ///   - reuseIdentifier: 重用标识符
        /// - Returns: 预渲染的 cell
        func getPreRenderedCell(at indexPath: IndexPath, reuseIdentifier: String) -> UICollectionViewCell? {
            let cacheKey = "\(reuseIdentifier)_\(indexPath.section)_\(indexPath.item)"
            return preRenderedCells[cacheKey]
        }
        
        /// 获取预渲染的 supplementary view
        /// - Parameters:
        ///   - indexPath: 索引路径
        ///   - elementKind: 元素类型
        ///   - reuseIdentifier: 重用标识符
        /// - Returns: 预渲染的 supplementary view
        func getPreRenderedSupplementaryView(at indexPath: IndexPath, elementKind: String, reuseIdentifier: String) -> UICollectionReusableView? {
            let cacheKey = "\(elementKind)_\(reuseIdentifier)_\(indexPath.section)_\(indexPath.item)"
            return preRenderedSupplementaryViews[cacheKey]
        }
        
        /// 清除预渲染缓存
        func clearPreRenderCache() {
            preRenderedCells.removeAll()
            preRenderedSupplementaryViews.removeAll()
        }
        
        /// 清除指定索引路径的预渲染缓存
        /// - Parameter indexPaths: 索引路径数组
        func clearPreRenderCache(for indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
                // 清除 cell 缓存
                for (key, _) in preRenderedCells where key.contains("_\(indexPath.section)_\(indexPath.item)") {
                    preRenderedCells.removeValue(forKey: key)
                }
                
                // 清除 supplementary view 缓存
                for (key, _) in preRenderedSupplementaryViews where key.contains("_\(indexPath.section)_\(indexPath.item)") {
                    preRenderedSupplementaryViews.removeValue(forKey: key)
                }
            }
        }
        
        /// 预渲染即将可见的 cell
        func preRenderUpcomingCells() {
            guard let collectionView = self.collectionView else { return }
            
            // 获取当前可见的索引路径
            let visibleIndexPaths = collectionView.indexPathsForVisibleItems
            
            // 计算即将可见的索引路径
            var upcomingIndexPaths: [IndexPath] = []
            
            for indexPath in visibleIndexPaths {
                // 预渲染下方的 cell
                for i in 1...preRenderCount {
                    let upcomingIndexPath = IndexPath(item: indexPath.item + i, section: indexPath.section)
                    if upcomingIndexPath.item < collectionView.numberOfItems(inSection: upcomingIndexPath.section) {
                        upcomingIndexPaths.append(upcomingIndexPath)
                    }
                }
                
                // 预渲染上方的 cell
                for i in 1...preRenderCount {
                    let upcomingIndexPath = IndexPath(item: indexPath.item - i, section: indexPath.section)
                    if upcomingIndexPath.item >= 0 {
                        upcomingIndexPaths.append(upcomingIndexPath)
                    }
                }
            }
            
            // 去重
            let uniqueIndexPaths = Array(Set(upcomingIndexPaths))
            
            // 预渲染
            if !uniqueIndexPaths.isEmpty {
                // 这里需要知道 reuseIdentifier，实际使用时需要根据具体情况调整
                // 示例：preRenderCells(at: uniqueIndexPaths, reuseIdentifier: "Cell")
            }
        }
    }
    
    /// 预渲染管理器
    var preRenderingManager: PreRenderingManager {
        get {
            if let manager = objc_getAssociatedObject(self, &preRenderingManagerKey) as? PreRenderingManager {
                return manager
            } else {
                let manager = PreRenderingManager(collectionView: self)
                objc_setAssociatedObject(self, &preRenderingManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &preRenderingManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用预渲染
    /// - Parameter preRenderCount: 预渲染的数量
    func enablePreRendering(preRenderCount: Int = 5) {
        preRenderingManager.preRenderCount = preRenderCount
        
        // 监听滚动事件，在滚动时预渲染
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollViewDidScroll),
            name: UIScrollView.didScrollNotification,
            object: self
        )
    }
    
    /// 禁用预渲染
    func disablePreRendering() {
        preRenderingManager.clearPreRenderCache()
        
        // 移除滚动事件监听
        NotificationCenter.default.removeObserver(self, name: UIScrollView.didScrollNotification, object: self)
    }
    
    /// 预渲染指定的 cell
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - reuseIdentifier: 重用标识符
    func preRenderCells(at indexPaths: [IndexPath], reuseIdentifier: String) {
        preRenderingManager.preRenderCells(at: indexPaths, reuseIdentifier: reuseIdentifier)
    }
    
    /// 预渲染指定的 supplementary view
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - elementKind: 元素类型
    ///   - reuseIdentifier: 重用标识符
    func preRenderSupplementaryViews(at indexPaths: [IndexPath], elementKind: String, reuseIdentifier: String) {
        preRenderingManager.preRenderSupplementaryViews(at: indexPaths, elementKind: elementKind, reuseIdentifier: reuseIdentifier)
    }
    
    /// 清除预渲染缓存
    func clearPreRenderCache() {
        preRenderingManager.clearPreRenderCache()
    }
    
    /// 滚动时预渲染
    @objc private func scrollViewDidScroll() {
        preRenderingManager.preRenderUpcomingCells()
    }
}

// 关联对象键
private var preRenderingManagerKey: UInt8 = 0
