//
//  HCollView+SmartCache.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 智能缓存扩展
///
/// 根据设备内存状况动态调整缓存策略
extension HCollView {
    
    /// 智能缓存管理器
    class SmartCacheManager {
        
        // MARK: - 内存使用等级
        enum MemoryUsageLevel {
            case low    // 内存使用低
            case medium // 内存使用中等
            case high   // 内存使用高
            case critical // 内存使用严重
        }
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 当前内存使用等级
        private var currentMemoryLevel: MemoryUsageLevel = .low
        
        // MARK: - 初始化
        
        /// 初始化
        init(collectionView: HCollView) {
            self.collectionView = collectionView
            // Listen for system memory warnings; no polling timer needed
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didReceiveMemoryWarning),
                name: UIApplication.didReceiveMemoryWarningNotification,
                object: nil
            )
        }
        
        // MARK: - 方法

        /// 停止内存监控
        func stopMemoryMonitoring() {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        }

        /// 处理内存警告
        @objc private func didReceiveMemoryWarning() {
            currentMemoryLevel = .critical
            adjustCacheStrategy()
        }

        /// 调整缓存策略
        private func adjustCacheStrategy() {
            guard let collectionView = collectionView else { return }

            switch currentMemoryLevel {
            case .critical:
                // Only clear on critical — the memory warning handler already purges caches
                Task { @MainActor in
                    collectionView.handleMemoryWarning()
                }
            case .high:
                // Evict stale weak references but keep live ones
                Task { @MainActor in
                    collectionView.cleanupInvalidWeakReferences()
                }
            case .medium, .low:
                break
            }
        }
        
        /// 获取当前内存使用等级
        func getCurrentMemoryLevel() -> MemoryUsageLevel {
            return currentMemoryLevel
        }
    }
    
    /// 智能缓存管理器
    var smartCacheManager: SmartCacheManager {
        get {
            if let manager = objc_getAssociatedObject(self, &smartCacheManagerKey) as? SmartCacheManager {
                return manager
            } else {
                let manager = SmartCacheManager(collectionView: self)
                objc_setAssociatedObject(self, &smartCacheManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return manager
            }
        }
        set {
            objc_setAssociatedObject(self, &smartCacheManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 启用智能缓存
    func enableSmartCache() {
        // 智能缓存管理器会自动开始内存监控
    }
    
    /// 禁用智能缓存
    func disableSmartCache() {
        smartCacheManager.stopMemoryMonitoring()
    }
    
    /// 获取当前内存使用等级
    /// - Returns: 内存使用等级
    func getCurrentMemoryLevel() -> SmartCacheManager.MemoryUsageLevel {
        return smartCacheManager.getCurrentMemoryLevel()
    }
}

// 关联对象键
private var smartCacheManagerKey: UInt8 = 0
