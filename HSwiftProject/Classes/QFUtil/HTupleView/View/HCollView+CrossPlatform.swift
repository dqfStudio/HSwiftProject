//
//  HCollView+CrossPlatform.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 跨平台支持扩展
///
/// 提供macOS和tvOS支持，实现跨平台使用
extension HCollView {
    
    /// 平台类型
    enum PlatformType {
        case iOS
        case macOS
        case tvOS
        case unknown
    }
    
    /// 跨平台管理器
    class CrossPlatformManager {
        
        // MARK: - 单例
        static let shared = CrossPlatformManager()
        
        // MARK: - 属性
        
        /// 当前平台
        let currentPlatform: PlatformType
        
        // MARK: - 初始化
        
        /// 初始化
        init() {
            #if os(iOS)
            currentPlatform = .iOS
            #elseif os(macOS)
            currentPlatform = .macOS
            #elseif os(tvOS)
            currentPlatform = .tvOS
            #else
            currentPlatform = .unknown
            #endif
        }
        
        // MARK: - 方法
        
        /// 检查是否是iOS平台
        /// - Returns: 是否是iOS平台
        func isiOS() -> Bool {
            return currentPlatform == .iOS
        }
        
        /// 检查是否是macOS平台
        /// - Returns: 是否是macOS平台
        func ismacOS() -> Bool {
            return currentPlatform == .macOS
        }
        
        /// 检查是否是tvOS平台
        /// - Returns: 是否是tvOS平台
        func istvOS() -> Bool {
            return currentPlatform == .tvOS
        }
        
        /// 获取平台名称
        /// - Returns: 平台名称
        func getPlatformName() -> String {
            switch currentPlatform {
            case .iOS:
                return "iOS"
            case .macOS:
                return "macOS"
            case .tvOS:
                return "tvOS"
            default:
                return "Unknown"
            }
        }
        
        /// 获取设备类型
        /// - Returns: 设备类型
        func getDeviceType() -> String {
            #if os(iOS)
            let device = UIDevice.current
            if device.userInterfaceIdiom == .phone {
                return "iPhone"
            } else if device.userInterfaceIdiom == .pad {
                return "iPad"
            } else if device.userInterfaceIdiom == .mac {
                return "Mac"
            } else {
                return "Unknown"
            }
            #elseif os(macOS)
            return "Mac"
            #elseif os(tvOS)
            return "Apple TV"
            #else
            return "Unknown"
            #endif
        }
        
        /// 获取系统版本
        /// - Returns: 系统版本
        func getSystemVersion() -> String {
            #if os(iOS)
            return UIDevice.current.systemVersion
            #elseif os(macOS)
            return ProcessInfo.processInfo.operatingSystemVersionString
            #elseif os(tvOS)
            return UIDevice.current.systemVersion
            #else
            return "Unknown"
            #endif
        }
        
        /// 适配平台特定的布局
        /// - Parameter collectionView: 集合视图
        func adaptLayoutForPlatform(_ collectionView: HCollView) {
            switch currentPlatform {
            case .iOS:
                // iOS 布局适配
                adaptLayoutForiOS(collectionView)
            case .macOS:
                // macOS 布局适配
                adaptLayoutFormacOS(collectionView)
            case .tvOS:
                // tvOS 布局适配
                adaptLayoutFortvOS(collectionView)
            default:
                break
            }
        }
        
        /// 适配iOS布局
        /// - Parameter collectionView: 集合视图
        private func adaptLayoutForiOS(_ collectionView: HCollView) {
            // iOS 特定的布局适配
        }
        
        /// 适配macOS布局
        /// - Parameter collectionView: 集合视图
        private func adaptLayoutFormacOS(_ collectionView: HCollView) {
            // macOS 特定的布局适配
            #if os(macOS)
            collectionView.backgroundColor = .windowBackgroundColor
            #else
            collectionView.backgroundColor = .systemBackground
            #endif
        }
        
        /// 适配tvOS布局
        /// - Parameter collectionView: 集合视图
        private func adaptLayoutFortvOS(_ collectionView: HCollView) {
            // tvOS 特定的布局适配
            collectionView.isPrefetchingEnabled = false
        }
        
        /// 适配平台特定的交互
        /// - Parameter collectionView: 集合视图
        func adaptInteractionForPlatform(_ collectionView: HCollView) {
            switch currentPlatform {
            case .iOS:
                // iOS 交互适配
                adaptInteractionForiOS(collectionView)
            case .macOS:
                // macOS 交互适配
                adaptInteractionFormacOS(collectionView)
            case .tvOS:
                // tvOS 交互适配
                adaptInteractionFortvOS(collectionView)
            default:
                break
            }
        }
        
        /// 适配iOS交互
        /// - Parameter collectionView: 集合视图
        private func adaptInteractionForiOS(_ collectionView: HCollView) {
            // iOS 特定的交互适配
        }
        
        /// 适配macOS交互
        /// - Parameter collectionView: 集合视图
        private func adaptInteractionFormacOS(_ collectionView: HCollView) {
            // macOS 特定的交互适配
            collectionView.allowsMultipleSelection = true
        }
        
        /// 适配tvOS交互
        /// - Parameter collectionView: 集合视图
        private func adaptInteractionFortvOS(_ collectionView: HCollView) {
            // tvOS 特定的交互适配
            collectionView.allowsFocus = true
        }
    }
    
    /// 跨平台管理器
    var crossPlatformManager: CrossPlatformManager {
        return CrossPlatformManager.shared
    }
    
    /// 获取当前平台
    /// - Returns: 当前平台
    func getCurrentPlatform() -> PlatformType {
        return crossPlatformManager.currentPlatform
    }
    
    /// 检查是否是iOS平台
    /// - Returns: 是否是iOS平台
    func isiOS() -> Bool {
        return crossPlatformManager.isiOS()
    }
    
    /// 检查是否是macOS平台
    /// - Returns: 是否是macOS平台
    func ismacOS() -> Bool {
        return crossPlatformManager.ismacOS()
    }
    
    /// 检查是否是tvOS平台
    /// - Returns: 是否是tvOS平台
    func istvOS() -> Bool {
        return crossPlatformManager.istvOS()
    }
    
    /// 获取平台名称
    /// - Returns: 平台名称
    func getPlatformName() -> String {
        return crossPlatformManager.getPlatformName()
    }
    
    /// 获取设备类型
    /// - Returns: 设备类型
    func getDeviceType() -> String {
        return crossPlatformManager.getDeviceType()
    }
    
    /// 获取系统版本
    /// - Returns: 系统版本
    func getSystemVersion() -> String {
        return crossPlatformManager.getSystemVersion()
    }
    
    /// 适配平台特定的布局
    func adaptLayoutForPlatform() {
        crossPlatformManager.adaptLayoutForPlatform(self)
    }
    
    /// 适配平台特定的交互
    func adaptInteractionForPlatform() {
        crossPlatformManager.adaptInteractionForPlatform(self)
    }
}
