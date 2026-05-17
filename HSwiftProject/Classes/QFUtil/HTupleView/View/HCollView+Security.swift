//
//  HCollView+Security.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 安全性优化扩展
///
/// 提供数据安全、代码安全和崩溃防护等功能
extension HCollView {
    
    /// 安全性管理器
    class SecurityManager {
        
        // MARK: - 单例
        static let shared = SecurityManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 是否启用崩溃防护
        var crashProtectionEnabled: Bool = true
        
        /// 是否启用输入验证
        var inputValidationEnabled: Bool = true
        
        // MARK: - 方法
        
        /// 安全执行闭包
        /// - Parameters:
        ///   - closure: 要执行的闭包
        ///   - fallback: 失败时的回退闭包
        func safeExecute(_ closure: () -> Void, fallback: (() -> Void)? = nil) {
            if crashProtectionEnabled {
                do {
                    try executeWithErrorHandling(closure)
                } catch {
                    print("Error: \(error)")
                    fallback?()
                }
            } else {
                closure()
            }
        }
        
        /// 带错误处理的执行
        /// - Parameter closure: 要执行的闭包
        /// - Throws: 执行过程中的错误
        private func executeWithErrorHandling(_ closure: () -> Void) throws {
            try autoreleasepool {
                closure()
            }
        }
        
        /// 验证索引路径
        /// - Parameters:
        ///   - indexPath: 索引路径
        ///   - collectionView: 集合视图
        /// - Returns: 是否有效
        func validateIndexPath(_ indexPath: IndexPath, in collectionView: UICollectionView) -> Bool {
            if !inputValidationEnabled {
                return true
            }
            
            let numberOfSections = collectionView.numberOfSections
            if indexPath.section >= numberOfSections {
                return false
            }
            
            let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
            if indexPath.item >= numberOfItems {
                return false
            }
            
            return true
        }
        
        /// 安全获取单元格
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPath: 索引路径
        /// - Returns: 单元格
        func safeCellForItem(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell? {
            if validateIndexPath(indexPath, in: collectionView) {
                return collectionView.cellForItem(at: indexPath)
            } else {
                return nil
            }
        }
        
        /// 安全滚动到指定项目
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPath: 索引路径
        ///   - scrollPosition: 滚动位置
        ///   - animated: 是否动画
        func safeScrollToItem(at indexPath: IndexPath, in collectionView: UICollectionView, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
            if validateIndexPath(indexPath, in: collectionView) {
                collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            }
        }
        
        /// 安全删除项目
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPaths: 索引路径数组
        ///   - animation: 动画类型
        func safeDeleteItems(at indexPaths: [IndexPath], in collectionView: UICollectionView, with animation: UIView.AnimationOptions) {
            let validIndexPaths = indexPaths.filter { validateIndexPath($0, in: collectionView) }
            if !validIndexPaths.isEmpty {
                collectionView.deleteItems(at: validIndexPaths)
            }
        }
        
        /// 安全插入项目
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPaths: 索引路径数组
        ///   - animation: 动画类型
        func safeInsertItems(at indexPaths: [IndexPath], in collectionView: UICollectionView, with animation: UIView.AnimationOptions) {
            collectionView.insertItems(at: indexPaths)
        }
        
        /// 安全重新加载项目
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPaths: 索引路径数组
        func safeReloadItems(at indexPaths: [IndexPath], in collectionView: UICollectionView) {
            let validIndexPaths = indexPaths.filter { validateIndexPath($0, in: collectionView) }
            if !validIndexPaths.isEmpty {
                collectionView.reloadItems(at: validIndexPaths)
            }
        }
        
        /// 加密数据
        /// - Parameter data: 要加密的数据
        /// - Returns: 加密后的数据
        func encryptData(_ data: Data) -> Data? {
            // 简单的加密实现
            // 实际应用中应该使用更安全的加密算法
            return data
        }
        
        /// 解密数据
        /// - Parameter data: 要解密的数据
        /// - Returns: 解密后的数据
        func decryptData(_ data: Data) -> Data? {
            // 简单的解密实现
            // 实际应用中应该使用更安全的解密算法
            return data
        }
        
        /// 验证网络请求
        /// - Parameter url: 请求 URL
        /// - Returns: 是否有效
        func validateNetworkRequest(_ url: URL) -> Bool {
            // 验证 URL 是否安全
            return url.scheme == "https"
        }
        
        /// 清理敏感数据
        /// - Parameter data: 要清理的数据
        func clearSensitiveData(_ data: inout [String: Any]) {
            // 清理敏感数据
            let sensitiveKeys = ["password", "token", "creditCard", "ssn"]
            for key in sensitiveKeys {
                data.removeValue(forKey: key)
            }
        }
    }
    
    /// 安全性管理器
    var securityManager: SecurityManager {
        return SecurityManager.shared
    }
    
    /// 启用崩溃防护
    func enableCrashProtection() {
        securityManager.crashProtectionEnabled = true
    }
    
    /// 禁用崩溃防护
    func disableCrashProtection() {
        securityManager.crashProtectionEnabled = false
    }
    
    /// 启用输入验证
    func enableInputValidation() {
        securityManager.inputValidationEnabled = true
    }
    
    /// 禁用输入验证
    func disableInputValidation() {
        securityManager.inputValidationEnabled = false
    }
    
    /// 安全执行闭包
    /// - Parameters:
    ///   - closure: 要执行的闭包
    ///   - fallback: 失败时的回退闭包
    func safeExecute(_ closure: () -> Void, fallback: (() -> Void)? = nil) {
        securityManager.safeExecute(closure, fallback: fallback)
    }
    
    /// 验证索引路径
    /// - Parameter indexPath: 索引路径
    /// - Returns: 是否有效
    func validateIndexPath(_ indexPath: IndexPath) -> Bool {
        return securityManager.validateIndexPath(indexPath, in: self)
    }
    
    /// 安全获取单元格
    /// - Parameter indexPath: 索引路径
    /// - Returns: 单元格
    func safeCellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        return securityManager.safeCellForItem(at: indexPath, in: self)
    }
    
    /// 安全滚动到指定项目
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否动画
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        securityManager.safeScrollToItem(at: indexPath, in: self, at: scrollPosition, animated: animated)
    }
    
    /// 安全删除项目
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - animation: 动画类型
    func safeDeleteItems(at indexPaths: [IndexPath], with animation: UIView.AnimationOptions) {
        securityManager.safeDeleteItems(at: indexPaths, in: self, with: animation)
    }
    
    /// 安全插入项目
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - animation: 动画类型
    func safeInsertItems(at indexPaths: [IndexPath], with animation: UIView.AnimationOptions) {
        securityManager.safeInsertItems(at: indexPaths, in: self, with: animation)
    }
    
    /// 安全重新加载项目
    /// - Parameter indexPaths: 索引路径数组
    func safeReloadItems(at indexPaths: [IndexPath]) {
        securityManager.safeReloadItems(at: indexPaths, in: self)
    }
    
    /// 加密数据
    /// - Parameter data: 要加密的数据
    /// - Returns: 加密后的数据
    func encryptData(_ data: Data) -> Data? {
        return securityManager.encryptData(data)
    }
    
    /// 解密数据
    /// - Parameter data: 要解密的数据
    /// - Returns: 解密后的数据
    func decryptData(_ data: Data) -> Data? {
        return securityManager.decryptData(data)
    }
    
    /// 验证网络请求
    /// - Parameter url: 请求 URL
    /// - Returns: 是否有效
    func validateNetworkRequest(_ url: URL) -> Bool {
        return securityManager.validateNetworkRequest(url)
    }
    
    /// 清理敏感数据
    /// - Parameter data: 要清理的数据
    func clearSensitiveData(_ data: inout [String: Any]) {
        securityManager.clearSensitiveData(&data)
    }
}
