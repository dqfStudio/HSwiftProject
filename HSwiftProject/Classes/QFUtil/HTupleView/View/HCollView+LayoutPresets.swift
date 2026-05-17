//
//  HCollView+LayoutPresets.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 布局预设
enum HCollViewLayoutPreset {
    case grid(columns: Int)          // 网格布局
    case list                        // 列表布局
    case waterfall                   // 瀑布流布局（使用 HCollViewLayout）
    case horizontalScroll            // 水平滚动布局
    case staggeredGrid(columns: Int) // 交错网格布局
}

/// HCollView 布局预设扩展
///
/// 提供常见的布局预设
extension HCollView {
    
    /// 应用布局预设
    /// - Parameter preset: 布局预设
    func applyLayoutPreset(_ preset: HCollViewLayoutPreset) {
        switch preset {
        case .grid(let columns):
            applyGridLayout(columns: columns)
        case .list:
            applyListLayout()
        case .waterfall:
            applyWaterfallLayout()
        case .horizontalScroll:
            applyHorizontalScrollLayout()
        case .staggeredGrid(let columns):
            applyStaggeredGridLayout(columns: columns)
        }
    }
    
    /// 应用网格布局 — 支持 self-sizing
    /// - Parameter columns: 列数
    private func applyGridLayout(columns: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let padding: CGFloat = 10
        let itemWidth = (bounds.width - padding * 2 - CGFloat(columns - 1) * 10) / CGFloat(columns)
        
        // 设置 estimatedItemSize 启用 self-sizing
        // 宽度固定，高度用 estimated，cell 的 preferredLayoutAttributesFitting 会返回真实高度
        layout.estimatedItemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
    }
    
    /// 应用列表布局 — 支持 self-sizing
    private func applyListLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // estimatedItemSize 启动 self-sizing，宽度占满，高度由 cell 自己决定
        layout.estimatedItemSize = CGSize(width: bounds.width - 20, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
    }
    
    /// 应用瀑布流布局 — 使用 HCollViewLayout 的瀑布流模式
    private func applyWaterfallLayout() {
        let layout = HCollViewLayout()
        // 不设置 estimatedItemSize，使用瀑布流模式（全量计算）
        
        let padding: CGFloat = 10
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
    }
    
    /// 应用水平滚动布局
    private func applyHorizontalScrollLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let itemWidth: CGFloat = 200
        let itemHeight: CGFloat = bounds.height - 20
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
        
        enableHorizontalBounce()
    }
    
    /// 应用交错网格布局 — 使用 HCollViewLayout 实现瀑布流效果
    /// - Parameter columns: 列数
    private func applyStaggeredGridLayout(columns: Int) {
        // 使用 HCollViewLayout 的 self-sizing 模式
        let layout = HCollViewLayout()
        let padding: CGFloat = 10
        let itemWidth = (bounds.width - padding * 2 - CGFloat(columns - 1) * 10) / CGFloat(columns)
        
        // 设置 estimatedItemSize 启用 self-sizing 模式
        layout.estimatedItemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
    }
    
    /// 自定义布局
    /// - Parameters:
    ///   - itemSize: item 尺寸
    ///   - lineSpacing: 行间距
    ///   - interitemSpacing: item 间距
    ///   - sectionInset: section 内边距
    ///   - scrollDirection: 滚动方向
    func applyCustomLayout(
        itemSize: CGSize,
        lineSpacing: CGFloat = 10,
        interitemSpacing: CGFloat = 10,
        sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        scrollDirection: UICollectionView.ScrollDirection = .vertical
    ) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.itemSize = itemSize
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interitemSpacing
        layout.sectionInset = sectionInset
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
        
        if scrollDirection == .vertical {
            enableVerticalBounce()
        } else {
            enableHorizontalBounce()
        }
    }
}
