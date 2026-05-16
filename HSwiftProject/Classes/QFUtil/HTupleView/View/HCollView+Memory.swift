//
//  HCollView+Memory.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - Memory Management
extension HCollView {
    /// 清理无效的弱引用缓存
    ///
    /// 定期清理已释放的 cell 引用，防止内存泄漏
    internal func cleanupInvalidWeakReferences() {
        // 创建新的缓存来存储有效引用
        let validCells = HCollLRUCache<String, Weak<HCollBaseCell>>(capacity: HCollView.Constants.maxTrackedCells)
        
        // 遍历当前缓存，只保留有效的引用
        for (key, node) in allReuseCells.cache {
            if node.value.value != nil {
                validCells.set(node.value, for: key)
            }
        }
        
        // 替换为新的缓存
        allReuseCells = validCells
        
        // 同样清理 header 和 footer 缓存
        let validHeaders = HCollLRUCache<String, Weak<HCollBaseApex>>(capacity: HCollView.Constants.maxTrackedCells)
        for (key, node) in allReuseHeaders.cache {
            if node.value.value != nil {
                validHeaders.set(node.value, for: key)
            }
        }
        allReuseHeaders = validHeaders
        
        let validFooters = HCollLRUCache<String, Weak<HCollBaseApex>>(capacity: HCollView.Constants.maxTrackedCells)
        for (key, node) in allReuseFooters.cache {
            if node.value.value != nil {
                validFooters.set(node.value, for: key)
            }
        }
        allReuseFooters = validFooters
    }
    
    /// 批量清理无效引用并限制操作频率
    ///
    /// 避免频繁遍历字典，提高性能
    internal func cleanupWeakReferencesIfNeeded() {
        // 当缓存数量超过阈值时才执行清理
        guard allReuseCells.count > HCollView.Constants.maxTrackedCells * 2 else { return }
        cleanupInvalidWeakReferences()
    }
    
    /// 清理图片缓存以防止内存堆积
    ///
    /// 仅清理内存缓存，保留磁盘缓存以提高性能
    internal func clearImageCaches() {
        // 使用 Kingfisher 清理内存缓存
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    /// 内存警告处理
    @objc func handleMemoryWarning() {
        // 清理图片缓存（仅内存）
        clearImageCaches()
            
        // 清理 cell 缓存
        allReuseCells.removeAll()
        allReuseHeaders.removeAll()
        allReuseFooters.removeAll()
            
        // 清理布局缓存
        allSectionInsets.removeAll()
            
        // 清理标识符缓存
        allHeaderIdentifiers.removeAll()
        allFooterIdentifiers.removeAll()
        allCellIdentifiers.removeAll()
            
        // 清理追踪集合
        allPassedCells.removeAll()
    }
    
    /// Release method - clean up all resources
    @objc
    func releaseCollBlock() {
        // 在后台线程执行清理
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            self.releaseAllSignal()
            self.clearCollState()

            // 在主线程上更新 UI 相关属性
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collDelegate = nil
                self.loadMoreBlock = nil
                self.refreshBlock = nil
                self.dataSource = nil
                self.delegate = nil
            }
        }
    }
    
    /// 清除集合视图状态
    private func clearCollState() {
        // 清理缓存
        allReuseCells.removeAll()
        allReuseHeaders.removeAll()
        allReuseFooters.removeAll()
        allPassedCells.removeAll()
        allHeaderIdentifiers.removeAll()
        allFooterIdentifiers.removeAll()
        allCellIdentifiers.removeAll()
        allSectionInsets.removeAll()
        
        // 清理队列
        pendingReloadQueue.removeAll()
        isProcessingReloadQueue = false
        
        // 清理追踪数组
        allReloadItems.removeAll()
        reloadedItems.removeAll()
    }
    

}
