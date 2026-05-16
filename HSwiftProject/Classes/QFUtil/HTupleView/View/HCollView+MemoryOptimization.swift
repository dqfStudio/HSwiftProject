//
//  HCollView+MemoryOptimization.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 内存优化扩展
///
/// 提供内存使用监控、内存泄漏检测、对象池优化和缓存策略优化等功能
extension HCollView {
    
    /// 内存优化管理器
    class MemoryOptimizationManager {
        
        // MARK: - 单例
        static let shared = MemoryOptimizationManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 内存使用阈值（MB）
        var memoryUsageThreshold: Double = 100.0
        
        /// 是否启用内存监控
        var memoryMonitoringEnabled: Bool = true
        
        /// 是否启用对象池
        var objectPoolEnabled: Bool = true
        
        /// 内存监控定时器
        private var memoryMonitorTimer: Timer?
        
        /// 对象池
        private var objectPools: [String: Any] = [:]
        
        // MARK: - 方法
        
        /// 开始内存监控
        func startMemoryMonitoring() {
            if memoryMonitoringEnabled {
                memoryMonitorTimer = Timer.scheduledTimer(
                    timeInterval: 5,
                    target: self,
                    selector: #selector(checkMemoryUsage),
                    userInfo: nil,
                    repeats: true
                )
            }
        }
        
        /// 停止内存监控
        func stopMemoryMonitoring() {
            memoryMonitorTimer?.invalidate()
            memoryMonitorTimer = nil
        }
        
        /// 检查内存使用
        @objc private func checkMemoryUsage() {
            let memoryUsage = getCurrentMemoryUsage()
            print("Current memory usage: \(memoryUsage) MB")
            
            if memoryUsage > memoryUsageThreshold {
                // 内存使用超过阈值，清理缓存
                clearMemoryCache()
            }
        }
        
        /// 获取当前内存使用
        /// - Returns: 内存使用（MB）
        func getCurrentMemoryUsage() -> Double {
            var taskInfo = mach_task_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
            let kerr = withUnsafeMutablePointer(to: &taskInfo) { 
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) { 
                    task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
                }
            }
            
            if kerr == KERN_SUCCESS {
                return Double(taskInfo.resident_size) / (1024 * 1024)
            } else {
                return 0
            }
        }
        
        /// 清理内存缓存
        func clearMemoryCache() {
            // 清理图片缓存
            HCollView.ContentDisplayManager.shared.clearImageCache()
            
            // 清理视频缓存
            HCollView.ContentDisplayManager.shared.clearVideoCache()
            
            // 清理布局缓存
            HCollView.LayoutManager.shared.clearLayoutCache()
            
            // 清理对象池
            clearObjectPools()
        }
        
        /// 创建对象池
        /// - Parameters:
        ///   - key: 对象池键
        ///   - creator: 对象创建闭包
        ///   - capacity: 容量
        func createObjectPool<T>(key: String, creator: @escaping () -> T, capacity: Int = 10) {
            if objectPoolEnabled {
                let pool = ObjectPool<T>(creator: creator, capacity: capacity)
                objectPools[key] = pool
            }
        }
        
        /// 获取对象池
        /// - Parameter key: 对象池键
        /// - Returns: 对象池
        func getObjectPool<T>(key: String) -> ObjectPool<T>? {
            return objectPools[key] as? ObjectPool<T>
        }
        /// 从对象池获取对象
        /// - Parameter key: 对象池键
        /// - Returns: 对象
        func getObject<T>(fromPool key: String) -> T? {
            if let pool = getObjectPool(key: key) {
                return pool.getObject()
            }
            return nil
        }
        
        /// 归还对象到对象池
        /// - Parameters:
        ///   - object: 对象
        ///   - key: 对象池键
        func returnObject<T>(_ object: T, toPool key: String) {
            if let pool = getObjectPool(key: key) {
                pool.returnObject(object)
            }
        }
        
        /// 清理对象池
        func clearObjectPools() {
            objectPools.removeAll()
        }
        
        /// 启用内存监控
        func enableMemoryMonitoring() {
            memoryMonitoringEnabled = true
            startMemoryMonitoring()
        }
        
        /// 禁用内存监控
        func disableMemoryMonitoring() {
            memoryMonitoringEnabled = false
            stopMemoryMonitoring()
        }
        
        /// 启用对象池
        func enableObjectPool() {
            objectPoolEnabled = true
        }
        
        /// 禁用对象池
        func disableObjectPool() {
            objectPoolEnabled = false
            clearObjectPools()
        }
        
        /// 设置内存使用阈值
        /// - Parameter threshold: 内存使用阈值（MB）
        func setMemoryUsageThreshold(_ threshold: Double) {
            memoryUsageThreshold = threshold
        }
    }
    
    /// 内存优化管理器
    var memoryOptimizationManager: MemoryOptimizationManager {
        return MemoryOptimizationManager.shared
    }
    
    /// 开始内存监控
    func startMemoryMonitoring() {
        memoryOptimizationManager.startMemoryMonitoring()
    }
    
    /// 停止内存监控
    func stopMemoryMonitoring() {
        memoryOptimizationManager.stopMemoryMonitoring()
    }
    
    /// 获取当前内存使用
    /// - Returns: 内存使用（MB）
    func getCurrentMemoryUsage() -> Double {
        return memoryOptimizationManager.getCurrentMemoryUsage()
    }
    
    /// 清理内存缓存
    func clearMemoryCache() {
        memoryOptimizationManager.clearMemoryCache()
    }
    
    /// 创建对象池
    /// - Parameters:
    ///   - key: 对象池键
    ///   - creator: 对象创建闭包
    ///   - capacity: 容量
    func createObjectPool<T>(key: String, creator: @escaping () -> T, capacity: Int = 10) {
        memoryOptimizationManager.createObjectPool(key: key, creator: creator, capacity: capacity)
    }
    
    /// 从对象池获取对象
    /// - Parameter key: 对象池键
    /// - Returns: 对象
    func getObject<T>(fromPool key: String) -> T? {
        return memoryOptimizationManager.getObject(fromPool: key)
    }
    
    /// 归还对象到对象池
    /// - Parameters:
    ///   - object: 对象
    ///   - key: 对象池键
    func returnObject<T>(_ object: T, toPool key: String) {
        memoryOptimizationManager.returnObject(object, toPool: key)
    }
    
    /// 清理对象池
    func clearObjectPools() {
        memoryOptimizationManager.clearObjectPools()
    }
    
    /// 启用内存监控
    func enableMemoryMonitoring() {
        memoryOptimizationManager.enableMemoryMonitoring()
    }
    
    /// 禁用内存监控
    func disableMemoryMonitoring() {
        memoryOptimizationManager.disableMemoryMonitoring()
    }
    
    /// 启用对象池
    func enableObjectPool() {
        memoryOptimizationManager.enableObjectPool()
    }
    
    /// 禁用对象池
    func disableObjectPool() {
        memoryOptimizationManager.disableObjectPool()
    }
    
    /// 设置内存使用阈值
    /// - Parameter threshold: 内存使用阈值（MB）
    func setMemoryUsageThreshold(_ threshold: Double) {
        memoryOptimizationManager.setMemoryUsageThreshold(threshold)
    }
}

/// 对象池
class ObjectPool<T> {
    
    // MARK: - 属性
    
    /// 对象创建闭包
    private let creator: () -> T
    
    /// 容量
    private let capacity: Int
    
    /// 对象池
    private var pool: [T] = []
    
    /// 访问锁
    private let lock = NSLock()
    
    // MARK: - 初始化
    
    /// 初始化
    /// - Parameters:
    ///   - creator: 对象创建闭包
    ///   - capacity: 容量
    init(creator: @escaping () -> T, capacity: Int = 10) {
        self.creator = creator
        self.capacity = capacity
    }
    
    // MARK: - 方法
    
    /// 获取对象
    /// - Returns: 对象
    func getObject() -> T {
        lock.lock()
        defer { lock.unlock() }
        
        if !pool.isEmpty {
            return pool.removeLast()
        } else {
            return creator()
        }
    }
    
    /// 归还对象
    /// - Parameter object: 对象
    func returnObject(_ object: T) {
        lock.lock()
        defer { lock.unlock() }
        
        if pool.count < capacity {
            pool.append(object)
        }
    }
    
    /// 清理对象池
    func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        pool.removeAll()
    }
    
    /// 获取对象池大小
    /// - Returns: 对象池大小
    func count() -> Int {
        lock.lock()
        defer { lock.unlock() }
        
        return pool.count
    }
}
