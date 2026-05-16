//
//  HCollView+HapticFeedback.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 触觉反馈扩展
///
/// 为HCollView添加触觉反馈功能，增强用户体验
extension HCollView {
    
    /// 触觉反馈类型
    enum HapticFeedbackType {
        case light          // 轻微触觉反馈
        case medium         // 中等触觉反馈
        case heavy          // 重度触觉反馈
        case success        // 成功触觉反馈
        case warning        // 警告触觉反馈
        case error          // 错误触觉反馈
        case selection      // 选择触觉反馈
    }
    
    /// 触觉反馈管理器
    class HapticFeedbackManager {
        
        // MARK: - 单例
        static let shared = HapticFeedbackManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 触觉反馈生成器
        private var lightGenerator: UIImpactFeedbackGenerator?
        private var mediumGenerator: UIImpactFeedbackGenerator?
        private var heavyGenerator: UIImpactFeedbackGenerator?
        private var notificationGenerator: UINotificationFeedbackGenerator?
        private var selectionGenerator: UISelectionFeedbackGenerator?
        
        // MARK: - 方法
        
        /// 初始化触觉反馈生成器
        private func initializeGenerators() {
            if lightGenerator == nil {
                lightGenerator = UIImpactFeedbackGenerator(style: .light)
                lightGenerator?.prepare()
            }
            
            if mediumGenerator == nil {
                mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
                mediumGenerator?.prepare()
            }
            
            if heavyGenerator == nil {
                heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
                heavyGenerator?.prepare()
            }
            
            if notificationGenerator == nil {
                notificationGenerator = UINotificationFeedbackGenerator()
                notificationGenerator?.prepare()
            }
            
            if selectionGenerator == nil {
                selectionGenerator = UISelectionFeedbackGenerator()
                selectionGenerator?.prepare()
            }
        }
        
        /// 触发触觉反馈
        /// - Parameter type: 触觉反馈类型
        func triggerFeedback(_ type: HapticFeedbackType) {
            // 检查设备是否支持触觉反馈
            guard UIDevice.current.hasHapticFeedback else { return }
            
            // 初始化生成器
            initializeGenerators()
            
            // 触发相应的触觉反馈
            switch type {
            case .light:
                lightGenerator?.impactOccurred()
                lightGenerator?.prepare()
            case .medium:
                mediumGenerator?.impactOccurred()
                mediumGenerator?.prepare()
            case .heavy:
                heavyGenerator?.impactOccurred()
                heavyGenerator?.prepare()
            case .success:
                notificationGenerator?.notificationOccurred(.success)
                notificationGenerator?.prepare()
            case .warning:
                notificationGenerator?.notificationOccurred(.warning)
                notificationGenerator?.prepare()
            case .error:
                notificationGenerator?.notificationOccurred(.error)
                notificationGenerator?.prepare()
            case .selection:
                selectionGenerator?.selectionChanged()
                selectionGenerator?.prepare()
            }
        }
        
        /// 准备触觉反馈
        func prepareFeedback() {
            // 检查设备是否支持触觉反馈
            guard UIDevice.current.hasHapticFeedback else { return }
            
            // 初始化并准备生成器
            initializeGenerators()
        }
    }
    
    /// 触觉反馈管理器
    var hapticFeedbackManager: HapticFeedbackManager {
        return HapticFeedbackManager.shared
    }
    
    /// 触发触觉反馈
    /// - Parameter type: 触觉反馈类型
    func triggerHapticFeedback(_ type: HapticFeedbackType) {
        hapticFeedbackManager.triggerFeedback(type)
    }
    
    /// 准备触觉反馈
    func prepareHapticFeedback() {
        hapticFeedbackManager.prepareFeedback()
    }
    
    /// 启用触觉反馈
    func enableHapticFeedback() {
        // 准备触觉反馈
        prepareHapticFeedback()
        
        // 为各种操作添加触觉反馈
        addHapticFeedbackForActions()
    }
    
    /// 为各种操作添加触觉反馈
    private func addHapticFeedbackForActions() {
        // 这里可以为各种操作添加触觉反馈
        // 例如：下拉刷新、加载更多、点击cell等
    }
}

/// UIDevice 扩展，用于检查设备是否支持触觉反馈
extension UIDevice {
    /// 是否支持触觉反馈
    var hasHapticFeedback: Bool {
        if #available(iOS 10.0, *) {
            return true
        } else {
            return false
        }
    }
}
