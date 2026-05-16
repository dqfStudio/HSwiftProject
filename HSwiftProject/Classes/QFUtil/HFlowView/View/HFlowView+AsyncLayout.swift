//
//  HFlowView+AsyncLayout.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// HFlowView 异步布局扩展
///
/// 为 HFlowView 提供异步布局功能，在后台线程计算布局，避免阻塞主线程
///
/// 实现功能：
/// 1. 在后台线程计算 cell 高度
/// 2. 异步布局 cell 内容
/// 3. 批量处理布局计算
/// 4. 缓存布局计算结果

/// 线程安全的高度缓存容器，不绑定 MainActor，支持跨线程访问
final class HFlowLayoutCacheStore: @unchecked Sendable {
    private let lock = NSLock()
    private var cache: [IndexPath: CGFloat] = [:]

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return cache.count
    }

    func value(forKey indexPath: IndexPath) -> CGFloat? {
        lock.lock()
        defer { lock.unlock() }
        return cache[indexPath]
    }

    func setValue(_ value: CGFloat, forKey indexPath: IndexPath) {
        lock.lock()
        defer { lock.unlock() }
        if cache.count > 5000, let oldestKey = cache.keys.first {
            cache.removeValue(forKey: oldestKey)
        }
        cache[indexPath] = value
    }

    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        cache.removeAll()
    }

    func removeValue(forKey indexPath: IndexPath) {
        lock.lock()
        defer { lock.unlock() }
        cache.removeValue(forKey: indexPath)
    }

    func filter(_ isIncluded: (IndexPath) -> Bool) {
        lock.lock()
        defer { lock.unlock() }
        cache = cache.filter { isIncluded($0.key) }
    }
}

// 关联对象的键
private var enableAsyncLayoutKey: UInt8 = 0
private var layoutQueueKey: UInt8 = 0
private var layoutCacheStoreKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Constants
    
    private enum AsyncLayoutConstants {
        /// 布局计算队列的最大并发数
        static let maxConcurrentOperations = 2
        
        /// 批量布局的最大 cell 数量
        static let maxBatchSize = 10
        
        /// 布局计算超时时间（秒）
        static let layoutTimeout: TimeInterval = 1.0
    }
    
    // MARK: - Properties
    
    /// 是否启用异步布局
    public var enableAsyncLayout: Bool {
        get {
            if let enable = objc_getAssociatedObject(self, &enableAsyncLayoutKey) as? Bool {
                return enable
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &enableAsyncLayoutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 布局计算队列
    private var layoutQueue: OperationQueue {
        get {
            if let queue = objc_getAssociatedObject(self, &layoutQueueKey) as? OperationQueue {
                return queue
            }
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = AsyncLayoutConstants.maxConcurrentOperations
            queue.qualityOfService = .userInitiated
            objc_setAssociatedObject(self, &layoutQueueKey, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return queue
        }
    }
    
    /// 线程安全的布局缓存存储
    internal var layoutCacheStore: HFlowLayoutCacheStore {
        if let store = objc_getAssociatedObject(self, &layoutCacheStoreKey) as? HFlowLayoutCacheStore {
            return store
        }
        let store = HFlowLayoutCacheStore()
        objc_setAssociatedObject(self, &layoutCacheStoreKey, store, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return store
    }
    
    // MARK: - Async Layout Methods
    
    /// 异步计算指定 indexPath 的 cell 高度
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - completion: 计算完成回调
    func asyncCalculateCellHeight(for indexPath: IndexPath, completion: @escaping (CGFloat) -> Void) {
        guard enableAsyncLayout else {
            let height = tableView(self, heightForRowAt: indexPath)
            completion(height)
            return
        }

        // 检查缓存
        if let height = layoutCacheStore.value(forKey: indexPath) {
            completion(height)
            return
        }

        // 在后台线程计算高度
        layoutQueue.addOperation { [cache = layoutCacheStore] in
            let height = self.tableView(self, heightForRowAt: indexPath)
            cache.setValue(height, forKey: indexPath)

            // 在主线程回调
            DispatchQueue.main.async {
                completion(height)
            }
        }
    }
    
    /// 批量异步计算 cell 高度
    /// - Parameters:
    ///   - indexPaths: 索引路径数组
    ///   - completion: 计算完成回调
    func asyncCalculateCellHeights(for indexPaths: [IndexPath], completion: @escaping ([IndexPath: CGFloat]) -> Void) {
        guard enableAsyncLayout, !indexPaths.isEmpty else {
            let heights = indexPaths.reduce(into: [IndexPath: CGFloat]()) { result, indexPath in
                result[indexPath] = tableView(self, heightForRowAt: indexPath)
            }
            completion(heights)
            return
        }

        // 分批处理
        let batches = stride(from: 0, to: indexPaths.count, by: AsyncLayoutConstants.maxBatchSize).map {
            Array(indexPaths[$0..<min($0 + AsyncLayoutConstants.maxBatchSize, indexPaths.count)])
        }

        var results: [IndexPath: CGFloat] = [:]
        let resultsLock = NSLock()
        let group = DispatchGroup()

        for batch in batches {
            group.enter()

            layoutQueue.addOperation { [cache = layoutCacheStore] in
                let batchResults = batch.reduce(into: [IndexPath: CGFloat]()) { result, indexPath in
                    if let height = cache.value(forKey: indexPath) {
                        result[indexPath] = height
                        return
                    }

                    let height = self.tableView(self, heightForRowAt: indexPath)
                    cache.setValue(height, forKey: indexPath)
                    result[indexPath] = height
                }

                resultsLock.lock()
                results.merge(batchResults) { _, new in new }
                resultsLock.unlock()
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(results)
        }
    }
    
    /// 异步布局指定的 cell（cell frame 设置回主线程，计算在后台）
    /// - Parameters:
    ///   - cell: 要布局的 cell
    ///   - indexPath: 索引路径
    ///   - completion: 布局完成回调
    func asyncLayoutCell(_ cell: UITableViewCell, at indexPath: IndexPath, completion: (() -> Void)? = nil) {
        guard enableAsyncLayout else {
            cell.layoutIfNeeded()
            completion?()
            return
        }

        layoutQueue.addOperation {
            let height = self.tableView(self, heightForRowAt: indexPath)
            let width = self.bounds.width

            // UIView 操作必须回主线程
            DispatchQueue.main.async {
                cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                completion?()
            }
        }
    }
    
    /// 清理布局缓存
    func clearLayoutCache() {
        layoutCacheStore.removeAll()
    }

    /// 清理指定 indexPath 的布局缓存
    /// - Parameter indexPath: 索引路径
    func clearLayoutCache(for indexPath: IndexPath) {
        layoutCacheStore.removeValue(forKey: indexPath)
    }

    /// 清理指定 section 的布局缓存
    /// - Parameter section: section 索引
    func clearLayoutCache(forSection section: Int) {
        layoutCacheStore.filter { $0.section != section }
    }
}

/// 扩展 DispatchQueue，添加定时器功能
fileprivate class DispatchTimer {
    private var timer: DispatchSourceTimer?
    
    class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping () -> Void) -> DispatchTimer {
        let timer = DispatchTimer()
        timer.timer = DispatchSource.makeTimerSource(queue: .global())
        if repeats {
            timer.timer?.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            timer.timer?.schedule(deadline: .now() + interval)
        }
        timer.timer?.setEventHandler(handler: block)
        timer.timer?.resume()
        return timer
    }
    
    func invalidate() {
        timer?.cancel()
        timer = nil
    }
}
