//
//  HFlowView+HapticFeedback.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import CoreHaptics

/// 触觉反馈类型枚举
enum HFlowHapticFeedbackType {
    case light          // 轻微触觉反馈
    case medium         // 中等触觉反馈
    case heavy          // 重度触觉反馈
    case success        // 成功触觉反馈
    case warning        // 警告触觉反馈
    case error          // 错误触觉反馈
    case selection      // 选择触觉反馈
    case impact         // 碰撞触觉反馈
    case notification   // 通知触觉反馈
}

/// 触觉反馈配置结构体
struct HFlowHapticFeedbackConfig {
    /// 触觉反馈类型
    var type: HFlowHapticFeedbackType
    /// 是否启用触觉反馈
    var enabled: Bool
    
    /// 默认配置
    static let `default` = HFlowHapticFeedbackConfig(
        type: .light,
        enabled: true
    )
}

/// HFlowView 触觉反馈扩展
///
/// 为 HFlowView 提供触觉反馈功能，增强用户交互体验
///
/// 实现功能：
/// 1. 支持多种触觉反馈类型
/// 2. 响应不同的用户操作
/// 3. 适配不同设备的触觉反馈能力
/// 4. 提供自定义触觉反馈配置

// 关联对象的键
private var hapticEngineKey: UInt8 = 0
private var hapticFeedbackConfigKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Haptic Feedback Properties
    
    /// 触觉反馈引擎
    private var hapticEngine: CHHapticEngine? {
        get {
            return objc_getAssociatedObject(self, &hapticEngineKey) as? CHHapticEngine
        }
        set {
            objc_setAssociatedObject(self, &hapticEngineKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 触觉反馈配置
    public var hapticFeedbackConfig: HFlowHapticFeedbackConfig {
        get {
            if let config = objc_getAssociatedObject(self, &hapticFeedbackConfigKey) as? HFlowHapticFeedbackConfig {
                return config
            } else {
                let config = HFlowHapticFeedbackConfig.default
                objc_setAssociatedObject(self, &hapticFeedbackConfigKey, config, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return config
            }
        }
        set {
            objc_setAssociatedObject(self, &hapticFeedbackConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 是否支持触觉反馈
    public var isHapticFeedbackSupported: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    // MARK: - Haptic Feedback Methods
    
    /// 初始化触觉反馈
    func setupHapticFeedback() {
        guard isHapticFeedbackSupported else { return }
        
        do {
            // 创建触觉反馈引擎
            hapticEngine = try CHHapticEngine()
            
            // 启动引擎
            try hapticEngine?.start()
            
            // 设置引擎停止处理
            hapticEngine?.stoppedHandler = { [weak self] reason in
                print("Haptic engine stopped: \(reason)")
                // 尝试重新启动引擎
                try? self?.hapticEngine?.start()
            }
            
            // 设置引擎重置处理
            hapticEngine?.resetHandler = { [weak self] in
                print("Haptic engine reset")
                try? self?.hapticEngine?.start()
            }
        } catch {
            print("Failed to create haptic engine: \(error)")
        }
    }
    
    /// 触发触觉反馈
    /// - Parameters:
    ///   - type: 触觉反馈类型
    ///   - intensity: 强度（0.0-1.0）
    ///   - sharpness: 锐度（0.0-1.0）
    func triggerHapticFeedback(type: HFlowHapticFeedbackType, intensity: Float = 1.0, sharpness: Float = 1.0) {
        guard hapticFeedbackConfig.enabled, isHapticFeedbackSupported else { return }
        
        switch type {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        case .impact, .notification:
            // 使用 Core Haptics 创建自定义触觉反馈
            createCustomHapticFeedback(intensity: intensity, sharpness: sharpness)
        }
    }
    
    /// 创建自定义触觉反馈
    /// - Parameters:
    ///   - intensity: 强度（0.0-1.0）
    ///   - sharpness: 锐度（0.0-1.0）
    private func createCustomHapticFeedback(intensity: Float, sharpness: Float) {
        guard let hapticEngine = hapticEngine else { return }
        
        do {
            // 创建触觉反馈模式
            let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
            let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            
            // 创建触觉事件
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensityParameter, sharpnessParameter],
                relativeTime: 0
            )
            
            // 创建触觉模式
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            
            // 创建触觉播放器
            let player = try hapticEngine.makePlayer(with: pattern)
            
            // 播放触觉反馈
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to create custom haptic feedback: \(error)")
        }
    }
    
    /// 为 cell 选择触发触觉反馈
    /// - Parameter indexPath: 索引路径
    func triggerHapticFeedbackForCellSelection(at indexPath: IndexPath) {
        triggerHapticFeedback(type: .light)
    }
    
    /// 为下拉刷新触发触觉反馈
    func triggerHapticFeedbackForRefresh() {
        triggerHapticFeedback(type: .medium)
    }
    
    /// 为加载更多触发触觉反馈
    func triggerHapticFeedbackForLoadMore() {
        triggerHapticFeedback(type: .light)
    }
    
    /// 为数据加载完成触发触觉反馈
    func triggerHapticFeedbackForDataLoaded() {
        triggerHapticFeedback(type: .success)
    }
    
    /// 为错误触发触觉反馈
    func triggerHapticFeedbackForError() {
        triggerHapticFeedback(type: .error)
    }
    
    /// 为警告触发触觉反馈
    func triggerHapticFeedbackForWarning() {
        triggerHapticFeedback(type: .warning)
    }
}

/// 扩展 HFlowViewDelegate，添加触觉反馈相关方法
extension HFlowViewDelegate {
    /// 获取指定操作的触觉反馈类型
    /// - Parameter action: 操作类型
    /// - Returns: 触觉反馈类型
    func hapticFeedbackTypeForAction(_ action: String) -> HFlowHapticFeedbackType {
        return .light
    }
    
    /// 当触觉反馈触发时调用
    /// - Parameters:
    ///   - type: 触觉反馈类型
    ///   - intensity: 强度
    ///   - sharpness: 锐度
    func hapticFeedbackDidTrigger(type: HFlowHapticFeedbackType, intensity: Float, sharpness: Float) {
        // 默认实现为空
    }
}
