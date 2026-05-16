//
//  HCollView+LRU.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 双向链表节点
class HCollLRUNode<Key: Hashable, Value> {
    let key: Key
    var value: Value
    var prev: HCollLRUNode?
    var next: HCollLRUNode?
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}

/// LRU 缓存实现
///
/// 优先淘汰最久未使用的项，以保持缓存的大小在合理范围内
/// 使用双向链表和哈希表的组合实现，确保所有操作的时间复杂度为 O(1)
class HCollLRUCache<Key: Hashable, Value> {
    private var capacity: Int
    internal var cache: [Key: HCollLRUNode<Key, Value>]
    private var head: HCollLRUNode<Key, Value>? // 最近使用的节点
    private var tail: HCollLRUNode<Key, Value>? // 最久未使用的节点
    
    /// 初始化 LRU 缓存
    /// - Parameter capacity: 缓存容量
    init(capacity: Int) {
        self.capacity = max(capacity, 1)
        self.cache = [:]
    }
    
    /// 获取缓存值
    /// - Parameter key: 缓存键
    /// - Returns: 缓存值，如果不存在则返回 nil
    func get(_ key: Key) -> Value? {
        guard let node = cache[key] else { return nil }
        
        // 更新节点位置到链表头部（表示最近使用）
        moveToHead(node)
        
        return node.value
    }
    
    /// 设置缓存值
    /// - Parameters:
    ///   - value: 缓存值
    ///   - key: 缓存键
    func set(_ value: Value, for key: Key) {
        // 如果键已存在，更新值并移到链表头部
        if let node = cache[key] {
            node.value = value
            moveToHead(node)
        } else {
            // 创建新节点
            let newNode = HCollLRUNode(key: key, value: value)
            
            // 添加到链表头部
            addToHead(newNode)
            cache[key] = newNode
            
            // 如果缓存已满，移除最久未使用的节点（链表尾部）
            if cache.count > capacity {
                if let tailNode = removeTail() {
                    cache.removeValue(forKey: tailNode.key)
                }
            }
        }
    }
    
    /// 移除缓存值
    /// - Parameter key: 缓存键
    func remove(_ key: Key) {
        if let node = cache[key] {
            removeNode(node)
            cache.removeValue(forKey: key)
        }
    }
    
    /// 移除所有缓存值
    func removeAll() {
        cache.removeAll()
        head = nil
        tail = nil
    }
    
    /// 缓存大小
    var count: Int {
        return cache.count
    }
    
    /// 缓存是否为空
    var isEmpty: Bool {
        return cache.isEmpty
    }
    
    /// 将节点移到链表头部
    private func moveToHead(_ node: HCollLRUNode<Key, Value>) {
        // 如果节点已经是头部，直接返回
        if node === head {
            return
        }
        
        // 从当前位置移除节点
        removeNode(node)
        
        // 添加到头部
        addToHead(node)
    }
    
    /// 将节点添加到链表头部
    private func addToHead(_ node: HCollLRUNode<Key, Value>) {
        // 设置节点的 next 为当前头部
        node.next = head
        
        // 设置当前头部的 prev 为新节点
        head?.prev = node
        
        // 更新头部为新节点
        head = node
        
        // 如果链表为空，设置尾部也为新节点
        if tail == nil {
            tail = node
        }
    }
    
    /// 移除指定节点
    private func removeNode(_ node: HCollLRUNode<Key, Value>) {
        // 更新前一个节点的 next
        if let prev = node.prev {
            prev.next = node.next
        } else {
            // 如果节点是头部，更新头部
            head = node.next
        }
        
        // 更新后一个节点的 prev
        if let next = node.next {
            next.prev = node.prev
        } else {
            // 如果节点是尾部，更新尾部
            tail = node.prev
        }
    }
    
    /// 移除链表尾部节点（最久未使用）
    private func removeTail() -> HCollLRUNode<Key, Value>? {
        guard let tailNode = tail else { return nil }
        
        removeNode(tailNode)
        return tailNode
    }
}
