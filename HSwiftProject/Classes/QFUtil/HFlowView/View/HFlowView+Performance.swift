//
//  HFlowView+Performance.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import CoreGraphics

/// 性能监控配置
struct HFlowPerformanceMonitorConfig {
    /// 是否启用滚动帧率监控
    var enableFrameRateMonitor = true
    
    /// 是否启用内存使用监控
    var enableMemoryMonitor = true
    
    /// 是否启用网络请求监控
    var enableNetworkMonitor = true
    
    /// 是否启用缓存监控
    var enableCacheMonitor = true
    
    /// 是否启用预渲染监控
    var enablePreRenderMonitor = true
    
    /// 是否启用对象池监控
    var enableObjectPoolMonitor = true
    
    /// 性能数据更新间隔（秒）
    var updateInterval: TimeInterval = 1.0
    
    /// 默认配置
    static let `default` = HFlowPerformanceMonitorConfig()
}

/// 性能统计信息
struct HFlowPerformanceStatistics {
    /// 滚动帧率
    var frameRate: Double
    
    /// 内存使用量（MB）
    var memoryUsage: Double
    
    /// 平均内存使用量（MB）
    var averageMemoryUsage: Double
    
    /// 内存使用趋势（正值表示上升，负值表示下降）
    var memoryUsageTrend: Double
    
    /// 内存警告次数
    var memoryWarningCount: Int
    
    /// 网络请求平均耗时（毫秒）
    var averageNetworkRequestTime: Double
    
    /// 缓存命中率
    var cacheHitRate: Double
    
    /// 预渲染成功率
    var preRenderSuccessRate: Double
    
    /// 对象池命中率
    var objectPoolHitRate: Double
}

/// 性能优化建议
struct HFlowPerformanceOptimizationSuggestion {
    /// 建议类型
    enum SuggestionType {
        case frameRate
        case memory
        case network
        case cache
        case preRender
        case objectPool
        case general
    }
    
    /// 建议类型
    let type: SuggestionType
    
    /// 建议内容
    let message: String
    
    /// 严重程度（0-10，10 最严重）
    let severity: Int
    
    /// 是否可以自动优化
    let canAutoOptimize: Bool
    
    /// 自动优化闭包
    let autoOptimizeAction: (() -> Void)?
}

/// 性能优化建议生成器
class HFlowPerformanceOptimizationSuggestionGenerator {
    /// 生成性能优化建议
    /// - Parameter statistics: 性能统计数据
    /// - Returns: 优化建议数组
    static func generateSuggestions(from statistics: HFlowPerformanceStatistics, for flowView: HFlowView) -> [HFlowPerformanceOptimizationSuggestion] {
        var suggestions: [HFlowPerformanceOptimizationSuggestion] = []
        
        // 帧率建议
        if statistics.frameRate < 50 {
            suggestions.append(HFlowPerformanceOptimizationSuggestion(
                type: .frameRate,
                message: "帧率较低（\(String(format: "%.1f", statistics.frameRate)) FPS），建议减少复杂的 UI 操作和动画",
                severity: 8,
                canAutoOptimize: true,
                autoOptimizeAction: {
                    DispatchQueue.main.async {
                        flowView.enableAnimations = false
                    }
                }
            ))
        }
        
        // 内存使用建议
        if statistics.memoryUsage > 100 {
            suggestions.append(HFlowPerformanceOptimizationSuggestion(
                type: .memory,
                message: "内存使用较高（\(String(format: "%.1f", statistics.memoryUsage)) MB），建议优化图片加载和缓存策略",
                severity: 7,
                canAutoOptimize: true,
                autoOptimizeAction: {
                    // 可以添加自动清理缓存的逻辑
                }
            ))
        }
        
        // 网络请求建议
        if statistics.averageNetworkRequestTime > 500 {
            suggestions.append(HFlowPerformanceOptimizationSuggestion(
                type: .network,
                message: "网络请求耗时较长（\(String(format: "%.1f", statistics.averageNetworkRequestTime)) ms），建议优化网络请求和使用缓存",
                severity: 6,
                canAutoOptimize: false,
                autoOptimizeAction: nil
            ))
        }
        
        // 缓存命中率建议
        if statistics.cacheHitRate < 0.5 {
            suggestions.append(HFlowPerformanceOptimizationSuggestion(
                type: .cache,
                message: "缓存命中率较低（\(String(format: "%.1f%%", statistics.cacheHitRate * 100))），建议优化缓存策略",
                severity: 5,
                canAutoOptimize: true,
                autoOptimizeAction: {
                    // 可以添加自动调整缓存策略的逻辑
                }
            ))
        }
        
        // 预渲染建议
        if statistics.preRenderSuccessRate < 0.7 {
            suggestions.append(HFlowPerformanceOptimizationSuggestion(
                type: .preRender,
                message: "预渲染成功率较低（\(String(format: "%.1f%%", statistics.preRenderSuccessRate * 100))），建议调整预渲染策略",
                severity: 4,
                canAutoOptimize: true,
                autoOptimizeAction: {
                    // 可以添加自动调整预渲染策略的逻辑
                }
            ))
        }
        
        // 对象池建议
        if statistics.objectPoolHitRate < 0.6 {
            suggestions.append(HFlowPerformanceOptimizationSuggestion(
                type: .objectPool,
                message: "对象池命中率较低（\(String(format: "%.1f%%", statistics.objectPoolHitRate * 100))），建议调整对象池大小",
                severity: 3,
                canAutoOptimize: true,
                autoOptimizeAction: {
                    // 可以添加自动调整对象池大小的逻辑
                }
            ))
        }
        
        return suggestions
    }
}

/// 环形缓冲区，用于高效存储和计算样本数据
class HFlowCircularBuffer<T> {
    private var buffer: [T?]
    private var head: Int = 0
    private var count: Int = 0
    private let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.buffer = Array(repeating: nil, count: capacity)
    }

    func append(_ value: T) {
        buffer[head] = value
        head = (head + 1) % capacity
        if count < capacity {
            count += 1
        }
    }

    func forEach(_ body: (T) -> Void) {
        for i in 0..<count {
            let index = (head - count + i + capacity) % capacity
            if let value = buffer[index] {
                body(value)
            }
        }
    }

    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, T) -> Result) -> Result {
        var result = initialResult
        forEach { result = nextPartialResult(result, $0) }
        return result
    }

    var isEmpty: Bool { count == 0 }

    func reset() {
        head = 0
        count = 0
    }
}

/// 滚动帧率监控
class HFlowFrameRateMonitor {
    /// 帧率样本
    private var frameRateSamples: HFlowCircularBuffer<Double>
    
    /// 最大样本数
    private let maxSamples = 60
    
    /// 上一帧时间
    private var lastFrameTime: CFTimeInterval = 0
    
    init() {
        self.frameRateSamples = HFlowCircularBuffer<Double>(capacity: maxSamples)
    }
    
    /// 添加帧率样本
    /// - Parameter timestamp: 时间戳
    func addFrameSample(timestamp: CFTimeInterval) {
        if lastFrameTime > 0 {
            let frameTime = timestamp - lastFrameTime
            let frameRate = 1.0 / frameTime
            frameRateSamples.append(frameRate)
        }
        lastFrameTime = timestamp
    }
    
    /// 获取平均帧率
    /// - Returns: 平均帧率
    func getAverageFrameRate() -> Double {
        if frameRateSamples.isEmpty {
            return 0
        }
        let sum = frameRateSamples.reduce(0, +)
        return sum / Double(frameRateSamples.reduce(0) { count, _ in count + 1 })
    }
    
    /// 重置监控
    func reset() {
        frameRateSamples.reset()
        lastFrameTime = 0
    }
}

/// 内存使用监控
class HFlowMemoryMonitor {
    /// 内存使用样本
    private var memoryUsageSamples: HFlowCircularBuffer<Double>
    
    /// 最大样本数
    private let maxSamples = 30
    
    /// 内存警告状态
    private var memoryWarningCount = 0
    
    /// 上次内存警告时间
    private var lastMemoryWarningTime: Date?
    
    init() {
        self.memoryUsageSamples = HFlowCircularBuffer<Double>(capacity: maxSamples)
        
        // 注册内存警告通知
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleMemoryWarning()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 处理内存警告
    private func handleMemoryWarning() {
        memoryWarningCount += 1
        lastMemoryWarningTime = Date()
    }
    
    /// 获取当前内存使用量
    /// - Returns: 内存使用量（MB）
    func getCurrentMemoryUsage() -> Double {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<natural_t>.size)
        let kerr = withUnsafeMutablePointer(to: &taskInfo) { pointer in
            return pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMemory = taskInfo.resident_size
            let memoryUsageMB = Double(usedMemory) / (1024 * 1024) // 转换为MB
            
            // 添加到样本
            memoryUsageSamples.append(memoryUsageMB)
            
            return memoryUsageMB
        }
        
        return 0
    }
    
    /// 获取平均内存使用量
    /// - Returns: 平均内存使用量（MB）
    func getAverageMemoryUsage() -> Double {
        if memoryUsageSamples.isEmpty {
            return 0
        }
        let sum = memoryUsageSamples.reduce(0, +)
        return sum / Double(memoryUsageSamples.reduce(0) { count, _ in count + 1 })
    }
    
    /// 获取内存使用趋势
    /// - Returns: 内存使用趋势（正值表示上升，负值表示下降）
    func getMemoryUsageTrend() -> Double {
        if memoryUsageSamples.reduce(0, { count, _ in count + 1 }) < 2 {
            return 0
        }
        
        var sum: Double = 0
        var previousValue: Double?
        
        memoryUsageSamples.forEach { value in
            if let prev = previousValue {
                sum += value - prev
            }
            previousValue = value
        }
        
        let sampleCount = Double(memoryUsageSamples.reduce(0) { count, _ in count + 1 } - 1)
        return sum / sampleCount
    }
    
    /// 获取内存警告次数
    /// - Returns: 内存警告次数
    func getMemoryWarningCount() -> Int {
        return memoryWarningCount
    }
    
    /// 获取上次内存警告时间
    /// - Returns: 上次内存警告时间
    func getLastMemoryWarningTime() -> Date? {
        return lastMemoryWarningTime
    }
    
    /// 重置监控
    func reset() {
        memoryUsageSamples.reset()
        memoryWarningCount = 0
        lastMemoryWarningTime = nil
    }
}

/// 网络请求监控
class HFlowNetworkMonitor {
    /// 请求耗时样本
    private var requestTimeSamples: HFlowCircularBuffer<Double>
    
    /// 最大样本数
    private let maxSamples = 100
    
    init() {
        self.requestTimeSamples = HFlowCircularBuffer<Double>(capacity: maxSamples)
    }
    
    /// 添加请求耗时样本
    /// - Parameter time: 耗时（毫秒）
    func addRequestTimeSample(_ time: Double) {
        requestTimeSamples.append(time)
    }
    
    /// 获取平均请求耗时
    /// - Returns: 平均请求耗时（毫秒）
    func getAverageRequestTime() -> Double {
        if requestTimeSamples.isEmpty {
            return 0
        }
        let sum = requestTimeSamples.reduce(0, +)
        return sum / Double(requestTimeSamples.reduce(0) { count, _ in count + 1 })
    }
    
    /// 重置监控
    func reset() {
        requestTimeSamples.reset()
    }
}

/// HFlowView 性能监控扩展
///
/// 为 HFlowView 提供性能监控和统计功能，帮助开发者了解 HFlowView 的性能情况
///
/// 实现功能：
/// 1. 滚动帧率监控
/// 2. 内存使用监控
/// 3. 网络请求耗时统计
/// 4. 缓存命中率统计
/// 5. 预渲染性能统计
/// 6. 对象池使用统计

// 关联对象的键
private var performanceMonitorConfigKey: UInt8 = 0
private var frameRateMonitorKey: UInt8 = 0
private var memoryMonitorKey: UInt8 = 0
private var networkMonitorKey: UInt8 = 0
private var performanceStatisticsKey: UInt8 = 0
private var performanceUpdateTimerKey: UInt8 = 0
private var preRenderStatsKey: UInt8 = 0
private var performanceLockKey: UInt8 = 0
private var poolUsageStatisticsKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Properties
    
    /// 性能监控配置
    public var performanceMonitorConfig: HFlowPerformanceMonitorConfig {
        get {
            if let config = objc_getAssociatedObject(self, &performanceMonitorConfigKey) as? HFlowPerformanceMonitorConfig {
                return config
            }
            return HFlowPerformanceMonitorConfig.default
        }
        set {
            objc_setAssociatedObject(self, &performanceMonitorConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 帧率监控
    private var frameRateMonitor: HFlowFrameRateMonitor {
        get {
            if let monitor = objc_getAssociatedObject(self, &frameRateMonitorKey) as? HFlowFrameRateMonitor {
                return monitor
            }
            let monitor = HFlowFrameRateMonitor()
            objc_setAssociatedObject(self, &frameRateMonitorKey, monitor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return monitor
        }
    }
    
    /// 内存监控
    private var memoryMonitor: HFlowMemoryMonitor {
        get {
            if let monitor = objc_getAssociatedObject(self, &memoryMonitorKey) as? HFlowMemoryMonitor {
                return monitor
            }
            let monitor = HFlowMemoryMonitor()
            objc_setAssociatedObject(self, &memoryMonitorKey, monitor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return monitor
        }
    }
    
    /// 网络监控
    private var networkMonitor: HFlowNetworkMonitor {
        get {
            if let monitor = objc_getAssociatedObject(self, &networkMonitorKey) as? HFlowNetworkMonitor {
                return monitor
            }
            let monitor = HFlowNetworkMonitor()
            objc_setAssociatedObject(self, &networkMonitorKey, monitor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return monitor
        }
    }
    
    /// 性能统计信息
    private var performanceStatistics: HFlowPerformanceStatistics {
        get {
            if let stats = objc_getAssociatedObject(self, &performanceStatisticsKey) as? HFlowPerformanceStatistics {
                return stats
            }
            let stats = HFlowPerformanceStatistics(
                frameRate: 0,
                memoryUsage: 0,
                averageMemoryUsage: 0,
                memoryUsageTrend: 0,
                memoryWarningCount: 0,
                averageNetworkRequestTime: 0,
                cacheHitRate: 0,
                preRenderSuccessRate: 0,
                objectPoolHitRate: 0
            )
            objc_setAssociatedObject(self, &performanceStatisticsKey, stats, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return stats
        }
        set {
            objc_setAssociatedObject(self, &performanceStatisticsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 性能数据更新定时器
    private var performanceUpdateTimer: Timer? {
        get {
            return objc_getAssociatedObject(self, &performanceUpdateTimerKey) as? Timer
        }
        set {
            objc_setAssociatedObject(self, &performanceUpdateTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 预渲染统计
    private var preRenderStats: (success: Int, total: Int) {
        get {
            if let stats = objc_getAssociatedObject(self, &preRenderStatsKey) as? (success: Int, total: Int) {
                return stats
            }
            return (success: 0, total: 0)
        }
        set {
            objc_setAssociatedObject(self, &preRenderStatsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 性能监控锁
    private var performanceLock: NSLock {
        get {
            if let lock = objc_getAssociatedObject(self, &performanceLockKey) as? NSLock {
                return lock
            }
            let lock = NSLock()
            objc_setAssociatedObject(self, &performanceLockKey, lock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return lock
        }
    }
    
    /// 对象池使用统计（与 ObjectPool 扩展共享同一关联对象存储）
    private var poolUsageStatistics: [String: (hitCount: Int, missCount: Int, createCount: Int)] {
        get {
            if let stats = objc_getAssociatedObject(self, &poolUsageStatisticsKey) as? [String: (hitCount: Int, missCount: Int, createCount: Int)] {
                return stats
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &poolUsageStatisticsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Performance Monitoring Methods
    
    /// 开始性能监控
    func startPerformanceMonitoring() {
        // 停止之前的监控
        stopPerformanceMonitoring()
        
        // 启动性能数据更新定时器
        performanceUpdateTimer = Timer.scheduledTimer(
            timeInterval: performanceMonitorConfig.updateInterval,
            target: self,
            selector: #selector(updatePerformanceStatistics),
            userInfo: nil,
            repeats: true
        )
        
        // 开始监控滚动帧率
        if performanceMonitorConfig.enableFrameRateMonitor {
            startFrameRateMonitoring()
        }
    }
    
    /// 停止性能监控
    func stopPerformanceMonitoring() {
        // 停止性能数据更新定时器
        performanceUpdateTimer?.invalidate()
        performanceUpdateTimer = nil
    }
    
    /// 开始帧率监控
    private func startFrameRateMonitoring() {
        // 通过 CADisplayLink 监控帧率
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTick))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .main, forMode: .common)
    }
    
    /// CADisplayLink 回调
    @objc private func displayLinkTick(_ displayLink: CADisplayLink) {
        frameRateMonitor.addFrameSample(timestamp: displayLink.timestamp)
    }
    
    /// 更新性能统计信息
    @objc private func updatePerformanceStatistics() {
        performanceLock.lock()
        defer { performanceLock.unlock() }
        
        // 更新帧率
        if performanceMonitorConfig.enableFrameRateMonitor {
            performanceStatistics.frameRate = frameRateMonitor.getAverageFrameRate()
        }
        
        // 更新内存使用
        if performanceMonitorConfig.enableMemoryMonitor {
            performanceStatistics.memoryUsage = memoryMonitor.getCurrentMemoryUsage()
            performanceStatistics.averageMemoryUsage = memoryMonitor.getAverageMemoryUsage()
            performanceStatistics.memoryUsageTrend = memoryMonitor.getMemoryUsageTrend()
            performanceStatistics.memoryWarningCount = memoryMonitor.getMemoryWarningCount()
        }
        
        // 更新网络请求耗时
        if performanceMonitorConfig.enableNetworkMonitor {
            performanceStatistics.averageNetworkRequestTime = networkMonitor.getAverageRequestTime()
        }
        
        // 更新缓存命中率
        if performanceMonitorConfig.enableCacheMonitor {
            let cacheStats = cacheManager.getCacheStatistics()
            performanceStatistics.cacheHitRate = cacheStats.hitRate
        }
        
        // 更新预渲染成功率
        if performanceMonitorConfig.enablePreRenderMonitor {
            let total = preRenderStats.total
            if total > 0 {
                performanceStatistics.preRenderSuccessRate = Double(preRenderStats.success) / Double(total)
            } else {
                performanceStatistics.preRenderSuccessRate = 0
            }
        }
        
        // 更新对象池命中率
        if performanceMonitorConfig.enableObjectPoolMonitor {
            let totalHitCount = poolUsageStatistics.values.reduce(0) { $0 + $1.hitCount }
            let totalMissCount = poolUsageStatistics.values.reduce(0) { $0 + $1.missCount }
            let total = totalHitCount + totalMissCount
            if total > 0 {
                performanceStatistics.objectPoolHitRate = Double(totalHitCount) / Double(total)
            } else {
                performanceStatistics.objectPoolHitRate = 0
            }
        }
        
        // 通知代理性能数据更新
        notifyPerformanceStatisticsUpdated(performanceStatistics)
    }
    
    /// 记录网络请求耗时
    /// - Parameter time: 耗时（毫秒）
    func recordNetworkRequestTime(_ time: Double) {
        networkMonitor.addRequestTimeSample(time)
    }
    
    /// 记录预渲染结果
    /// - Parameter success: 是否成功
    func recordPreRenderResult(_ success: Bool) {
        performanceLock.lock()
        defer { performanceLock.unlock() }
        
        preRenderStats.total += 1
        if success {
            preRenderStats.success += 1
        }
    }
    
    /// 获取当前性能统计信息
    /// - Returns: 性能统计信息
    func getPerformanceStatistics() -> HFlowPerformanceStatistics {
        performanceLock.lock()
        defer { performanceLock.unlock() }
        
        return performanceStatistics
    }
    
    /// 重置性能统计信息
    func resetPerformanceStatistics() {
        performanceLock.lock()
        defer { performanceLock.unlock() }
        
        frameRateMonitor.reset()
        networkMonitor.reset()
        memoryMonitor.reset()
        preRenderStats = (success: 0, total: 0)
        performanceStatistics = HFlowPerformanceStatistics(
            frameRate: 0,
            memoryUsage: 0,
            averageMemoryUsage: 0,
            memoryUsageTrend: 0,
            memoryWarningCount: 0,
            averageNetworkRequestTime: 0,
            cacheHitRate: 0,
            preRenderSuccessRate: 0,
            objectPoolHitRate: 0
        )
    }
    
    /// 获取性能优化建议
    /// - Returns: 优化建议数组
    func getPerformanceOptimizationSuggestions() -> [HFlowPerformanceOptimizationSuggestion] {
        performanceLock.lock()
        defer { performanceLock.unlock() }
        
        return HFlowPerformanceOptimizationSuggestionGenerator.generateSuggestions(from: performanceStatistics, for: self)
    }
    
    /// 应用所有可自动优化的建议
    func applyAutoOptimizations() {
        let suggestions = getPerformanceOptimizationSuggestions()
        suggestions.forEach { suggestion in
            if suggestion.canAutoOptimize, let action = suggestion.autoOptimizeAction {
                action()
            }
        }
    }
}

/// 扩展 HFlowViewDelegate，添加性能监控相关方法
extension HFlowViewDelegate {
    /// 当检测到性能问题时调用
    /// - Parameter issue: 性能问题描述
    func performanceIssueDetected(_ issue: String) {
        // 默认实现为空
    }
}
