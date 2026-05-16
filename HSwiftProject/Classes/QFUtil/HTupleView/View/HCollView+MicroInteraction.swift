//
//  HCollView+MicroInteraction.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 微交互扩展
///
/// 添加更多微交互效果，提升用户体验
extension HCollView {
    
    /// 微交互类型
    enum MicroInteractionType {
        case tap           // 点击效果
        case press         // 按压效果
        case release       // 释放效果
        case scroll        // 滚动效果
        case load          // 加载效果
        case refresh       // 刷新效果
        case empty         // 空状态效果
    }
    
    /// 微交互管理器
    class MicroInteractionManager {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 是否启用微交互
        var isEnabled: Bool = true
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
        }
        
        // MARK: - 方法
        
        /// 触发微交互
        /// - Parameters:
        ///   - type: 微交互类型
        ///   - view: 目标视图
        func triggerInteraction(_ type: MicroInteractionType, on view: UIView) {
            guard isEnabled else { return }
            
            switch type {
            case .tap:
                addTapEffect(to: view)
            case .press:
                addPressEffect(to: view)
            case .release:
                addReleaseEffect(to: view)
            case .scroll:
                addScrollEffect(to: view)
            case .load:
                addLoadEffect(to: view)
            case .refresh:
                addRefreshEffect(to: view)
            case .empty:
                addEmptyEffect(to: view)
            }
        }
        
        /// 添加点击效果
        /// - Parameter view: 目标视图
        private func addTapEffect(to view: UIView) {
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: {
                _ in
                UIView.animate(withDuration: 0.1) {
                    view.transform = .identity
                }
            })
        }
        
        /// 添加按压效果
        /// - Parameter view: 目标视图
        private func addPressEffect(to view: UIView) {
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                view.alpha = 0.7
            }
        }
        
        /// 添加释放效果
        /// - Parameter view: 目标视图
        private func addReleaseEffect(to view: UIView) {
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
                view.alpha = 1.0
            }
        }
        
        /// 添加滚动效果
        /// - Parameter view: 目标视图
        private func addScrollEffect(to view: UIView) {
            // 这里可以添加滚动时的微交互效果
            // 例如：滚动时的渐入渐出效果
        }
        
        /// 添加加载效果
        /// - Parameter view: 目标视图
        private func addLoadEffect(to view: UIView) {
            // 创建加载指示器
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            
            // 2秒后移除
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        
        /// 添加刷新效果
        /// - Parameter view: 目标视图
        private func addRefreshEffect(to view: UIView) {
            // 创建刷新指示器
            let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            refreshView.center = view.center
            view.addSubview(refreshView)
            
            // 添加旋转动画
            let layer = CAShapeLayer()
            let path = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: 15, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            layer.path = path.cgPath
            layer.strokeColor = UIColor.systemBlue.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 3
            layer.strokeEnd = 0.7
            refreshView.layer.addSublayer(layer)
            
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = CGFloat.pi * 2
            animation.duration = 1
            animation.repeatCount = .infinity
            layer.add(animation, forKey: "rotate")
            
            // 2秒后移除
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                refreshView.removeFromSuperview()
            }
        }
        
        /// 添加空状态效果
        /// - Parameter view: 目标视图
        private func addEmptyEffect(to view: UIView) {
            // 创建空状态动画
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            emptyLabel.text = "暂无数据"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            emptyLabel.center = view.center
            view.addSubview(emptyLabel)
            
            // 添加淡入动画
            emptyLabel.alpha = 0
            UIView.animate(withDuration: 0.5) {
                emptyLabel.alpha = 1
            }
        }
        
        /// 添加脉冲效果
        /// - Parameter view: 目标视图
        func addPulseEffect(to view: UIView) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.0
            animation.toValue = 1.05
            animation.duration = 0.3
            animation.autoreverses = true
            animation.repeatCount = 1
            view.layer.add(animation, forKey: "pulse")
        }
        
        /// 添加呼吸效果
        /// - Parameter view: 目标视图
        func addBreathingEffect(to view: UIView) {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1.0
            animation.toValue = 0.7
            animation.duration = 1.0
            animation.autoreverses = true
            animation.repeatCount = .infinity
            view.layer.add(animation, forKey: "breathing")
        }
        
        /// 添加摇摆效果
        /// - Parameter view: 目标视图
        func addShakeEffect(to view: UIView) {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = -0.1
            animation.toValue = 0.1
            animation.duration = 0.1
            animation.autoreverses = true
            animation.repeatCount = 3
            view.layer.add(animation, forKey: "shake")
        }
    }
    
    /// 微交互管理器
    var microInteractionManager: MicroInteractionManager {
        get {
            if let manager = objc_getAssociatedObject(self, &microInteractionManagerKey) as? MicroInteractionManager {
                return manager
            } else {
                let manager = MicroInteractionManager(collectionView: self)
                objc_setAssociatedObject(self, &microInteractionManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &microInteractionManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用微交互
    func enableMicroInteraction() {
        microInteractionManager.isEnabled = true
    }
    
    /// 禁用微交互
    func disableMicroInteraction() {
        microInteractionManager.isEnabled = false
    }
    
    /// 触发微交互
    /// - Parameters:
    ///   - type: 微交互类型
    ///   - view: 目标视图
    func triggerMicroInteraction(_ type: MicroInteractionType, on view: UIView) {
        microInteractionManager.triggerInteraction(type, on: view)
    }
    
    /// 添加脉冲效果
    /// - Parameter view: 目标视图
    func addPulseEffect(to view: UIView) {
        microInteractionManager.addPulseEffect(to: view)
    }
    
    /// 添加呼吸效果
    /// - Parameter view: 目标视图
    func addBreathingEffect(to view: UIView) {
        microInteractionManager.addBreathingEffect(to: view)
    }
    
    /// 添加摇摆效果
    /// - Parameter view: 目标视图
    func addShakeEffect(to view: UIView) {
        microInteractionManager.addShakeEffect(to: view)
    }
}

// 关联对象键
private var microInteractionManagerKey: UInt8 = 0
