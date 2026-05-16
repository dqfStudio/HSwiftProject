//
//  HFlowView+MicroInteraction.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import MJRefresh

/// 微交互类型枚举
enum HFlowMicroInteractionType {
    case press        // 按压效果
    case release      // 释放效果
    case highlight    // 高亮效果
    case shake        // 摇晃效果
    case pulse        // 脉冲效果
    case bounce       // 弹跳效果
    case scale        // 缩放效果
}

/// 微交互配置结构体
struct HFlowMicroInteractionConfig {
    /// 微交互类型
    var type: HFlowMicroInteractionType
    /// 动画持续时间
    var duration: TimeInterval
    /// 动画强度
    var intensity: CGFloat
    
    /// 默认配置
    static let `default` = HFlowMicroInteractionConfig(
        type: .press,
        duration: 0.1,
        intensity: 0.95
    )
}

/// HFlowView 微交互扩展
///
/// 为 HFlowView 提供丰富的微交互效果，增强用户体验
///
/// 实现功能：
/// 1. 支持多种微交互类型
/// 2. 为 cell 提供按压、释放、高亮等效果
/// 3. 提供自定义微交互配置
/// 4. 响应不同的用户操作

// 关联对象的键
private var enableMicroInteractionKey: UInt8 = 0
private var microInteractionConfigKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Micro Interaction Properties
    
    /// 是否启用微交互
    public var enableMicroInteraction: Bool {
        get {
            if let enable = objc_getAssociatedObject(self, &enableMicroInteractionKey) as? Bool {
                return enable
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &enableMicroInteractionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 微交互配置
    public var microInteractionConfig: HFlowMicroInteractionConfig {
        get {
            if let config = objc_getAssociatedObject(self, &microInteractionConfigKey) as? HFlowMicroInteractionConfig {
                return config
            }
            return HFlowMicroInteractionConfig.default
        }
        set {
            objc_setAssociatedObject(self, &microInteractionConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Micro Interaction Methods
    
    /// 为指定的 cell 添加微交互效果
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - type: 微交互类型
    ///   - completion: 微交互完成回调
    func addMicroInteraction(to view: UIView, type: HFlowMicroInteractionType, completion: (() -> Void)? = nil) {
        guard enableMicroInteraction else { 
            completion?()
            return 
        }
        
        switch type {
        case .press:
            performPressInteraction(on: view, completion: completion)
        case .release:
            performReleaseInteraction(on: view, completion: completion)
        case .highlight:
            performHighlightInteraction(on: view, completion: completion)
        case .shake:
            performShakeInteraction(on: view, completion: completion)
        case .pulse:
            performPulseInteraction(on: view, completion: completion)
        case .bounce:
            performBounceInteraction(on: view, completion: completion)
        case .scale:
            performScaleInteraction(on: view, completion: completion)
        }
    }
    
    /// 执行按压微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performPressInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: microInteractionConfig.duration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                view.transform = CGAffineTransform(scaleX: self.microInteractionConfig.intensity, y: self.microInteractionConfig.intensity)
                view.alpha = 0.8
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// 执行释放微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performReleaseInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: microInteractionConfig.duration * 1.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                view.transform = .identity
                view.alpha = 1.0
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// 执行高亮微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performHighlightInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        let originalBackgroundColor = view.backgroundColor
        
        UIView.animate(
            withDuration: microInteractionConfig.duration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: self.microInteractionConfig.duration,
                    delay: 0,
                    animations: {
                        view.backgroundColor = originalBackgroundColor
                    },
                    completion: { _ in
                        completion?()
                    }
                )
            }
        )
    }
    
    /// 执行摇晃微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performShakeInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = microInteractionConfig.duration * 2
        animation.values = [-0.1, 0.1, -0.1, 0.1, 0]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        
        view.layer.add(animation, forKey: "shake")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
            completion?()
        }
    }
    
    /// 执行脉冲微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performPulseInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = microInteractionConfig.duration
        animation.fromValue = 1.0
        animation.toValue = 1.05
        animation.autoreverses = true
        animation.repeatCount = 1
        
        view.layer.add(animation, forKey: "pulse")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration * 2) {
            completion?()
        }
    }
    
    /// 执行弹跳微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performBounceInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: microInteractionConfig.duration,
            animations: {
                view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: self.microInteractionConfig.duration * 1.5,
                    animations: {
                        view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    },
                    completion: { _ in
                        UIView.animate(
                            withDuration: self.microInteractionConfig.duration,
                            animations: {
                                view.transform = .identity
                            },
                            completion: { _ in
                                completion?()
                            }
                        )
                    }
                )
            }
        )
    }
    
    /// 执行缩放微交互
    /// - Parameters:
    ///   - cell: 要添加微交互的 cell
    ///   - completion: 微交互完成回调
    private func performScaleInteraction(on view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: microInteractionConfig.duration,
            animations: {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: self.microInteractionConfig.duration,
                    animations: {
                        view.transform = .identity
                    },
                    completion: { _ in
                        completion?()
                    }
                )
            }
        )
    }
    
    /// 为 cell 选择添加微交互
    /// - Parameter cell: 选中的 cell
    func addMicroInteractionForCellSelection(_ cell: UITableViewCell) {
        addMicroInteraction(to: cell, type: .press) { [weak self] in
            guard let self = self else { return }
            self.addMicroInteraction(to: cell, type: .release)
        }
    }
    
    /// 为下拉刷新添加微交互
    func addMicroInteractionForRefresh() {
        // 为刷新控件添加微交互
        if let refreshHeader = mj_header as? MJRefreshHeader {
            let view = refreshHeader as UIView
            addMicroInteraction(to: view, type: .pulse)
        }
    }

    /// 为加载更多添加微交互
    func addMicroInteractionForLoadMore() {
        // 为加载更多控件添加微交互
        if let loadMoreFooter = mj_footer as? MJRefreshFooter {
            let view = loadMoreFooter as UIView
            addMicroInteraction(to: view, type: .scale)
        }
    }
}

/// 扩展 HFlowViewDelegate，添加微交互相关方法
extension HFlowViewDelegate {
    /// 获取指定 cell 的微交互配置
    /// - Parameter indexPath: 索引路径
    /// - Returns: 微交互配置
    func microInteractionConfigForCell(at indexPath: IndexPath) -> HFlowMicroInteractionConfig {
        return HFlowMicroInteractionConfig.default
    }
    
    /// 当 cell 微交互开始时调用
    /// - Parameters:
    ///   - cell: 正在执行微交互的 cell
    ///   - type: 微交互类型
    ///   - indexPath: 索引路径
    func microInteractionDidStart(for cell: UITableViewCell, type: HFlowMicroInteractionType, at indexPath: IndexPath) {
        // 默认实现为空
    }
    
    /// 当 cell 微交互结束时调用
    /// - Parameters:
    ///   - cell: 执行完微交互的 cell
    ///   - type: 微交互类型
    ///   - indexPath: 索引路径
    func microInteractionDidEnd(for cell: UITableViewCell, type: HFlowMicroInteractionType, at indexPath: IndexPath) {
        // 默认实现为空
    }
}
