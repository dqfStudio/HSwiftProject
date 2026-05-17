//
//  HCollView+Stability.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 稳定性扩展
///
/// 提供崩溃防护、错误处理和异常监控等功能
extension HCollView {
    
    /// 稳定性管理器
    class StabilityManager {
        
        // MARK: - 单例
        static let shared = StabilityManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 是否启用崩溃防护
        var crashProtectionEnabled: Bool = true
        
        /// 是否启用错误处理
        var errorHandlingEnabled: Bool = true
        
        /// 是否启用异常监控
        var exceptionMonitoringEnabled: Bool = true
        
        /// 错误日志
        private var errorLogs: [String] = []
        
        /// 异常日志
        private var exceptionLogs: [String] = []
        
        // MARK: - 方法
        
        /// 防护执行
        /// - Parameter block: 要执行的代码块
        /// - Returns: 执行结果
        func safeExecute<T>(_ block: () throws -> T) -> T? {
            if crashProtectionEnabled {
                do {
                    return try block()
                } catch {
                    logError("Safe execute failed: \(error)")
                    return nil
                }
            } else {
                do {
                    return try block()
                } catch {
                    fatalError("Execute failed: \(error)")
                }
            }
        }
        
        /// 防护执行（无返回值）
        /// - Parameter block: 要执行的代码块
        func safeExecute(_ block: () throws -> Void) {
            if crashProtectionEnabled {
                do {
                    try block()
                } catch {
                    logError("Safe execute failed: \(error)")
                }
            } else {
                do {
                    try block()
                } catch {
                    fatalError("Execute failed: \(error)")
                }
            }
        }
        
        /// 处理错误
        /// - Parameters:
        ///   - error: 错误
        ///   - message: 错误信息
        func handleError(_ error: Error, message: String) {
            if errorHandlingEnabled {
                logError("\(message): \(error)")
                // 这里可以添加错误处理逻辑，例如显示错误提示
            }
        }
        
        /// 监控异常
        /// - Parameter block: 要监控的代码块
        func monitorException(_ block: () -> Void) {
            if exceptionMonitoringEnabled {
                do {
                    block()
                } catch {
                    logException("Exception occurred: \(error)")
                }
            } else {
                block()
            }
        }
        
        /// 记录错误
        /// - Parameter message: 错误信息
        private func logError(_ message: String) {
            let log = "\(Date()): \(message)"
            errorLogs.append(log)
            print("[HCollView Error] \(log)")
        }
        
        /// 记录异常
        /// - Parameter message: 异常信息
        private func logException(_ message: String) {
            let log = "\(Date()): \(message)"
            exceptionLogs.append(log)
            print("[HCollView Exception] \(log)")
        }
        
        /// 获取错误日志
        /// - Returns: 错误日志
        func getErrorLogs() -> [String] {
            return errorLogs
        }
        
        /// 获取异常日志
        /// - Returns: 异常日志
        func getExceptionLogs() -> [String] {
            return exceptionLogs
        }
        
        /// 清除错误日志
        func clearErrorLogs() {
            errorLogs.removeAll()
        }
        
        /// 清除异常日志
        func clearExceptionLogs() {
            exceptionLogs.removeAll()
        }
        
        /// 清除所有日志
        func clearAllLogs() {
            clearErrorLogs()
            clearExceptionLogs()
        }
        
        /// 启用崩溃防护
        func enableCrashProtection() {
            crashProtectionEnabled = true
        }
        
        /// 禁用崩溃防护
        func disableCrashProtection() {
            crashProtectionEnabled = false
        }
        
        /// 启用错误处理
        func enableErrorHandling() {
            errorHandlingEnabled = true
        }
        
        /// 禁用错误处理
        func disableErrorHandling() {
            errorHandlingEnabled = false
        }
        
        /// 启用异常监控
        func enableExceptionMonitoring() {
            exceptionMonitoringEnabled = true
        }
        
        /// 禁用异常监控
        func disableExceptionMonitoring() {
            exceptionMonitoringEnabled = false
        }
    }
    
    /// 稳定性管理器
    var stabilityManager: StabilityManager {
        return StabilityManager.shared
    }
    
    /// 防护执行
    /// - Parameter block: 要执行的代码块
    /// - Returns: 执行结果
    func safeExecute<T>(_ block: () throws -> T) -> T? {
        return stabilityManager.safeExecute(block)
    }
    
    /// 防护执行（无返回值）
    /// - Parameter block: 要执行的代码块
    func safeExecute(_ block: () throws -> Void) {
        stabilityManager.safeExecute(block)
    }
    
    /// 处理错误
    /// - Parameters:
    ///   - error: 错误
    ///   - message: 错误信息
    func handleError(_ error: Error, message: String) {
        stabilityManager.handleError(error, message: message)
    }
    
    /// 监控异常
    /// - Parameter block: 要监控的代码块
    func monitorException(_ block: () -> Void) {
        stabilityManager.monitorException(block)
    }
    
    /// 获取错误日志
    /// - Returns: 错误日志
    func getErrorLogs() -> [String] {
        return stabilityManager.getErrorLogs()
    }
    
    /// 获取异常日志
    /// - Returns: 异常日志
    func getExceptionLogs() -> [String] {
        return stabilityManager.getExceptionLogs()
    }
    
    /// 清除错误日志
    func clearErrorLogs() {
        stabilityManager.clearErrorLogs()
    }
    
    /// 清除异常日志
    func clearExceptionLogs() {
        stabilityManager.clearExceptionLogs()
    }
    
    /// 清除所有日志
    func clearAllLogs() {
        stabilityManager.clearAllLogs()
    }
    
    /// 启用错误处理
    func enableErrorHandling() {
        stabilityManager.enableErrorHandling()
    }
    
    /// 禁用错误处理
    func disableErrorHandling() {
        stabilityManager.disableErrorHandling()
    }
    
    /// 启用异常监控
    func enableExceptionMonitoring() {
        stabilityManager.enableExceptionMonitoring()
    }
    
    /// 禁用异常监控
    func disableExceptionMonitoring() {
        stabilityManager.disableExceptionMonitoring()
    }
    
    /// 重载数据（带崩溃防护）
    /// 注意：reloadData 由 HCollView+Reload.swift 提供带清理功能的 override
    /// - Warning: 这里的 reloadData override 已被移除，因多个 extension 不能重复 override 同一方法
    
    /// 重载部分数据（带崩溃防护）
    /// - Parameters:
    ///   - indexPaths: 要重载的索引路径
    override func reloadItems(at indexPaths: [IndexPath]) {
        safeExecute {
            super.reloadItems(at: indexPaths)
        }
    }
    
    /// 插入项目（带崩溃防护）
    /// - Parameters:
    ///   - indexPaths: 要插入的索引路径
    override func insertItems(at indexPaths: [IndexPath]) {
        safeExecute {
            super.insertItems(at: indexPaths)
        }
    }
    
    /// 删除项目（带崩溃防护）
    /// - Parameters:
    ///   - indexPaths: 要删除的索引路径
    override func deleteItems(at indexPaths: [IndexPath]) {
        safeExecute {
            super.deleteItems(at: indexPaths)
        }
    }
    
    /// 移动项目（带崩溃防护）
    /// - Parameters:
    ///   - indexPath: 源索引路径
    ///   - newIndexPath: 目标索引路径
    override func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        safeExecute {
            super.moveItem(at: indexPath, to: newIndexPath)
        }
    }
    
    /// 批量更新（带崩溃防护）
    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        safeExecute {
            super.performBatchUpdates(updates, completion: completion)
        }
    }
}
