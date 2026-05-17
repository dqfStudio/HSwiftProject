//
//  HCollView+StartupPerformance.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 启动性能优化扩展
///
/// 提供启动时间优化、懒加载优化和预加载策略等功能
extension HCollView {
    
    /// 启动性能管理器
    class StartupPerformanceManager {
        
        // MARK: - 单例
        static let shared = StartupPerformanceManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 启动时间
        private var startupTime: TimeInterval = 0
        
        /// 是否启用懒加载
        var lazyLoadingEnabled: Bool = true
        
        /// 是否启用预加载
        var preloadingEnabled: Bool = true
        
        /// 预加载队列
        private let preloadQueue = DispatchQueue(label: "com.hcollview.preload", qos: .userInitiated, attributes: .concurrent)
        
        /// 懒加载任务
        private var lazyLoadingTasks: [() -> Void] = []
        
        // MARK: - 方法
        
        /// 开始启动计时
        func startStartupTimer() {
            startupTime = CFAbsoluteTimeGetCurrent()
        }
        
        /// 结束启动计时
        /// - Returns: 启动时间（毫秒）
        func endStartupTimer() -> Double {
            let endTime = CFAbsoluteTimeGetCurrent()
            let elapsedTime = (endTime - startupTime) * 1000
            print("HCollView startup time: \(elapsedTime)ms")
            return elapsedTime
        }
        
        /// 注册懒加载任务
        /// - Parameter task: 懒加载任务
        func registerLazyLoadingTask(_ task: @escaping () -> Void) {
            lazyLoadingTasks.append(task)
        }
        
        /// 执行懒加载任务
        func executeLazyLoadingTasks() {
            if lazyLoadingEnabled {
                for task in lazyLoadingTasks {
                    preloadQueue.async {
                        task()
                    }
                }
                lazyLoadingTasks.removeAll()
            }
        }
        
        /// 预加载资源
        /// - Parameters:
        ///   - resources: 要预加载的资源
        ///   - loader: 资源加载闭包
        func preloadResources<T>(_ resources: [T], loader: @escaping (T) -> Void) {
            if preloadingEnabled {
                for resource in resources {
                    preloadQueue.async {
                        loader(resource)
                    }
                }
            }
        }
        
        /// 优化启动性能
        /// - Parameter collectionView: 集合视图
        func optimizeStartupPerformance(for collectionView: HCollView) {
            // 启用懒加载
            enableLazyLoading()
            
            // 启用预加载
            enablePreloading()
            
            // 注册懒加载任务
            registerLazyLoadingTasks(for: collectionView)
        }
        
        /// 注册懒加载任务
        /// - Parameter collectionView: 集合视图
        private func registerLazyLoadingTasks(for collectionView: HCollView) {
            // 注册单元格
            registerLazyLoadingTask {
                // 这里可以注册单元格
            }
            
            // 预加载布局
            registerLazyLoadingTask {
                // 预加载布局 — layoutManager 是 @MainActor 属性
                Task { @MainActor in
                    collectionView.layoutManager.createLayout(.flow)
                }
            }
            
            // 预加载缓存
            registerLazyLoadingTask {
                // 预加载缓存
            }
        }
        
        /// 启用懒加载
        func enableLazyLoading() {
            lazyLoadingEnabled = true
        }
        
        /// 禁用懒加载
        func disableLazyLoading() {
            lazyLoadingEnabled = false
        }
        
        /// 启用预加载
        func enablePreloading() {
            preloadingEnabled = true
        }
        
        /// 禁用预加载
        func disablePreloading() {
            preloadingEnabled = false
        }
        
        /// 清除懒加载任务
        func clearLazyLoadingTasks() {
            lazyLoadingTasks.removeAll()
        }
    }
    
    /// 启动性能管理器
    var startupPerformanceManager: StartupPerformanceManager {
        return StartupPerformanceManager.shared
    }
    
    /// 开始启动计时
    func startStartupTimer() {
        startupPerformanceManager.startStartupTimer()
    }
    
    /// 结束启动计时
    /// - Returns: 启动时间（毫秒）
    func endStartupTimer() -> Double {
        return startupPerformanceManager.endStartupTimer()
    }
    
    /// 注册懒加载任务
    /// - Parameter task: 懒加载任务
    func registerLazyLoadingTask(_ task: @escaping () -> Void) {
        startupPerformanceManager.registerLazyLoadingTask(task)
    }
    
    /// 执行懒加载任务
    func executeLazyLoadingTasks() {
        startupPerformanceManager.executeLazyLoadingTasks()
    }
    
    /// 预加载资源
    /// - Parameters:
    ///   - resources: 要预加载的资源
    ///   - loader: 资源加载闭包
    func preloadResources<T>(_ resources: [T], loader: @escaping (T) -> Void) {
        startupPerformanceManager.preloadResources(resources, loader: loader)
    }
    
    /// 优化启动性能
    func optimizeStartupPerformance() {
        startupPerformanceManager.optimizeStartupPerformance(for: self)
    }
    
    /// 启用懒加载
    func enableLazyLoading() {
        startupPerformanceManager.enableLazyLoading()
    }
    
    /// 禁用懒加载
    func disableLazyLoading() {
        startupPerformanceManager.disableLazyLoading()
    }
    
    /// 启用预加载
    func enablePreloading() {
        startupPerformanceManager.enablePreloading()
    }
    
    /// 禁用预加载
    func disablePreloading() {
        startupPerformanceManager.disablePreloading()
    }
    
    /// 清除懒加载任务
    func clearLazyLoadingTasks() {
        startupPerformanceManager.clearLazyLoadingTasks()
    }
}
