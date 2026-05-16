//
//  HCollView+Accessibility.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 可访问性扩展
///
/// 提供完善的无障碍支持，包括VoiceOver、动态字体、高对比度模式和键盘导航等
extension HCollView {
    
    /// 可访问性管理器
    class AccessibilityManager {
        
        // MARK: - 单例
        static let shared = AccessibilityManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 是否启用可访问性
        var isEnabled: Bool = true
        
        /// 是否支持动态字体
        var supportsDynamicType: Bool = true
        
        /// 是否支持高对比度
        var supportsHighContrast: Bool = true
        
        /// 是否支持键盘导航
        var supportsKeyboardNavigation: Bool = true
        
        // MARK: - 方法
        
        /// 配置可访问性
        /// - Parameter view: 目标视图
        func configureAccessibility(for view: UIView) {
            guard isEnabled else { return }
            
            // 启用可访问性
            view.isAccessibilityElement = true
            
            // 配置动态字体
            if supportsDynamicType {
                configureDynamicType(for: view)
            }
            
            // 配置高对比度
            if supportsHighContrast {
                configureHighContrast(for: view)
            }
            
            // 配置键盘导航
            if supportsKeyboardNavigation {
                configureKeyboardNavigation(for: view)
            }
        }
        
        /// 配置动态字体
        /// - Parameter view: 目标视图
        private func configureDynamicType(for view: UIView) {
            if let label = view as? UILabel {
                label.adjustsFontForContentSizeCategory = true
            } else if let button = view as? UIButton {
                button.titleLabel?.adjustsFontForContentSizeCategory = true
            } else if let textField = view as? UITextField {
                textField.adjustsFontForContentSizeCategory = true
            } else if let textView = view as? UITextView {
                textView.adjustsFontForContentSizeCategory = true
            }
            
            // 递归配置子视图
            for subview in view.subviews {
                configureDynamicType(for: subview)
            }
        }
        
        /// 配置高对比度
        /// - Parameter view: 目标视图
        private func configureHighContrast(for view: UIView) {
            // 监听高对比度模式变化
            NotificationCenter.default.addObserver(
                forName: UIAccessibility.highContrastDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateHighContrast(for: view)
            }
            
            // 初始更新
            updateHighContrast(for: view)
        }
        
        /// 更新高对比度
        /// - Parameter view: 目标视图
        private func updateHighContrast(for view: UIView) {
            if UIAccessibility.isHighContrastEnabled {
                // 高对比度模式
                view.backgroundColor = UIColor.white
                
                if let label = view as? UILabel {
                    label.textColor = UIColor.black
                } else if let button = view as? UIButton {
                    button.setTitleColor(UIColor.black, for: .normal)
                }
            }
            
            // 递归更新子视图
            for subview in view.subviews {
                updateHighContrast(for: subview)
            }
        }
        
        /// 配置键盘导航
        /// - Parameter view: 目标视图
        private func configureKeyboardNavigation(for view: UIView) {
            view.isUserInteractionEnabled = true
            view.canBecomeFocused = true
        }
        
        /// 设置可访问性标签
        /// - Parameters:
        ///   - view: 目标视图
        ///   - label: 可访问性标签
        func setAccessibilityLabel(_ label: String, for view: UIView) {
            view.accessibilityLabel = label
        }
        
        /// 设置可访问性提示
        /// - Parameters:
        ///   - view: 目标视图
        ///   - hint: 可访问性提示
        func setAccessibilityHint(_ hint: String, for view: UIView) {
            view.accessibilityHint = hint
        }
        
        /// 设置可访问性值
        /// - Parameters:
        ///   - view: 目标视图
        ///   - value: 可访问性值
        func setAccessibilityValue(_ value: String, for view: UIView) {
            view.accessibilityValue = value
        }
        
        /// 设置可访问性特性
        /// - Parameters:
        ///   - view: 目标视图
        ///   - traits: 可访问性特性
        func setAccessibilityTraits(_ traits: UIAccessibilityTraits, for view: UIView) {
            view.accessibilityTraits = traits
        }
        
        /// 发布可访问性通知
        /// - Parameters:
        ///   - notification: 通知类型
        ///   - argument: 通知参数
        func postAccessibilityNotification(_ notification: UIAccessibility.Notification, argument: Any?) {
            UIAccessibility.post(notification: notification, argument: argument)
        }
    }
    
    /// 可访问性管理器
    var accessibilityManager: AccessibilityManager {
        return AccessibilityManager.shared
    }
    
    /// 启用可访问性
    func enableAccessibility() {
        accessibilityManager.isEnabled = true
        accessibilityManager.configureAccessibility(for: self)
    }
    
    /// 禁用可访问性
    func disableAccessibility() {
        accessibilityManager.isEnabled = false
    }
    
    /// 设置可访问性标签
    /// - Parameter label: 可访问性标签
    func setAccessibilityLabel(_ label: String) {
        accessibilityManager.setAccessibilityLabel(label, for: self)
    }
    
    /// 设置可访问性提示
    /// - Parameter hint: 可访问性提示
    func setAccessibilityHint(_ hint: String) {
        accessibilityManager.setAccessibilityHint(hint, for: self)
    }
    
    /// 设置可访问性值
    /// - Parameter value: 可访问性值
    func setAccessibilityValue(_ value: String) {
        accessibilityManager.setAccessibilityValue(value, for: self)
    }
    
    /// 设置可访问性特性
    /// - Parameter traits: 可访问性特性
    func setAccessibilityTraits(_ traits: UIAccessibilityTraits) {
        accessibilityManager.setAccessibilityTraits(traits, for: self)
    }
    
    /// 发布可访问性通知
    /// - Parameters:
    ///   - notification: 通知类型
    ///   - argument: 通知参数
    func postAccessibilityNotification(_ notification: UIAccessibility.Notification, argument: Any?) {
        accessibilityManager.postAccessibilityNotification(notification, argument: argument)
    }
    
    /// 配置单元格可访问性
    /// - Parameters:
    ///   - cell: 单元格
    ///   - indexPath: 索引路径
    func configureCellAccessibility(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        // 设置可访问性标签
        cell.accessibilityLabel = "Cell \(indexPath.section)-\(indexPath.item)"
        
        // 设置可访问性提示
        cell.accessibilityHint = "点击查看详情"
        
        // 设置可访问性特性
        cell.accessibilityTraits = .button
    }
}
