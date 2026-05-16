//
//  HCollView+Animation.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 的动画扩展
///
/// 提供过渡动画和自定义交互动画功能
extension HCollView {
    
    /// 动画类型
    enum AnimationType {
        case fade        // 淡入淡出
        case slide       // 滑动
        case scale       // 缩放
        case bounce      // 弹跳
        case rotation    // 旋转
    }
    
    /// 添加 cell 显示动画
    /// - Parameters:
    ///   - cell: 要添加动画的 cell
    ///   - indexPath: cell 的索引路径
    ///   - animationType: 动画类型
    func addCellAnimation(_ cell: UICollectionViewCell, at indexPath: IndexPath, animationType: AnimationType = .fade) {
        // 重置 cell 状态
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // 根据动画类型执行不同的动画
        let delay = TimeInterval(indexPath.item) * 0.05 // 错开动画时间，创建层次感
        
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            switch animationType {
            case .fade:
                cell.alpha = 1
                cell.transform = .identity
            case .slide:
                cell.alpha = 1
                cell.transform = .identity
            case .scale:
                cell.alpha = 1
                cell.transform = .identity
            case .bounce:
                cell.alpha = 1
                cell.transform = .identity
            case .rotation:
                cell.alpha = 1
                cell.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    /// 批量添加 cell 显示动画
    /// - Parameters:
    ///   - cells: 要添加动画的 cell 数组
    ///   - animationType: 动画类型
    func addBatchCellAnimation(_ cells: [UICollectionViewCell], animationType: AnimationType = .fade) {
        for (index, cell) in cells.enumerated() {
            let delay = TimeInterval(index) * 0.03 // 更短的延迟，加快动画速度
            
            UIView.animate(withDuration: 0.4, delay: delay, options: .curveEaseOut) {
                switch animationType {
                case .fade:
                    cell.alpha = 1
                case .slide:
                    cell.alpha = 1
                    cell.transform = .identity
                case .scale:
                    cell.alpha = 1
                    cell.transform = .identity
                case .bounce:
                    cell.alpha = 1
                    cell.transform = .identity
                case .rotation:
                    cell.alpha = 1
                    cell.transform = CGAffineTransform(rotationAngle: 0)
                }
            }
        }
    }
    
    /// 自定义刷新动画
    /// - Parameter animationBlock: 动画闭包
    func setCustomRefreshAnimation(_ animationBlock: @escaping (UIView) -> Void) {
        // 创建自定义刷新头部
        let customHeader = MJRefreshCustomHeader {
            // 刷新回调
            self.refreshBlock?()
        }
        
        // 应用自定义动画
        animationBlock(customHeader)
        
        // 设置刷新头部
        mj_header = customHeader
    }
    
    /// 自定义加载更多动画
    /// - Parameter animationBlock: 动画闭包
    func setCustomLoadMoreAnimation(_ animationBlock: @escaping (UIView) -> Void) {
        // 创建自定义加载更多底部
        let customFooter = MJRefreshCustomFooter {
            // 加载更多回调
            self.loadMoreBlock?()
        }
        
        // 应用自定义动画
        animationBlock(customFooter)
        
        // 设置加载更多底部
        mj_footer = customFooter
    }
    
    /// 平滑滚动到指定位置
    /// - Parameters:
    ///   - indexPath: 目标索引路径
    ///   - position: 滚动位置
    ///   - duration: 动画持续时间
    func smoothScroll(to indexPath: IndexPath, at position: UICollectionView.ScrollPosition, duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            self.scrollToItem(at: indexPath, at: position, animated: false)
        }
    }
    
    /// 骨架屏动画
    /// - Parameters:
    ///   - enabled: 是否启用骨架屏
    ///   - animationType: 动画类型
    func setSkeletonAnimation(enabled: Bool, animationType: AnimationType = .fade) {
        // 这里可以集成骨架屏库，如 TABAnimated
        // 示例代码：
        /*
        if enabled {
            self.tab_startAnimation()
        } else {
            self.tab_endAnimation()
        }
        */
    }
    
    /// 滚动指示器动画
    /// - Parameter enabled: 是否启用动画
    func setScrollIndicatorAnimation(enabled: Bool) {
        if enabled {
            // 启用滚动指示器动画
            showsVerticalScrollIndicator = true
            showsHorizontalScrollIndicator = true
        } else {
            // 禁用滚动指示器动画
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
        }
    }
}
