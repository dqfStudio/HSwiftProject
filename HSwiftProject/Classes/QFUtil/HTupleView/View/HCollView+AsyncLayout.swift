//
//  HCollView+AsyncLayout.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 异步布局扩展
///
/// 将布局计算移到后台线程，避免阻塞主线程
extension HCollView {
    
    /// 异步布局管理器
    class AsyncLayoutManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 布局计算队列
        private let layoutQueue = DispatchQueue(label: "com.hcollview.layout", qos: .userInitiated, attributes: .concurrent)
        
        /// 布局缓存
        private var layoutCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
        
        /// 是否正在计算布局
        private var isCalculatingLayout: Bool = false
        
        /// 布局计算完成回调
        private var layoutCompletion: (() -> Void)?
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 异步计算布局
        /// - Parameter completion: 完成回调
        func calculateLayoutAsync(completion: @escaping () -> Void) {
            guard let collectionView = collectionView else { return }
            guard !isCalculatingLayout else { return }
            
            isCalculatingLayout = true
            layoutCompletion = completion
            
            layoutQueue.async {
                // 清空布局缓存
                self.layoutCache.removeAll()
                
                // 计算所有 item 的布局
                let sections = collectionView.numberOfSections
                for section in 0..<sections {
                    let items = collectionView.numberOfItems(inSection: section)
                    for item in 0..<items {
                        let indexPath = IndexPath(item: item, section: section)
                        
                        // 计算布局属性
                        if let attributes = self.calculateLayoutAttributes(for: indexPath) {
                            self.layoutCache[indexPath] = attributes
                        }
                    }
                }
                
                // 计算完成，回调主线程
                DispatchQueue.main.async {
                    self.isCalculatingLayout = false
                    self.layoutCompletion?()
                }
            }
        }
        
        /// 计算指定 indexPath 的布局属性
        /// - Parameter indexPath: 索引路径
        /// - Returns: 布局属性
        private func calculateLayoutAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let collectionView = collectionView else { return nil }
            
            // 创建布局属性
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 计算 item 尺寸
            let itemSize = collectionView.collDelegate?.sizeForItemAt?(indexPath) ?? CGSize(width: 100, height: 100)
            
            // 计算 item 位置
            var x: CGFloat = 0
            var y: CGFloat = 0
            
            // 计算 section 偏移
            let sectionInset = collectionView.collDelegate?.insetForSection?(indexPath.section) ?? .zero
            x += sectionInset.left
            y += sectionInset.top
            
            // 计算前面 section 的高度
            for section in 0..<indexPath.section {
                // 计算 section header 高度
                let headerHeight = collectionView.collDelegate?.sizeForHeaderInSection?(section)?.height ?? 0
                y += headerHeight
                
                // 计算 section 内所有 item 的高度
                let items = collectionView.numberOfItems(inSection: section)
                for item in 0..<items {
                    let itemSize = collectionView.collDelegate?.sizeForItemAt?(IndexPath(item: item, section: section)) ?? CGSize(width: 100, height: 100)
                    y += itemSize.height
                    
                    // 添加行间距
                    if item < items - 1 {
                        y += collectionView.flowLayout?.minimumLineSpacing ?? 0
                    }
                }
                
                // 计算 section footer 高度
                let footerHeight = collectionView.collDelegate?.sizeForFooterInSection?(section)?.height ?? 0
                y += footerHeight
                
                // 添加 section 间距
                if section < indexPath.section - 1 {
                    y += collectionView.flowLayout?.sectionInset.bottom ?? 0
                }
            }
            
            // 计算当前 section 内前面 item 的高度
            let currentSectionItems = collectionView.numberOfItems(inSection: indexPath.section)
            for item in 0..<indexPath.item {
                let itemSize = collectionView.collDelegate?.sizeForItemAt?(IndexPath(item: item, section: indexPath.section)) ?? CGSize(width: 100, height: 100)
                y += itemSize.height
                
                // 添加行间距
                if item < currentSectionItems - 1 {
                    y += collectionView.flowLayout?.minimumLineSpacing ?? 0
                }
            }
            
            // 设置布局属性
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            
            return attributes
        }
        
        /// 获取缓存的布局属性
        /// - Parameter indexPath: 索引路径
        /// - Returns: 布局属性
        func getCachedLayoutAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return layoutCache[indexPath]
        }
        
        /// 清除布局缓存
        func clearLayoutCache() {
            layoutCache.removeAll()
        }
        
        /// 异步更新布局
        /// - Parameter completion: 完成回调
        func updateLayoutAsync(completion: @escaping () -> Void) {
            calculateLayoutAsync(completion: completion)
        }
    }
    
    /// 异步布局管理器
    var asyncLayoutManager: AsyncLayoutManager {
        get {
            if let manager = objc_getAssociatedObject(self, &asyncLayoutManagerKey) as? AsyncLayoutManager {
                return manager
            } else {
                let manager = AsyncLayoutManager(collectionView: self)
                objc_setAssociatedObject(self, &asyncLayoutManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &asyncLayoutManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用异步布局
    func enableAsyncLayout() {
        // 异步计算初始布局
        asyncLayoutManager.calculateLayoutAsync { [weak self] in
            self?.reloadData()
        }
    }
    
    /// 禁用异步布局
    func disableAsyncLayout() {
        asyncLayoutManager.clearLayoutCache()
    }
    
    /// 异步更新布局
    /// - Parameter completion: 完成回调
    func updateLayoutAsync(completion: @escaping () -> Void) {
        asyncLayoutManager.updateLayoutAsync(completion: completion)
    }
    
    /// 获取缓存的布局属性
    /// - Parameter indexPath: 索引路径
    /// - Returns: 布局属性
    func getCachedLayoutAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return asyncLayoutManager.getCachedLayoutAttributes(for: indexPath)
    }
}

// 关联对象键
private var asyncLayoutManagerKey: UInt8 = 0
