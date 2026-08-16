//
//  HCollView+LRU.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//
//  有容量上限的最近使用缓存。给图片尺寸等可淘汰数据用，不要拿来存 cell。
//

import Foundation

/// 容量有限的最近使用缓存，get / set / remove 均为 O(1)。
/// 给图片尺寸这类可淘汰的数据用；cell 复用表不能用它（还在屏上的 cell 不能被挤掉）。
final class HCollLRUCache<Key: Hashable, Value> {
    private final class Node {
        let key: Key
        var value: Value
        var prev: Node?
        var next: Node?
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }

    private let capacity: Int
    private var map: [Key: Node] = [:]
    private var head: Node?
    private var tail: Node?

    init(capacity: Int) {
        self.capacity = max(capacity, 1)
    }

    func get(_ key: Key) -> Value? {
        guard let node = map[key] else { return nil }
        moveToHead(node)
        return node.value
    }

    func set(_ value: Value, for key: Key) {
        if let node = map[key] {
            node.value = value
            moveToHead(node)
            return
        }
        let node = Node(key: key, value: value)
        addToHead(node)
        map[key] = node
        if map.count > capacity, let evicted = removeTail() {
            map.removeValue(forKey: evicted.key)
        }
    }

    func remove(_ key: Key) {
        guard let node = map[key] else { return }
        removeNode(node)
        map.removeValue(forKey: key)
    }

    func removeAll() {
        map.removeAll()
        head = nil
        tail = nil
    }

    var count: Int { map.count }
    var isEmpty: Bool { map.isEmpty }

    private func moveToHead(_ node: Node) {
        guard node !== head else { return }
        removeNode(node)
        addToHead(node)
    }

    private func addToHead(_ node: Node) {
        node.prev = nil
        node.next = head
        head?.prev = node
        head = node
        if tail == nil { tail = node }
    }

    private func removeNode(_ node: Node) {
        if let prev = node.prev {
            prev.next = node.next
        } else {
            head = node.next
        }
        if let next = node.next {
            next.prev = node.prev
        } else {
            tail = node.prev
        }
        node.prev = nil
        node.next = nil
    }

    private func removeTail() -> Node? {
        guard let tailNode = tail else { return nil }
        removeNode(tailNode)
        return tailNode
    }
}
