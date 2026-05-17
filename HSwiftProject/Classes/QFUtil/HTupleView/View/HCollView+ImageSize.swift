//
//  HCollView+ImageSize.swift
//  HSwiftProject
//
//  Created by owner on 2025/5/17.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: - 全局图片尺寸缓存

/// 线程安全的图片尺寸缓存，整个 App 共享
/// 利用 Kingfisher 下载图片并提取尺寸，下载后的图片会被 Kingfisher 缓存，
/// 后续 cell 显示时直接命中缓存，不重复下载
class HCollImageSizeCache {
    
    static let shared = HCollImageSizeCache()
    
    private var cache: [String: CGSize] = [:]
    private var pendingURLs: Set<String> = []
    private let lock = NSLock()
    
    func size(for urlString: String) -> CGSize? {
        lock.lock(); defer { lock.unlock() }
        return cache[urlString]
    }
    
    func hasSize(for urlString: String) -> Bool {
        lock.lock(); defer { lock.unlock() }
        return cache[urlString] != nil
    }
    
    func isPending(for urlString: String) -> Bool {
        lock.lock(); defer { lock.unlock() }
        return pendingURLs.contains(urlString)
    }
    
    /// 异步获取图片尺寸，利用 Kingfisher 下载图片并提取尺寸
    /// 下载后的图片会被 Kingfisher 缓存，后续显示时直接命中
    /// 完成回调在主线程
    func fetchSize(for urlString: String, completion: @escaping (CGSize?) -> Void) {
        if let cached = size(for: urlString) {
            DispatchQueue.main.async { completion(cached) }
            return
        }
        
        lock.lock()
        guard !pendingURLs.contains(urlString) else {
            lock.unlock()
            return
        }
        pendingURLs.insert(urlString)
        lock.unlock()
        
        guard let url = URL(string: urlString) else {
            lock.lock(); pendingURLs.remove(urlString); lock.unlock()
            DispatchQueue.main.async { completion(nil) }
            return
        }
        
        // 用 Kingfisher 下载完整图片
        // 下载完成后图片数据已被 Kingfisher 缓存，cell 显示时直接命中
        // 不会浪费流量
        KingfisherManager.shared.retrieveImage(
            with: url,
            options: [
                .callbackQueue(.dispatch(.global(qos: .utility))),
                .memoryCacheExpiration(.seconds(TimeInterval(60 * 5))),     // 5分钟内存缓存
                .diskCacheExpiration(.days(7))                 // 7天磁盘缓存
            ]
        ) { [weak self] result in
            guard let self = self else { return }
            
            self.lock.lock()
            self.pendingURLs.remove(urlString)
            
            switch result {
            case .success(let imageResult):
                let size = imageResult.image.size
                self.cache[urlString] = size
                self.lock.unlock()
                DispatchQueue.main.async { completion(size) }
            case .failure:
                self.lock.unlock()
                DispatchQueue.main.async { completion(nil) }
            }
        }
    }
    
    /// 批量预取一组 URL 的尺寸，全部就绪后回调（主线程）
    func prefetchSizes(for urlStrings: [String], completion: @escaping () -> Void) {
        guard !urlStrings.isEmpty else { completion(); return }
        let group = DispatchGroup()
        for urlString in urlStrings {
            group.enter()
            fetchSize(for: urlString) { _ in group.leave() }
        }
        group.notify(queue: .main) { completion() }
    }
    
    func clear() {
        lock.lock(); defer { lock.unlock() }
        cache.removeAll()
        pendingURLs.removeAll()
    }
}

// MARK: - HCollView 图片尺寸辅助

extension HCollView {
    
    // MARK: - Public Cache Access
    
    /// 获取已缓存的图片等比高度
    func cachedImageHeight(url: String, availableWidth: CGFloat) -> CGFloat? {
        guard let size = HCollImageSizeCache.shared.size(for: url),
              size.width > 0, size.height > 0 else { return nil }
        return availableWidth * (size.height / size.width)
    }
    
    /// 获取已缓存的图片原始尺寸
    func cachedImageSize(for url: String) -> CGSize? {
        return HCollImageSizeCache.shared.size(for: url)
    }
    
    // MARK: - Manual Prefetch
    
    /// 预取图片尺寸（Kingfisher 下载完整图片并缓存）
    func prefetchImageSizes(urls: [String], completion: @escaping () -> Void) {
        HCollImageSizeCache.shared.prefetchSizes(for: urls, completion: completion)
    }
    
    /// 等所有图片尺寸就绪后 reloadData，避免首屏闪缩
    func prefetchAndReloadData(allImageURLs: [[String]], timeout: TimeInterval = 3.0) {
        let allURLs = Array(Set(allImageURLs.flatMap { $0 }))
        guard !allURLs.isEmpty else {
            (self as UICollectionView).reloadData()
            return
        }
        
        var didTimeout = false
        let timeoutWork = DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            didTimeout = true
            (self as UICollectionView).reloadData()
        })
        
        prefetchImageSizes(urls: allURLs) { [weak self] in
            guard let self = self else { return }
            timeoutWork.cancel()
            guard !didTimeout else { return }
            (self as UICollectionView).reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutWork)
    }
    
    /// 预取指定 item 的图片尺寸，就绪后刷新该 item
    func prefetchImageSizesAndReloadItem(urls: [String], at indexPath: IndexPath) {
        prefetchImageSizes(urls: urls) { [weak self] in
            guard let self = self else { return }
            UIView.performWithoutAnimation {
                (self as UICollectionView).reloadItems(at: [indexPath])
            }
        }
    }
    
    // MARK: - Auto Prefetch (called by framework)
    
    /// 预取可见 cell 及其前后若干个 cell 的图片尺寸
    /// 框架在 willDisplayCell 时自动调用
    func prefetchImagesForVisibleAndAheadCells(aheadCount: Int = 3) {
        let visibleIndexPaths = indexPathsForVisibleItems
        
        // 收集所有需要预取的 URL
        var allURLs = Set<String>()
        
        // 1. 当前可见 cell 的图片
        for ip in visibleIndexPaths {
            if let cell = cellForItem(at: ip) as? HCollBaseCell {
                for url in cell.prefetchImageURLs {
                    if !HCollImageSizeCache.shared.hasSize(for: url) {
                        allURLs.insert(url)
                    }
                }
            }
        }
        
        // 2. 往后 N 个 cell（还没显示的）— 通过 delegate 获取
        if let lastVisible = visibleIndexPaths.max(by: { $0.item < $1.item }) {
            let section = lastVisible.section
            let totalItems = numberOfItems(inSection: section)
            let endIndex = min(lastVisible.item + 1 + aheadCount, totalItems)
            
            for item in (lastVisible.item + 1)..<endIndex {
                let ip = IndexPath(item: item, section: section)
                if let cell = cellForItem(at: ip) as? HCollBaseCell {
                    for url in cell.prefetchImageURLs {
                        if !HCollImageSizeCache.shared.hasSize(for: url) {
                            allURLs.insert(url)
                        }
                    }
                }
                // 如果 cell 还未创建，无法获取 URL — 这里跳过
                // 业务方可以在 collItem 中预取，或在 Model 层主动调用 prefetchImageSizes
            }
        }
        
        guard !allURLs.isEmpty else { return }
        prefetchImageSizes(urls: Array(allURLs)) { }
    }
}
