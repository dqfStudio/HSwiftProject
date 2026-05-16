//
//  HCollView+Reload.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// MARK: - Reload Management
extension HCollView {
    // 多少秒内只刷新一次
    func reloadIfNeeded(_ delay: TimeInterval = Constants.defaultRefreshThrottleInterval) {
        if self.collReload.isRefresh {
            self.collReload.markAsNeedRefresh()
        }else {
            self.reloadAsync(delay)
        }
    }
    
    private func reloadAsync(_ delay: TimeInterval) {
        self.collReload.markAsRefreshing()
        self.reloadCollData()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.collReload.needRefresh {
                self.reloadAsync(delay)
            } else {
                self.collReload.markAsRefreshCompleted()
            }
        }
    }
    
    // 节流 item 重新加载以避免频繁更新
    func reloadItemsIfNeeded(at indexPaths: [IndexPath], _ delay: TimeInterval? = nil) {
        guard !indexPaths.isEmpty else { return }
        
        // 确保线程安全
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.allReloadItems.append(contentsOf: indexPaths)
            
            guard !self.itemReload.isRefresh else {
                self.itemReload.markAsNeedRefresh()
                return
            }
            
            let actualDelay = delay ?? self.itemRefreshThrottleInterval
            self.reloadItemsAsync(at: indexPaths, actualDelay)
        }
    }
    
    private func reloadItemsAsync(at indexPaths: [IndexPath], _ delay: TimeInterval) {
        itemReload.markAsRefreshing()
        reloadedItems.append(contentsOf: indexPaths)
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadItems(at: indexPaths)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            if self.itemReload.needRefresh {
                // 计算待处理项（尚未重新加载）
                let pendingItems = Set(self.allReloadItems).subtracting(Set(self.reloadedItems))
                if !pendingItems.isEmpty {
                    // 使用迭代方式处理待刷新项，避免递归
                    self.processPendingItemsIteratively(pendingItems, delay)
                }
            } else {
                // 重置状态
                self.resetItemReloadState()
            }
        }
    }
    
    /// Process pending reload items using queue-based approach to avoid recursion
    private func processPendingItemsIteratively(_ pendingItems: Set<IndexPath>, _ delay: TimeInterval) {
        // 添加到队列以进行批处理
        pendingReloadQueue.append(pendingItems)
        
        // 如果尚未处理则开始处理
        guard !isProcessingReloadQueue else { return }
        isProcessingReloadQueue = true
        
        processNextReloadBatch(delay)
    }
    
    /// Process the next batch in the reload queue
    private func processNextReloadBatch(_ delay: TimeInterval) {
        guard !pendingReloadQueue.isEmpty else {
            isProcessingReloadQueue = false
            resetItemReloadState()
            return
        }
        
        let itemsToReload = pendingReloadQueue.removeFirst()
        reloadedItems.append(contentsOf: itemsToReload)
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadItems(at: Array(itemsToReload))
        }
        
        // 在延迟后调度下一批
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            // 检查在延迟期间是否有新的待处理项累积
            if self.itemReload.needRefresh {
                let newPendingItems = Set(self.allReloadItems).subtracting(Set(self.reloadedItems))
                if !newPendingItems.isEmpty {
                    self.pendingReloadQueue.append(newPendingItems)
                }
            }
            
            // 处理下一批
            self.processNextReloadBatch(delay)
        }
    }
    
    /// 重置item刷新状态
    private func resetItemReloadState() {
        itemReload.reset()
        allReloadItems.removeAll()
        reloadedItems.removeAll()
    }
    
    @objc
    func reloadCollData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        
        // 批量清理无效弱引用以防止内存泄漏
        cleanupWeakReferencesIfNeeded()
        
        // 根据数据状态更新空视图可见性
        updateEmptyViewVisibility()
    }
}
