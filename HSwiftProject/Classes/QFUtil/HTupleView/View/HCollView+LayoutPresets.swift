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
    case waterfall                   // 瀑布流布局
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
    
    /// 应用网格布局
    /// - Parameter columns: 列数
    private func applyGridLayout(columns: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // 计算 item 宽度
        let padding: CGFloat = 10
        let itemWidth = (bounds.width - padding * 2 - CGFloat(columns - 1) * 10) / CGFloat(columns)
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
    }
    
    /// 应用列表布局
    private func applyListLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // 列表项高度
        let itemHeight: CGFloat = 80
        
        layout.itemSize = CGSize(width: bounds.width - 20, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
    }
    
    /// 应用瀑布流布局
    private func applyWaterfallLayout() {
        // 这里使用 UICollectionViewFlowLayout 模拟瀑布流布局
        // 实际项目中可以使用专门的瀑布流布局库
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // 计算 item 宽度（2列）
        let padding: CGFloat = 10
        let itemWidth = (bounds.width - padding * 2 - 10) / 2
        
        // 注意：瀑布流布局需要动态计算 item 高度
        // 这里设置一个默认高度，实际使用时需要在代理方法中返回真实高度
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
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
        
        // 水平滚动项宽度
        let itemWidth: CGFloat = 200
        let itemHeight: CGFloat = bounds.height - 20
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        setCollectionViewLayout(layout, animated: true)
        flowLayout = layout
        
        // 启用水平弹跳
        enableHorizontalBounce()
    }
    
    /// 应用交错网格布局
    /// - Parameter columns: 列数
    private func applyStaggeredGridLayout(columns: Int) {
        // 这里使用 UICollectionViewFlowLayout 模拟交错网格布局
        // 实际项目中可以使用专门的交错网格布局库
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        // 计算 item 宽度
        let padding: CGFloat = 10
        let itemWidth = (bounds.width - padding * 2 - CGFloat(columns - 1) * 10) / CGFloat(columns)
        
        // 注意：交错网格布局需要动态计算 item 高度
        // 这里设置一个默认高度，实际使用时需要在代理方法中返回真实高度
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
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
        
        // 根据滚动方向调整弹跳行为
        if scrollDirection == .vertical {
            enableVerticalBounce()
        } else {
            enableHorizontalBounce()
        }
    }
}
