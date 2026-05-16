//
//  HFlowView+Animation.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 动画类型枚举
enum HFlowAnimationType {
    case fade          // 淡入淡出
    case slideUp       // 向上滑入
    case slideDown     // 向下滑入
    case slideLeft     // 向左滑入
    case slideRight    // 向右滑入
    case scale         // 缩放
    case bounce        // 弹跳
    case rotate        // 旋转
}

/// 动画配置结构体
struct HFlowAnimationConfig {
    /// 动画类型
    var type: HFlowAnimationType
    /// 动画持续时间
    var duration: TimeInterval
    /// 动画延迟
    var delay: TimeInterval
    /// 动画曲线
    var curve: UIView.AnimationOptions
    
    /// 默认配置
    static let `default` = HFlowAnimationConfig(
        type: .fade,
        duration: 0.3,
        delay: 0.0,
        curve: .curveEaseOut
    )
}

/// HFlowView 动画效果扩展
///
/// 为 HFlowView 提供丰富的动画效果，包括：
/// 1. 单元格的进入动画
/// 2. 数据刷新动画
/// 3. 滚动动画
/// 4. 自定义动画效果

// 关联对象的键
private var cellEnterAnimationConfigKey: UInt8 = 0
private var reloadAnimationConfigKey: UInt8 = 0
private var scrollAnimationConfigKey: UInt8 = 0
private var animationCompletionBlocksKey: UInt8 = 0
private var enableAnimationsKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Animation Properties
    
    /// 单元格进入动画配置
    public var cellEnterAnimationConfig: HFlowAnimationConfig {
        get {
            if let config = objc_getAssociatedObject(self, &cellEnterAnimationConfigKey) as? HFlowAnimationConfig {
                return config
            }
            return HFlowAnimationConfig.default
        }
        set {
            objc_setAssociatedObject(self, &cellEnterAnimationConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 数据刷新动画配置
    public var reloadAnimationConfig: HFlowAnimationConfig {
        get {
            if let config = objc_getAssociatedObject(self, &reloadAnimationConfigKey) as? HFlowAnimationConfig {
                return config
            }
            return HFlowAnimationConfig.default
        }
        set {
            objc_setAssociatedObject(self, &reloadAnimationConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 滚动动画配置
    public var scrollAnimationConfig: HFlowAnimationConfig {
        get {
            if let config = objc_getAssociatedObject(self, &scrollAnimationConfigKey) as? HFlowAnimationConfig {
                return config
            }
            return HFlowAnimationConfig.default
        }
        set {
            objc_setAssociatedObject(self, &scrollAnimationConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 动画队列
    private var animationCompletionBlocks: [() -> Void] {
        get {
            if let blocks = objc_getAssociatedObject(self, &animationCompletionBlocksKey) as? [() -> Void] {
                return blocks
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &animationCompletionBlocksKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 直接使用 HFlowView 类中定义的 enableAnimations 属性
    
    // MARK: - Animation Methods
    
    /// 为指定的 cell 添加进入动画
    /// - Parameters:
    ///   - cell: 要添加动画的 cell
    ///   - indexPath: 索引路径
    ///   - completion: 动画完成回调
    func addEnterAnimation(to cell: UITableViewCell, at indexPath: IndexPath, completion: (() -> Void)? = nil) {
        guard enableAnimations else { 
            completion?()
            return 
        }
        
        // 保存原始状态
        let originalTransform = cell.transform
        let originalAlpha = cell.alpha
        
        // 根据动画类型设置初始状态
        switch cellEnterAnimationConfig.type {
        case .fade:
            cell.alpha = 0.0
        case .slideUp:
            cell.transform = CGAffineTransform(translationX: 0, y: 50)
            cell.alpha = 0.0
        case .slideDown:
            cell.transform = CGAffineTransform(translationX: 0, y: -50)
            cell.alpha = 0.0
        case .slideLeft:
            cell.transform = CGAffineTransform(translationX: 50, y: 0)
            cell.alpha = 0.0
        case .slideRight:
            cell.transform = CGAffineTransform(translationX: -50, y: 0)
            cell.alpha = 0.0
        case .scale:
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            cell.alpha = 0.0
        case .bounce:
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            cell.alpha = 0.0
        case .rotate:
            cell.transform = CGAffineTransform(rotationAngle: .pi / 2)
            cell.alpha = 0.0
        }
        
        // 计算延迟时间，创建交错动画效果
        let delay = cellEnterAnimationConfig.delay + TimeInterval(indexPath.row % 10) * 0.05
        
        // 执行动画
        UIView.animate(
            withDuration: cellEnterAnimationConfig.duration,
            delay: delay,
            options: cellEnterAnimationConfig.curve,
            animations: {
                // 恢复原始状态
                cell.transform = originalTransform
                cell.alpha = originalAlpha
            },
            completion: { _ in
                // 对于弹跳动画，在主动画完成后添加弹跳效果
                if self.cellEnterAnimationConfig.type == .bounce {
                    UIView.animate(
                        withDuration: self.cellEnterAnimationConfig.duration * 0.5,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        },
                        completion: { _ in
                            UIView.animate(
                                withDuration: self.cellEnterAnimationConfig.duration * 0.5,
                                animations: {
                                    cell.transform = originalTransform
                                },
                                completion: { _ in
                                    completion?()
                                    self.animationCompletionBlocks.forEach { $0() }
                                    self.animationCompletionBlocks.removeAll()
                                }
                            )
                        }
                    )
                } else {
                    completion?()
                    self.animationCompletionBlocks.forEach { $0() }
                    self.animationCompletionBlocks.removeAll()
                }
            }
        )
    }
    
    /// 执行数据刷新动画
    /// - Parameter completion: 动画完成回调
    func performReloadAnimation(completion: (() -> Void)? = nil) {
        guard enableAnimations else { 
            completion?()
            return 
        }
        
        // 保存原始状态
        let originalAlpha = alpha
        
        // 设置初始状态
        alpha = 0.0
        
        // 执行动画
        UIView.animate(
            withDuration: reloadAnimationConfig.duration,
            delay: reloadAnimationConfig.delay,
            options: reloadAnimationConfig.curve,
            animations: {
                self.alpha = originalAlpha
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// 执行滚动动画
    /// - Parameters:
    ///   - indexPath: 目标索引路径
    ///   - position: 滚动位置
    ///   - completion: 动画完成回调
    func performScrollAnimation(to indexPath: IndexPath, at position: UITableView.ScrollPosition, completion: (() -> Void)? = nil) {
        // 执行滚动
        scrollToRow(at: indexPath, at: position, animated: true)

        // 延迟执行完成回调（模拟滚动动画结束，避免依赖其他动画路径）
        if let completion = completion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                completion()
            }
        }
    }
    
    /// 为指定的 section 添加头部/尾部动画
    /// - Parameters:
    ///   - view: 头部或尾部视图
    ///   - section: section 索引
    ///   - isHeader: 是否是头部视图
    ///   - completion: 动画完成回调
    func addSectionAnimation(to view: UIView, for section: Int, isHeader: Bool, completion: (() -> Void)? = nil) {
        guard enableAnimations else { 
            completion?()
            return 
        }
        
        // 保存原始状态
        let originalTransform = view.transform
        let originalAlpha = view.alpha
        
        // 设置初始状态
        view.alpha = 0.0
        view.transform = CGAffineTransform(translationX: 0, y: isHeader ? -20 : 20)
        
        // 执行动画
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1 * Double(section),
            options: .curveEaseOut,
            animations: {
                view.transform = originalTransform
                view.alpha = originalAlpha
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// 执行自定义动画
    /// - Parameters:
    ///   - duration: 动画持续时间
    ///   - animations: 动画闭包
    ///   - completion: 动画完成回调
    func performCustomAnimation(duration: TimeInterval, animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
        guard enableAnimations else { 
            animations()
            completion?()
            return 
        }
        
        UIView.animate(
            withDuration: duration,
            animations: animations,
            completion: { _ in
                completion?()
            }
        )
    }
}

/// 扩展 HFlowViewDelegate，添加动画相关方法
extension HFlowViewDelegate {
    /// 获取指定 cell 的动画配置
    /// - Parameter indexPath: 索引路径
    /// - Returns: 动画配置
    func animationConfigForCell(at indexPath: IndexPath) -> HFlowAnimationConfig {
        return HFlowAnimationConfig.default
    }
    
    /// 当 cell 动画开始时调用
    /// - Parameters:
    ///   - cell: 正在执行动画的 cell
    ///   - indexPath: 索引路径
    func animationDidStart(for cell: UITableViewCell, at indexPath: IndexPath) {
        // 默认实现为空
    }
    
    /// 当 cell 动画结束时调用
    /// - Parameters:
    ///   - cell: 执行完动画的 cell
    ///   - indexPath: 索引路径
    func animationDidEnd(for cell: UITableViewCell, at indexPath: IndexPath) {
        // 默认实现为空
    }
}
