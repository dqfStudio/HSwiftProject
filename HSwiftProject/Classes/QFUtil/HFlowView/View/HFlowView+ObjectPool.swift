//
//  HFlowView+ObjectPool.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 对象池协议，定义对象的创建和重用方法
protocol HFlowObjectPoolProtocol {
    associatedtype ObjectType: AnyObject
    
    /// 从池中获取对象
    func getObject() -> ObjectType?
    
    /// 将对象归还到池中
    func returnObject(_ object: ObjectType)
    
    /// 清空对象池
    func clearPool()
    
    /// 获取对象池大小
    var poolSize: Int { get }
}

/// 泛型对象池实现
class HFlowObjectPool<T: AnyObject>: HFlowObjectPoolProtocol {
    typealias ObjectType = T
    
    // MARK: - Properties
    
    /// 池容量
    private let capacity: Int
    
    /// 对象工厂，用于创建新对象
    private let objectFactory: () -> T
    
    /// 存储对象的数组（使用弱引用）
    private var objects: [Weak<T>] = []
    
    /// 线程安全锁
    private let lock = NSLock()
    
    // MARK: - Initialization
    
    /// 初始化对象池
    /// - Parameters:
    ///   - capacity: 池容量
    ///   - objectFactory: 对象工厂闭包
    init(capacity: Int, objectFactory: @escaping () -> T) {
        self.capacity = max(1, capacity)
        self.objectFactory = objectFactory
    }
    
    // MARK: - HFlowObjectPoolProtocol
    
    /// 从池中获取对象
    /// - Returns: 对象实例，如果池中没有可用对象则创建新对象
    func getObject() -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        // 清理已释放的对象
        cleanupReleasedObjects()
        
        if !objects.isEmpty {
            // 移除并返回最后一个对象
            if let object = objects.removeLast().value {
                return object
            } else {
                // 如果最后一个对象已被释放，递归调用获取下一个
                return getObject()
            }
        } else {
            return objectFactory()
        }
    }
    
    /// 清理已释放的对象
    private func cleanupReleasedObjects() {
        objects = objects.filter { $0.value != nil }
    }
    
    /// 将对象归还到池中
    /// - Parameter object: 要归还的对象
    func returnObject(_ object: T) {
        lock.lock()
        defer { lock.unlock() }
        
        // 清理已释放的对象
        cleanupReleasedObjects()
        
        if objects.count < capacity {
            objects.append(Weak(object))
        }
    }
    
    /// 清空对象池
    func clearPool() {
        lock.lock()
        defer { lock.unlock() }
        
        objects.removeAll()
    }
    
    /// 获取对象池大小
    var poolSize: Int {
        lock.lock()
        defer { lock.unlock() }
        
        // 清理已释放的对象
        cleanupReleasedObjects()
        return objects.count
    }
}

// 关联对象键
private var cellPoolsKey: UInt8 = 0
private var memoryWarningObserverKey: UInt8 = 0
private var poolUsageStatisticsKey: UInt8 = 0

/// HFlowView 对象池扩展
///
/// 为 HFlowView 提供对象池功能，用于缓存和重用 UITableViewCell，提高滚动性能
///
/// 使用场景：
/// 1. 当需要频繁创建和销毁相同类型的 cell 时
/// 2. 当滚动速度要求较高时
/// 3. 当 cell 初始化成本较高时
extension HFlowView {
    
    // MARK: - Constants
    
    private enum ObjectPoolConstants {
        /// 默认对象池容量
        static let defaultPoolCapacity = 10
        
        /// 最大对象池容量（基础值）
        static let baseMaxPoolCapacity = 30
        
        /// 最小对象池容量
        static let minPoolCapacity = 5
    }
    
    // MARK: - Properties
    
    /// 存储不同类型 cell 的对象池
    private var cellPools: [String: Any] {
        get {
            if let pools = objc_getAssociatedObject(self, &cellPoolsKey) as? [String: Any] {
                return pools
            } else {
                let pools: [String: Any] = [:]
                objc_setAssociatedObject(self, &cellPoolsKey, pools, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return pools
            }
        }
        set {
            objc_setAssociatedObject(self, &cellPoolsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 内存警告监听
    private var memoryWarningObserver: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &memoryWarningObserverKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &memoryWarningObserverKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 对象池使用统计
    private var poolUsageStatistics: [String: (hitCount: Int, missCount: Int, createCount: Int)] {
        get {
            if let stats = objc_getAssociatedObject(self, &poolUsageStatisticsKey) as? [String: (hitCount: Int, missCount: Int, createCount: Int)] {
                return stats
            } else {
                let stats: [String: (hitCount: Int, missCount: Int, createCount: Int)] = [:]
                objc_setAssociatedObject(self, &poolUsageStatisticsKey, stats, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return stats
            }
        }
        set {
            objc_setAssociatedObject(self, &poolUsageStatisticsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Object Pool Methods
    
    /// 为指定类型的 cell 创建对象池
    /// - Parameters:
    ///   - cellType: cell 类型
    ///   - capacity: 池容量
    ///   - factory: 对象工厂闭包
    func createCellPool<T: UITableViewCell>(for cellType: T.Type, capacity: Int = ObjectPoolConstants.defaultPoolCapacity, factory: @escaping () -> T) {
        let cellIdentifier = String(describing: cellType)
        
        // 根据设备内存情况动态调整容量
        let optimalCapacity = getOptimalPoolCapacity(baseCapacity: capacity)
        let pool = HFlowObjectPool<T>(capacity: optimalCapacity, objectFactory: factory)
        var pools = cellPools
        pools[cellIdentifier] = pool
        cellPools = pools
        
        // 初始化使用统计
        var stats = poolUsageStatistics
        stats[cellIdentifier] = (hitCount: 0, missCount: 0, createCount: 0)
        poolUsageStatistics = stats
        
        // 添加内存警告监听
        setupMemoryWarningObserver()
    }
    
    /// 设置内存警告监听
    private func setupMemoryWarningObserver() {
        if memoryWarningObserver == nil {
            memoryWarningObserver = NotificationCenter.default.addObserver(
                forName: UIApplication.didReceiveMemoryWarningNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.clearAllCellPools()
                }
            }
        }
    }
    
    /// 获取最佳对象池容量
    /// - Parameter baseCapacity: 基础容量
    /// - Returns: 最佳容量
    private func getOptimalPoolCapacity(baseCapacity: Int) -> Int {
        // 检查设备内存情况
        let memoryStatus = getMemoryStatus()
        
        // 根据内存状态调整容量
        let baseMaxCapacity = ObjectPoolConstants.baseMaxPoolCapacity
        let minCapacity = ObjectPoolConstants.minPoolCapacity
        
        switch memoryStatus {
        case .high:
            // 内存充足，使用较大容量
            return min(baseCapacity * 2, baseMaxCapacity * 2)
        case .medium:
            // 内存适中，使用默认容量
            return min(baseCapacity, baseMaxCapacity)
        case .low:
            // 内存紧张，使用较小容量
            return max(baseCapacity / 2, minCapacity)
        }
    }
    
    /// 内存状态枚举
    private enum MemoryStatus {
        case high    // 内存充足
        case medium  // 内存适中
        case low     // 内存紧张
    }
    
    /// 获取设备内存状态
    /// - Returns: 内存状态
    private func getMemoryStatus() -> MemoryStatus {
        // 获取设备内存信息
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<natural_t>.size)
        let kerr = withUnsafeMutablePointer(to: &taskInfo) { pointer in
            return pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { 
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = taskInfo.resident_size
            let totalMemory = getTotalMemory()
            let memoryUsage = Double(usedMemory) / Double(totalMemory)
            
            // 根据内存使用率判断内存状态
            if memoryUsage < 0.6 {
                return .high
            } else if memoryUsage < 0.8 {
                return .medium
            } else {
                return .low
            }
        }
        
        // 默认返回中等内存状态
        return .medium
    }
    
    /// 获取设备总内存
    /// - Returns: 总内存（字节）
    private func getTotalMemory() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    /// 从对象池中获取指定类型的 cell
    /// - Parameter cellType: cell 类型
    /// - Returns: cell 实例，如果对象池不存在则返回 nil
    func getCellFromPool<T: UITableViewCell>(_ cellType: T.Type) -> T? {
        let cellIdentifier = String(describing: cellType)
        
        if let pool = cellPools[cellIdentifier] as? HFlowObjectPool<T>, let cell = pool.getObject() {
            // 更新使用统计
            var stats = poolUsageStatistics
            if var cellStats = stats[cellIdentifier] {
                cellStats.hitCount += 1
                stats[cellIdentifier] = cellStats
                poolUsageStatistics = stats
            }
            return cell
        } else {
            // 更新使用统计
            var stats = poolUsageStatistics
            if var cellStats = stats[cellIdentifier] {
                cellStats.missCount += 1
                cellStats.createCount += 1
                stats[cellIdentifier] = cellStats
                poolUsageStatistics = stats
            }
            return nil
        }
    }
    
    /// 将 cell 归还到对象池中
    /// - Parameter cell: 要归还的 cell
    func returnCellToPool(_ cell: UITableViewCell) {
        let cellIdentifier = String(describing: type(of: cell))
        if let pool = cellPools[cellIdentifier] as? HFlowObjectPool<UITableViewCell> {
            pool.returnObject(cell)
        }
    }
    
    /// 清空指定类型的对象池
    /// - Parameter cellType: cell 类型
    func clearCellPool<T: UITableViewCell>(_ cellType: T.Type) {
        let cellIdentifier = String(describing: cellType)
        if let pool = cellPools[cellIdentifier] as? HFlowObjectPool<T> {
            pool.clearPool()
        }
    }
    
    /// 清空所有对象池
    func clearAllCellPools() {
        var pools = cellPools
        pools.forEach { _, pool in
            if let pool = pool as? (any HFlowObjectPoolProtocol) {
                pool.clearPool()
            }
        }
        pools.removeAll()
        cellPools = pools
    }
    
    /// 获取指定类型对象池的大小
    /// - Parameter cellType: cell 类型
    /// - Returns: 对象池大小
    func getCellPoolSize<T: UITableViewCell>(_ cellType: T.Type) -> Int {
        let cellIdentifier = String(describing: cellType)
        if let pool = cellPools[cellIdentifier] as? HFlowObjectPool<T> {
            return pool.poolSize
        }
        return 0
    }
}

/// 扩展 HFlowViewDelegate，添加对象池相关方法
extension HFlowViewDelegate {
    /// 当 cell 将要被回收时调用
    /// - Parameters:
    ///   - cell: 将要被回收的 cell
    ///   - indexPath: 索引路径
    func willRecycleCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        // 默认实现为空
    }
}
