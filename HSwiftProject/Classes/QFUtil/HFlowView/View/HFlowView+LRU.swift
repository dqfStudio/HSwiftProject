//
//  HFlowView+LRU.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - LRU Cache Implementation

/// 弱引用包装器，防止循环引用
///
/// 这个包装器可以安全地持有对任何类实例的弱引用，避免循环引用问题。
/// - Parameter T: 被包装的类类型
internal struct Weak<T: AnyObject> {
    internal weak var value: T?
    
    /// 初始化弱引用包装器
    /// - Parameter value: 被包装的对象
    init(_ value: T) { self.value = value }
}

/// LRU 缓存实现，用于高效管理缓存项
///
/// LRU (Least Recently Used) 缓存是一种常用的缓存策略，它会优先淘汰最久未使用的缓存项。
/// 本实现使用字典存储缓存数据，使用数组记录访问顺序，当缓存容量达到上限时，会自动移除最久未使用的项。
/// - Parameter K: 缓存键的类型，必须是可哈希的
/// - Parameter V: 缓存值的类型
internal class HFlowLRUCache<K: Hashable, V> {
    private let capacity: Int
    private var cache: [K: V]
    private var order: [K]
    
    /// 初始化 LRU 缓存
    /// - Parameter capacity: 缓存容量，必须大于 0
    init(capacity: Int) {
        self.capacity = max(1, capacity)
        self.cache = [:]
        self.order = []
    }
    
    /// 通过下标访问缓存
    /// - Parameter key: 缓存键
    /// - Returns: 缓存值，如果不存在则返回 nil
    subscript(key: K) -> V? {
        get {
            if let value = cache[key] {
                // 更新访问顺序
                if let index = order.firstIndex(of: key) {
                    order.remove(at: index)
                    order.append(key)
                }
                return value
            }
            return nil
        }
        set {
            if let newValue = newValue {
                // 如果键已存在，更新值和访问顺序
                if cache.keys.contains(key) {
                    if let index = order.firstIndex(of: key) {
                        order.remove(at: index)
                    }
                } else if cache.count >= capacity {
                    // 缓存已满，移除最久未使用的项
                    if let oldestKey = order.first {
                        cache.removeValue(forKey: oldestKey)
                        order.removeFirst()
                    }
                }
                // 添加新值
                cache[key] = newValue
                order.append(key)
            } else {
                // 移除值
                if let index = order.firstIndex(of: key) {
                    order.remove(at: index)
                }
                cache.removeValue(forKey: key)
            }
        }
    }
    
    /// 清空缓存
    func removeAll() {
        cache.removeAll()
        order.removeAll()
    }
    
    /// 获取缓存中的项数
    var count: Int {
        return cache.count
    }
    
    /// 获取所有键
    var keys: [K] {
        return Array(cache.keys)
    }
}

// MARK: - Cache Management
///
/// 缓存管理扩展，用于控制 HFlowView 的缓存行为
///
/// 本扩展提供了缓存清理的相关方法，当缓存大小超过阈值时，会自动清理缓存以释放内存。
extension HFlowView {
    
    /// 检查是否需要清理缓存
    ///
    /// 当缓存大小超过阈值时，调用此方法会清理缓存以释放内存。
    internal func checkCacheCleanup() {
        cacheManager.cleanupCache()
    }
}
