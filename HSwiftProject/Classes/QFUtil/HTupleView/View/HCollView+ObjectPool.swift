//
//  HCollView+ObjectPool.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// 对象池协议
protocol ReusableObject {
    /// 重置对象状态
    func reset()
}

/// HCollView 对象池扩展
///
/// 实现对象池，复用频繁创建的对象
extension HCollView {
    
    /// 对象池
    class ObjectPool<T: ReusableObject> {
        
        // MARK: - 属性
        
        /// 对象池
        private var pool: [T] = []
        
        /// 最大池大小
        private let maxPoolSize: Int
        
        /// 对象创建闭包
        private let objectCreator: () -> T
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameters:
        ///   - maxPoolSize: 最大池大小
        ///   - objectCreator: 对象创建闭包
        init(maxPoolSize: Int, objectCreator: @escaping () -> T) {
            self.maxPoolSize = maxPoolSize
            self.objectCreator = objectCreator
        }
        
        // MARK: - 方法
        
        /// 获取对象
        /// - Returns: 对象
        func getObject() -> T {
            if pool.isEmpty {
                return objectCreator()
            } else {
                return pool.removeLast()
            }
        }
        
        /// 回收对象
        /// - Parameter object: 要回收的对象
        func returnObject(_ object: T) {
            if pool.count < maxPoolSize {
                object.reset()
                pool.append(object)
            }
        }
        
        /// 清空对象池
        func clear() {
            pool.removeAll()
        }
        
        /// 获取池大小
        /// - Returns: 池大小
        func poolSize() -> Int {
            return pool.count
        }
    }
    
    /// 对象池管理器
    class ObjectPoolManager {
        
        // MARK: - 单例
        static let shared = ObjectPoolManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 对象池映射
        private var pools: [String: Any] = [:]
        
        // MARK: - 方法
        
        /// 获取对象池
        /// - Parameters:
        ///   - key: 池键
        ///   - maxPoolSize: 最大池大小
        ///   - objectCreator: 对象创建闭包
        /// - Returns: 对象池
        func getPool<T: ReusableObject>(key: String, maxPoolSize: Int, objectCreator: @escaping () -> T) -> ObjectPool<T> {
            if let pool = pools[key] as? ObjectPool<T> {
                return pool
            } else {
                let pool = ObjectPool<T>(maxPoolSize: maxPoolSize, objectCreator: objectCreator)
                pools[key] = pool
                return pool
            }
        }
        
        /// 清空指定对象池
        /// - Parameter key: 池键
        func clearPool(_ key: String) {
            if let pool = pools[key] as? any ObjectPoolProtocol {
                pool.clear()
            }
            pools.removeValue(forKey: key)
        }
        
        /// 清空所有对象池
        func clearAllPools() {
            for (key, pool) in pools {
                if let pool = pool as? any ObjectPoolProtocol {
                    pool.clear()
                }
            }
            pools.removeAll()
        }
        
        /// 获取所有对象池状态
        /// - Returns: 对象池状态
        func getPoolsStatus() -> [String: Int] {
            var status: [String: Int] = [:]
            for (key, pool) in pools {
                if let pool = pool as? any ObjectPoolProtocol {
                    status[key] = pool.poolSize()
                }
            }
            return status
        }
    }
    
    /// 对象池协议
    protocol ObjectPoolProtocol {
        /// 清空对象池
        func clear()
        /// 获取池大小
        func poolSize() -> Int
    }
    
    /// 为 ObjectPool 实现 ObjectPoolProtocol
    extension ObjectPool: ObjectPoolProtocol {
        func clear() {
            clear()
        }
        
        func poolSize() -> Int {
            return poolSize()
        }
    }
    
    /// 对象池管理器
    var objectPoolManager: ObjectPoolManager {
        return ObjectPoolManager.shared
    }
    
    /// 获取对象池
    /// - Parameters:
    ///   - key: 池键
    ///   - maxPoolSize: 最大池大小
    ///   - objectCreator: 对象创建闭包
    /// - Returns: 对象池
    func getObjectPool<T: ReusableObject>(key: String, maxPoolSize: Int, objectCreator: @escaping () -> T) -> ObjectPool<T> {
        return objectPoolManager.getPool(key: key, maxPoolSize: maxPoolSize, objectCreator: objectCreator)
    }
    
    /// 清空对象池
    /// - Parameter key: 池键
    func clearObjectPool(_ key: String) {
        objectPoolManager.clearPool(key)
    }
    
    /// 清空所有对象池
    func clearAllObjectPools() {
        objectPoolManager.clearAllPools()
    }
    
    /// 获取对象池状态
    /// - Returns: 对象池状态
    func getObjectPoolsStatus() -> [String: Int] {
        return objectPoolManager.getPoolsStatus()
    }
}

// MARK: - 示例：为 UILabel 实现 ReusableObject 协议
extension UILabel: ReusableObject {
    func reset() {
        text = nil
        textColor = .black
        font = UIFont.systemFont(ofSize: 17)
        textAlignment = .left
        numberOfLines = 1
    }
}

// MARK: - 示例：为 UIButton 实现 ReusableObject 协议
extension UIButton: ReusableObject {
    func reset() {
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)
        backgroundColor = nil
        titleLabel?.text = nil
    }
}
