//
//  HFlowCacheManager.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import SDWebImage
import Kingfisher

/// 缓存管理常量
private enum CacheConstants {
    /// 默认缓存容量
    static let defaultCacheCapacity = 3000

    /// 最大缓存容量
    static let maxCacheCapacity = 10000

    /// 缓存清理阈值（当缓存大小达到此百分比时触发清理）
    static let cacheCleanupThreshold: CGFloat = 0.9

    /// 清理后保留的缓存比例
    static let cacheRetentionRatio: CGFloat = 0.6
}

/// 缓存统计信息
struct HFlowCacheStatistics {
    /// 缓存命中次数
    var hitCount: Int
    /// 缓存未命中次数
    var missCount: Int
    /// 缓存大小
    var cacheSize: Int
    
    /// 缓存命中率
    var hitRate: Double {
        let total = hitCount + missCount
        return total > 0 ? Double(hitCount) / Double(total) : 0
    }
}

/// 缓存管理类
///
/// 负责管理HFlowView的各种缓存，包括：
/// 1. Cell高度缓存
/// 2. Cell实例缓存
/// 3. 图片缓存
/// 4. 网络请求缓存
class HFlowCacheManager {
    
    // MARK: - Properties
    
    /// 弱引用HFlowView
    private weak var flowView: HFlowView?
    
    /// Cell高度缓存
    private var cellHeightsCache: HFlowLRUCache<String, CGFloat>
    
    /// Cell实例缓存
    private var cellInstancesCache: HFlowLRUCache<String, Weak<UITableViewCell>>
    
    /// 缓存统计信息
    private var statistics = HFlowCacheStatistics(hitCount: 0, missCount: 0, cacheSize: 0)
    
    /// 缓存锁
    private let cacheLock = NSLock()
    
    // MARK: - Initialization
    
    /// 初始化缓存管理器
    /// - Parameter flowView: HFlowView实例
    init(flowView: HFlowView) {
        self.flowView = flowView
        self.cellHeightsCache = HFlowLRUCache<String, CGFloat>(capacity: CacheConstants.defaultCacheCapacity)
        self.cellInstancesCache = HFlowLRUCache<String, Weak<UITableViewCell>>(capacity: CacheConstants.defaultCacheCapacity)
    }
    
    // MARK: - Cell Height Cache
    
    /// 缓存Cell高度
    /// - Parameters:
    ///   - height: Cell高度
    ///   - indexPath: 索引路径
    func cacheCellHeight(_ height: CGFloat, for indexPath: IndexPath) {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        let key = "\(indexPath.section)-\(indexPath.row)"
        cellHeightsCache[key] = height
        updateCacheSize()
    }
    
    /// 获取缓存的Cell高度
    /// - Parameter indexPath: 索引路径
    /// - Returns: 缓存的Cell高度，如果不存在则返回nil
    func getCachedCellHeight(for indexPath: IndexPath) -> CGFloat? {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        let key = "\(indexPath.section)-\(indexPath.row)"
        if let height = cellHeightsCache[key] {
            statistics.hitCount += 1
            return height
        } else {
            statistics.missCount += 1
            return nil
        }
    }
    
    /// 清理Cell高度缓存
    func clearCellHeightCache() {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        cellHeightsCache.removeAll()
        updateCacheSize()
    }
    
    // MARK: - Cell Instance Cache
    
    /// 缓存Cell实例
    /// - Parameters:
    ///   - cell: Cell实例
    ///   - identifier: Cell标识符
    func cacheCellInstance(_ cell: UITableViewCell, withIdentifier identifier: String) {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        cellInstancesCache[identifier] = Weak(cell)
        updateCacheSize()
    }
    
    /// 获取缓存的Cell实例
    /// - Parameter identifier: Cell标识符
    /// - Returns: 缓存的Cell实例，如果不存在或已被释放则返回nil
    func getCachedCellInstance(withIdentifier identifier: String) -> UITableViewCell? {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        if let weakCell = cellInstancesCache[identifier], let cell = weakCell.value {
            statistics.hitCount += 1
            return cell
        } else {
            statistics.missCount += 1
            return nil
        }
    }
    
    /// 清理Cell实例缓存
    func clearCellInstanceCache() {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        cellInstancesCache.removeAll()
        updateCacheSize()
    }
    
    // MARK: - Image Cache
    
    /// 缓存图片
    /// - Parameters:
    ///   - image: 图片
    ///   - key: 缓存键
    func cacheImage(_ image: UIImage, forKey key: String) {
        // 使用SDWebImage和Kingfisher的缓存机制
        SDImageCache.shared.store(image, forKey: key)
        KingfisherManager.shared.cache.store(image, forKey: key)
    }
    
    /// 清理图片缓存
    func clearImageCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk(onCompletion: {})
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
    // MARK: - Cache Management
    
    /// 清理所有缓存
    func clearAllCache() {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        cellHeightsCache.removeAll()
        cellInstancesCache.removeAll()
        clearImageCache()
        updateCacheSize()
    }
    
    /// 清理过期缓存
    func cleanupCache() {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        // 检查缓存大小是否超过阈值
        let totalCapacity = cellHeightsCache.count + cellInstancesCache.count
        let capacityThreshold = Int(Double(CacheConstants.maxCacheCapacity) * Double(CacheConstants.cacheCleanupThreshold))
        
        if totalCapacity > capacityThreshold {
            // 清理到指定比例
            let targetCapacity = Int(Double(CacheConstants.maxCacheCapacity) * Double(CacheConstants.cacheRetentionRatio))
            
            // 优先清理Cell实例缓存
            while cellInstancesCache.count > 0 && (cellHeightsCache.count + cellInstancesCache.count) > targetCapacity {
                if let oldestKey = cellInstancesCache.keys.first {
                    cellInstancesCache[oldestKey] = nil
                }
            }
            
            // 清理Cell高度缓存
            while cellHeightsCache.count > 0 && (cellHeightsCache.count + cellInstancesCache.count) > targetCapacity {
                if let oldestKey = cellHeightsCache.keys.first {
                    cellHeightsCache[oldestKey] = nil
                }
            }
            
            updateCacheSize()
        }
    }
    
    /// 更新缓存大小
    private func updateCacheSize() {
        statistics.cacheSize = cellHeightsCache.count + cellInstancesCache.count
    }
    
    // MARK: - Statistics
    
    /// 获取缓存统计信息
    /// - Returns: 缓存统计信息
    func getCacheStatistics() -> HFlowCacheStatistics {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        return statistics
    }
    
    /// 重置缓存统计信息
    func resetCacheStatistics() {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        statistics = HFlowCacheStatistics(hitCount: 0, missCount: 0, cacheSize: statistics.cacheSize)
    }
}
