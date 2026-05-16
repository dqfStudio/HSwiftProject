//
//  HCollView+VirtualScrolling.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 虚拟滚动扩展
///
/// 实现虚拟滚动，只渲染可见区域的cell，提升大量数据时的性能
extension HCollView {
    
    /// 虚拟滚动管理器
    class VirtualScrollingManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 数据总数
        var totalItems: Int = 0
        
        /// 可见区域外的缓冲数量
        var bufferItems: Int = 5
        
        /// cell 高度缓存
        private var cellHeightCache: [Int: CGFloat] = [:]
        
        /// 默认 cell 高度
        var defaultCellHeight: CGFloat = 100.0
        
        /// 估算的内容高度
        var estimatedContentHeight: CGFloat {
            return CGFloat(totalItems) * defaultCellHeight
        }
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 获取可见的索引范围
        /// - Returns: 可见的索引范围
        func getVisibleIndexRange() -> Range<Int> {
            guard let collectionView = collectionView else { return 0..<0 }
            
            let contentOffset = collectionView.contentOffset.y
            let visibleHeight = collectionView.bounds.height
            
            // 计算可见区域的起始和结束索引
            let startIndex = max(0, Int(contentOffset / defaultCellHeight) - bufferItems)
            let endIndex = min(totalItems, Int((contentOffset + visibleHeight) / defaultCellHeight) + bufferItems)
            
            return startIndex..<endIndex
        }
        
        /// 获取可见的索引路径
        /// - Returns: 可见的索引路径数组
        func getVisibleIndexPaths() -> [IndexPath] {
            let range = getVisibleIndexRange()
            return range.map { IndexPath(item: $0, section: 0) }
        }
        
        /// 缓存 cell 高度
        /// - Parameters:
        ///   - height: cell 高度
        ///   - index: 索引
        func cacheCellHeight(_ height: CGFloat, for index: Int) {
            cellHeightCache[index] = height
        }
        
        /// 获取缓存的 cell 高度
        /// - Parameter index: 索引
        /// - Returns: cell 高度
        func getCachedCellHeight(for index: Int) -> CGFloat {
            return cellHeightCache[index] ?? defaultCellHeight
        }
        
        /// 清除高度缓存
        func clearHeightCache() {
            cellHeightCache.removeAll()
        }
        
        /// 计算内容高度
        /// - Returns: 内容高度
        func calculateContentHeight() -> CGFloat {
            var totalHeight: CGFloat = 0.0
            
            for i in 0..<totalItems {
                totalHeight += getCachedCellHeight(for: i)
            }
            
            return totalHeight
        }
        
        /// 滚动到指定索引
        /// - Parameters:
        ///   - index: 索引
        ///   - animated: 是否动画
        func scrollToIndex(_ index: Int, animated: Bool) {
            guard let collectionView = collectionView else { return }
            
            // 计算滚动位置
            var offsetY: CGFloat = 0.0
            for i in 0..<index {
                offsetY += getCachedCellHeight(for: i)
            }
            
            // 滚动到指定位置
            collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
        }
    }
    
    /// 虚拟滚动管理器
    var virtualScrollingManager: VirtualScrollingManager {
        get {
            if let manager = objc_getAssociatedObject(self, &virtualScrollingManagerKey) as? VirtualScrollingManager {
                return manager
            } else {
                let manager = VirtualScrollingManager(collectionView: self)
                objc_setAssociatedObject(self, &virtualScrollingManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &virtualScrollingManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用虚拟滚动
    func enableVirtualScrolling(totalItems: Int, defaultCellHeight: CGFloat = 100.0) {
        virtualScrollingManager.totalItems = totalItems
        virtualScrollingManager.defaultCellHeight = defaultCellHeight
        estimatedItemSize = CGSize(width: bounds.width - 20, height: defaultCellHeight)
    }

    /// 禁用虚拟滚动
    func disableVirtualScrolling() {
        virtualScrollingManager.totalItems = 0
        virtualScrollingManager.clearHeightCache()
    }
    
    /// 更新虚拟滚动数据
    /// - Parameter totalItems: 数据总数
    func updateVirtualScrollingData(totalItems: Int) {
        virtualScrollingManager.totalItems = totalItems
        reloadData()
    }
    
    /// 滚动到虚拟滚动的指定索引
    /// - Parameters:
    ///   - index: 索引
    ///   - animated: 是否动画
    func scrollToVirtualIndex(_ index: Int, animated: Bool) {
        virtualScrollingManager.scrollToIndex(index, animated: animated)
    }
}

// 关联对象键
private var virtualScrollingManagerKey: UInt8 = 0

// MARK: - UICollectionViewDataSource 虚拟滚动扩展
extension HCollView {
    
    /// 虚拟滚动的 numberOfItemsInSection
    /// - Parameter section:  section
    /// - Returns: 可见区域的 item 数量
    func virtualScrollingNumberOfItems(inSection section: Int) -> Int {
        return virtualScrollingManager.getVisibleIndexRange().count
    }
    
    /// 虚拟滚动的 cellForItemAt
    /// - Parameter indexPath: 索引路径
    /// - Returns: cell
    func virtualScrollingCellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        // 获取可见索引范围
        let visibleRange = virtualScrollingManager.getVisibleIndexRange()
        
        // 计算实际索引
        let actualIndex = visibleRange.lowerBound + indexPath.item
        
        // 这里需要根据实际索引获取数据并创建 cell
        // 示例代码：
        /*
        let cell = dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let data = dataSource[actualIndex]
        // 配置 cell
        return cell
        */
        
        return nil
    }
    
    /// 虚拟滚动的 sizeForItemAt
    /// - Parameter indexPath: 索引路径
    /// - Returns: item 尺寸
    func virtualScrollingSizeForItem(at indexPath: IndexPath) -> CGSize {
        // 获取可见索引范围
        let visibleRange = virtualScrollingManager.getVisibleIndexRange()
        
        // 计算实际索引
        let actualIndex = visibleRange.lowerBound + indexPath.item
        
        // 获取 cell 高度
        let height = virtualScrollingManager.getCachedCellHeight(for: actualIndex)
        
        return CGSize(width: bounds.width - 20, height: height)
    }
}
