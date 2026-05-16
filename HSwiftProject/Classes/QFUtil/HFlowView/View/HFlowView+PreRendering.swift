//
//  HFlowView+PreRendering.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// HFlowView 预渲染扩展
///
/// 为 HFlowView 提供预渲染功能，在滚动前提前计算和渲染 cell，提高滚动流畅度
///
/// 实现原理：
/// 1. 在滚动开始前，预计算和渲染即将显示的 cell
/// 2. 将渲染结果缓存起来，当真正需要显示时直接使用
/// 3. 在后台线程进行预计算，避免阻塞主线程

// 关联对象键
private var enablePreRenderingKey: UInt8 = 0
private var preRenderQueueKey: UInt8 = 0
private var preRenderedCellsKey: UInt8 = 0
private var preRenderLockKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Constants
    
    private enum PreRenderingConstants {
        /// 预渲染的 cell 数量（基础值）
        static let basePreRenderCount = 2

        /// 预渲染缓存的硬上限（防止 100K+ 场景 OOM）
        static let maxPreRenderedCellCount = 30

        /// 预渲染的提前量（像素）
        static let preRenderThreshold: CGFloat = 200.0

        /// 预渲染队列的最大并发数（基础值）
        static let baseMaxConcurrentOperations = 1
    }
    
    // MARK: - Properties
    
    /// 是否启用预渲染
    public var enablePreRendering: Bool {
        get {
            return objc_getAssociatedObject(self, &enablePreRenderingKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &enablePreRenderingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预渲染操作队列
    private var preRenderQueue: OperationQueue {
        get {
            if let queue = objc_getAssociatedObject(self, &preRenderQueueKey) as? OperationQueue {
                return queue
            } else {
                let queue = OperationQueue()
                queue.maxConcurrentOperationCount = getOptimalConcurrentOperations()
                queue.qualityOfService = .userInitiated
                objc_setAssociatedObject(self, &preRenderQueueKey, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return queue
            }
        }
    }
    
    /// 设备性能等级
    private var devicePerformanceLevel: Int {
        return getDevicePerformanceLevel()
    }
    
    /// 预渲染缓存
    internal var preRenderedCells: [IndexPath: UITableViewCell] {
        get {
            return objc_getAssociatedObject(self, &preRenderedCellsKey) as? [IndexPath: UITableViewCell] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &preRenderedCellsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预渲染锁
    internal var preRenderLock: NSLock {
        get {
            if let lock = objc_getAssociatedObject(self, &preRenderLockKey) as? NSLock {
                return lock
            } else {
                let lock = NSLock()
                objc_setAssociatedObject(self, &preRenderLockKey, lock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return lock
            }
        }
    }
    
    // MARK: - Pre-rendering Methods
    
    /// 预渲染指定索引路径的 cell
    /// - Parameter indexPath: 索引路径
    func preRenderCell(at indexPath: IndexPath) {
        guard enablePreRendering, delegate is HFlowViewDelegate else { return }
        
        preRenderQueue.addOperation {
            // 在后台线程创建和配置 cell
            var cell: UITableViewCell? = nil
            var height: CGFloat = 0
            
            // 在主线程获取 cell 和计算高度
            DispatchQueue.main.sync {
                cell = self.flowDelegate?.flowRow(self, atIndexPath: indexPath)
                height = self.tableView(self, heightForRowAt: indexPath)
            }
            
            if let cell = cell {
                // 配置 cell 大小
                cell.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
                
                // 布局 cell
                cell.layoutIfNeeded()
                
                // 缓存预渲染的 cell（硬上限保护）
                DispatchQueue.main.sync {
                    self.preRenderLock.lock()
                    if self.preRenderedCells.count >= PreRenderingConstants.maxPreRenderedCellCount {
                        if let oldestKey = self.preRenderedCells.keys.sorted(by: { $0.row < $1.row }).first {
                            self.preRenderedCells.removeValue(forKey: oldestKey)
                        }
                    }
                    self.preRenderedCells[indexPath] = cell
                    self.preRenderLock.unlock()
                }
                
                // 记录预渲染成功
                DispatchQueue.main.sync {
                    self.recordPreRenderResult(true)
                }
            } else {
                // 记录预渲染失败
                DispatchQueue.main.sync {
                    self.recordPreRenderResult(false)
                }
            }
        }
    }
    
    // MARK: - Device Performance Detection
    
    /// 获取设备性能等级
    /// - Returns: 设备性能等级，范围为 1-5，数字越大性能越好
    private func getDevicePerformanceLevel() -> Int {
        // 根据设备型号和系统版本判断性能等级
        let device = UIDevice.current
        let systemVersion = Double(device.systemVersion) ?? 16.0
        
        // 这里可以根据实际设备型号和系统版本进行更详细的性能等级划分
        // 简单实现：基于系统版本和设备类型
        if systemVersion >= 16.0 {
            // 较新的系统
            if device.userInterfaceIdiom == .pad {
                return 5 // iPad 性能较好
            } else {
                return 4 // iPhone 性能中等
            }
        } else if systemVersion >= 14.0 {
            // 中等系统版本
            if device.userInterfaceIdiom == .pad {
                return 4
            } else {
                return 3
            }
        } else {
            // 较旧的系统
            return 2
        }
    }
    
    /// 获取最佳并发操作数
    /// - Returns: 最佳并发操作数
    private func getOptimalConcurrentOperations() -> Int {
        let baseCount = PreRenderingConstants.baseMaxConcurrentOperations
        return baseCount + (devicePerformanceLevel - 1) / 2
    }
    
    /// 获取最佳预渲染数量
    /// - Returns: 最佳预渲染数量
    private func getOptimalPreRenderCount() -> Int {
        let baseCount = PreRenderingConstants.basePreRenderCount
        return baseCount + (devicePerformanceLevel - 1)
    }
    
    /// 预渲染指定范围内的 cell
    /// - Parameter indexPaths: 索引路径数组
    func preRenderCells(at indexPaths: [IndexPath]) {
        indexPaths.forEach { preRenderCell(at: $0) }
    }
    
    /// 预渲染当前可见区域附近的 cell
    func preRenderVisibleCells() {
        guard enablePreRendering else { return }
        
        let visibleIndexPaths = indexPathsForVisibleRows ?? []
        var preRenderIndexPaths: [IndexPath] = []
        
        // 预渲染当前可见 cell 的前后几个 cell
        let preRenderCount = getOptimalPreRenderCount()
        
        for indexPath in visibleIndexPaths {
            // 预渲染当前 cell
            preRenderIndexPaths.append(indexPath)
            
            // 预渲染下几个 cell
            for i in 1...preRenderCount {
                let nextIndexPath = IndexPath(row: indexPath.row + i, section: indexPath.section)
                if nextIndexPath.row < numberOfRows(inSection: nextIndexPath.section) {
                    preRenderIndexPaths.append(nextIndexPath)
                }
            }
            
            // 预渲染上几个 cell
            for i in 1...preRenderCount {
                let prevIndexPath = IndexPath(row: indexPath.row - i, section: indexPath.section)
                if prevIndexPath.row >= 0 {
                    preRenderIndexPaths.append(prevIndexPath)
                }
            }
        }
        
        // 去重并预渲染
        let uniqueIndexPaths = Array(Set(preRenderIndexPaths))
        preRenderCells(at: uniqueIndexPaths)
    }
    
    /// 获取预渲染的 cell
    /// - Parameter indexPath: 索引路径
    /// - Returns: 预渲染的 cell，如果不存在则返回 nil
    func getPreRenderedCell(at indexPath: IndexPath) -> UITableViewCell? {
        preRenderLock.lock()
        defer { preRenderLock.unlock() }
        
        return preRenderedCells.removeValue(forKey: indexPath)
    }
    
    /// 清理预渲染缓存
    func clearPreRenderCache() {
        preRenderLock.lock()
        defer { preRenderLock.unlock() }
        
        preRenderedCells.removeAll()
        preRenderQueue.cancelAllOperations()
    }
    
    /// 处理滚动事件，触发预渲染
    /// - Parameter scrollView: 滚动视图
    func handleScrollForPreRendering(_ scrollView: UIScrollView) {
        guard enablePreRendering else { return }
        
        // 当滚动停止或减速时，预渲染可见区域附近的 cell
        if !isDragging && !isDecelerating {
            preRenderVisibleCells()
        }
    }
}

/// 扩展 HFlowViewDelegate，添加预渲染相关方法
extension HFlowViewDelegate {
    /// 当 cell 预渲染完成时调用
    /// - Parameters:
    ///   - cell: 预渲染完成的 cell
    ///   - indexPath: 索引路径
    func didPreRenderCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        // 默认实现为空
    }
}
