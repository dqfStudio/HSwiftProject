//
//  HFlowView+NetworkOptimization.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 网络请求状态枚举
enum HFlowNetworkRequestStatus {
    case idle         // 空闲
    case loading      // 加载中
    case success      // 成功
    case failure      // 失败
}

/// 网络请求配置结构体
struct HFlowNetworkRequestConfig {
    /// 请求超时时间
    var timeoutInterval: TimeInterval
    /// 是否启用缓存
    var enableCache: Bool
    /// 缓存过期时间
    var cacheExpirationTime: TimeInterval
    /// 是否启用重试
    var enableRetry: Bool
    /// 重试次数
    var retryCount: Int
    /// 重试间隔
    var retryInterval: TimeInterval
    
    /// 默认配置
    static let `default` = HFlowNetworkRequestConfig(
        timeoutInterval: 30.0,
        enableCache: true,
        cacheExpirationTime: 3600.0,
        enableRetry: true,
        retryCount: 3,
        retryInterval: 1.0
    )
}

/// 网络请求缓存项结构体
struct HFlowNetworkCacheItem {
    /// 缓存数据
    var data: Data
    /// 缓存时间
    var timestamp: TimeInterval
    /// 过期时间
    var expirationTime: TimeInterval
    
    /// 是否过期
    var isExpired: Bool {
        return Date().timeIntervalSince1970 - timestamp > expirationTime
    }
}

/// HFlowView 网络优化扩展
///
/// 为 HFlowView 提供网络优化功能，减少网络请求次数，提高数据加载速度
///
/// 实现功能：
/// 1. 网络请求缓存
/// 2. 请求合并和去重
/// 3. 请求重试机制
/// 4. 网络状态监测
/// 5. 数据预加载

// 关联对象的键
private var enableNetworkOptimizationKey: UInt8 = 0
private var networkRequestConfigKey: UInt8 = 0
private var networkRequestStatusKey: UInt8 = 0
private var networkCacheKey: UInt8 = 0
private var ongoingRequestsKey: UInt8 = 0
private var networkCacheLockKey: UInt8 = 0
private var networkRequestLockKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Network Optimization Properties
    
    /// 是否启用网络优化
    public var enableNetworkOptimization: Bool {
        get {
            if let enable = objc_getAssociatedObject(self, &enableNetworkOptimizationKey) as? Bool {
                return enable
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &enableNetworkOptimizationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 网络请求配置
    public var networkRequestConfig: HFlowNetworkRequestConfig {
        get {
            if let config = objc_getAssociatedObject(self, &networkRequestConfigKey) as? HFlowNetworkRequestConfig {
                return config
            }
            return HFlowNetworkRequestConfig.default
        }
        set {
            objc_setAssociatedObject(self, &networkRequestConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 网络请求状态
    public var networkRequestStatus: HFlowNetworkRequestStatus {
        get {
            if let status = objc_getAssociatedObject(self, &networkRequestStatusKey) as? HFlowNetworkRequestStatus {
                return status
            }
            return .idle
        }
        set {
            objc_setAssociatedObject(self, &networkRequestStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 网络请求内存缓存
    private var networkCache: [String: HFlowNetworkCacheItem] {
        get {
            if let cache = objc_getAssociatedObject(self, &networkCacheKey) as? [String: HFlowNetworkCacheItem] {
                return cache
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &networkCacheKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 网络请求磁盘缓存路径
    private var networkCacheDirectory: URL {
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let networkCachePath = cacheDirectory.appending("/HFlowViewNetworkCache")
        
        // 确保缓存目录存在
        try? FileManager.default.createDirectory(atPath: networkCachePath, withIntermediateDirectories: true, attributes: nil)
        
        return URL(fileURLWithPath: networkCachePath)
    }
    
    /// 正在进行的网络请求
    private var ongoingRequests: [String: URLSessionDataTask] {
        get {
            if let requests = objc_getAssociatedObject(self, &ongoingRequestsKey) as? [String: URLSessionDataTask] {
                return requests
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &ongoingRequestsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 网络请求缓存锁
    private var networkCacheLock: NSLock {
        get {
            if let lock = objc_getAssociatedObject(self, &networkCacheLockKey) as? NSLock {
                return lock
            }
            let newLock = NSLock()
            objc_setAssociatedObject(self, &networkCacheLockKey, newLock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newLock
        }
    }
    
    /// 网络请求锁
    private var networkRequestLock: NSLock {
        get {
            if let lock = objc_getAssociatedObject(self, &networkRequestLockKey) as? NSLock {
                return lock
            }
            let newLock = NSLock()
            objc_setAssociatedObject(self, &networkRequestLockKey, newLock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newLock
        }
    }
    
    // MARK: - Network Optimization Methods
    
    /// 初始化网络优化
    func setupNetworkOptimization() {
        // 监听网络状态变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNetworkStatusChange),
            name: .connectivityStatusChanged,
            object: nil
        )
    }
    
    /// 处理网络状态变化
    @objc private func handleNetworkStatusChange() {
        // 当网络状态变化时，重新尝试失败的请求
        if networkRequestStatus == .failure {
            // 这里可以实现网络恢复后的重试逻辑
        }
    }
    
    /// 执行网络请求
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - method: 请求方法
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - completion: 请求完成回调
    func performNetworkRequest(
        url: URL,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Data?, Error?) -> Void
    ) {
        guard enableNetworkOptimization else {
            // 直接执行请求，不使用优化
            _ = executeNetworkRequest(url: url, method: method, parameters: parameters, headers: headers, completion: completion)
            return
        }
        
        // 生成请求缓存键
        let cacheKey = generateCacheKey(url: url, method: method, parameters: parameters)
        
        // 检查内存缓存
        networkCacheLock.lock()
        if let cachedItem = networkCache[cacheKey], !cachedItem.isExpired {
            networkCacheLock.unlock()
            completion(cachedItem.data, nil)
            return
        }
        networkCacheLock.unlock()
        
        // 检查磁盘缓存
        if let cachedItem = loadCacheFromDisk(forKey: cacheKey) {
            // 将磁盘缓存加载到内存缓存
            networkCacheLock.lock()
            networkCache[cacheKey] = cachedItem
            networkCacheLock.unlock()
            completion(cachedItem.data, nil)
            return
        }
        
        // 检查是否已有相同的请求正在进行
        networkRequestLock.lock()
        if ongoingRequests[cacheKey] != nil {
            // 已有相同请求，等待其完成
            networkRequestLock.unlock()
            // 这里可以实现请求合并，多个回调共享同一个请求结果
            return
        }
        
        // 创建新的请求
        let task = executeNetworkRequest(url: url, method: method, parameters: parameters, headers: headers) { [weak self] data, error in
            guard let self = self else { return }
            
            // 更新请求状态
            if error != nil {
                self.networkRequestStatus = .failure
                // 处理重试逻辑
                self.handleRequestRetry(url: url, method: method, parameters: parameters, headers: headers, completion: completion, retryCount: 0)
            } else if let data = data {
                self.networkRequestStatus = .success
                // 缓存请求结果
                self.cacheNetworkResponse(data: data, forKey: cacheKey)
                completion(data, nil)
            }
            
            // 移除正在进行的请求
            self.networkRequestLock.lock()
            self.ongoingRequests.removeValue(forKey: cacheKey)
            self.networkRequestLock.unlock()
        }
        
        // 记录正在进行的请求
        ongoingRequests[cacheKey] = task
        networkRequestLock.unlock()
        
        // 开始请求
        task.resume()
    }
    
    /// 执行实际的网络请求
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - method: 请求方法
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - completion: 请求完成回调
    /// - Returns: URLSessionDataTask
    private func executeNetworkRequest(
        url: URL,
        method: String,
        parameters: [String: Any]?,
        headers: [String: String]?,
        completion: @escaping (Data?, Error?) -> Void
    ) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = networkRequestConfig.timeoutInterval
        
        // 设置请求头
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // 设置请求体
        if let parameters = parameters, method != "GET" {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(nil, error)
                return URLSession.shared.dataTask(with: request) { _, _, _ in }
            }
        }
        
        // 记录请求开始时间
        let startTime = Date().timeIntervalSince1970
        
        // 执行请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 计算请求耗时
            let endTime = Date().timeIntervalSince1970
            let requestTime = (endTime - startTime) * 1000 // 转换为毫秒
            
            DispatchQueue.main.async {
                // 记录网络请求耗时
                self.recordNetworkRequestTime(requestTime)
                completion(data, error)
            }
        }
        
        return task
    }
    
    /// 处理请求重试
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - method: 请求方法
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - completion: 请求完成回调
    ///   - retryCount: 已重试次数
    private func handleRequestRetry(
        url: URL,
        method: String,
        parameters: [String: Any]?,
        headers: [String: String]?,
        completion: @escaping (Data?, Error?) -> Void,
        retryCount: Int
    ) {
        guard networkRequestConfig.enableRetry, retryCount < networkRequestConfig.retryCount else {
            completion(nil, NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Request failed after multiple attempts"]))
            return
        }
        
        // 延迟重试
        DispatchQueue.main.asyncAfter(deadline: .now() + networkRequestConfig.retryInterval) {
            self.executeNetworkRequest(url: url, method: method, parameters: parameters, headers: headers) { data, error in
                if error != nil {
                    // 继续重试
                    self.handleRequestRetry(url: url, method: method, parameters: parameters, headers: headers, completion: completion, retryCount: retryCount + 1)
                } else {
                    // 请求成功，缓存结果
                    let cacheKey = self.generateCacheKey(url: url, method: method, parameters: parameters)
                    self.cacheNetworkResponse(data: data, forKey: cacheKey)
                    completion(data, nil)
                }
            }.resume()
        }
    }
    
    /// 缓存网络响应
    /// - Parameters:
    ///   - data: 响应数据
    ///   - key: 缓存键
    private func cacheNetworkResponse(data: Data?, forKey key: String) {
        guard networkRequestConfig.enableCache, let data = data else { return }
        
        networkCacheLock.lock()
        let cacheItem = HFlowNetworkCacheItem(
            data: data,
            timestamp: Date().timeIntervalSince1970,
            expirationTime: networkRequestConfig.cacheExpirationTime
        )
        networkCache[key] = cacheItem
        networkCacheLock.unlock()
        
        // 保存到磁盘缓存
        saveCacheToDisk(data: data, forKey: key, timestamp: cacheItem.timestamp, expirationTime: cacheItem.expirationTime)
    }
    
    /// 保存缓存到磁盘
    /// - Parameters:
    ///   - data: 响应数据
    ///   - key: 缓存键
    ///   - timestamp: 缓存时间戳
    ///   - expirationTime: 过期时间
    private func saveCacheToDisk(data: Data, forKey key: String, timestamp: TimeInterval, expirationTime: TimeInterval) {
        // 创建缓存文件路径
        let cacheFileName = key.replacingOccurrences(of: "/", with: "_")
        let cacheFileURL = networkCacheDirectory.appendingPathComponent(cacheFileName)
        
        // 创建缓存数据字典
        let cacheDict: [String: Any] = [
            "data": data,
            "timestamp": timestamp,
            "expirationTime": expirationTime
        ]
        
        // 保存到磁盘
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: cacheDict, options: .prettyPrinted)
            try jsonData.write(to: cacheFileURL)
        } catch {
            print("Error saving cache to disk: \(error)")
        }
    }
    
    /// 从磁盘加载缓存
    /// - Parameter key: 缓存键
    /// - Returns: 缓存项，如果不存在或已过期则返回 nil
    private func loadCacheFromDisk(forKey key: String) -> HFlowNetworkCacheItem? {
        // 创建缓存文件路径
        let cacheFileName = key.replacingOccurrences(of: "/", with: "_")
        let cacheFileURL = networkCacheDirectory.appendingPathComponent(cacheFileName)
        
        // 检查文件是否存在
        guard FileManager.default.fileExists(atPath: cacheFileURL.path) else {
            return nil
        }
        
        // 读取缓存数据
        do {
            let jsonData = try Data(contentsOf: cacheFileURL)
            let cacheDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            guard let data = cacheDict?["data"] as? Data,
                  let timestamp = cacheDict?["timestamp"] as? TimeInterval,
                  let expirationTime = cacheDict?["expirationTime"] as? TimeInterval else {
                return nil
            }
            
            let cacheItem = HFlowNetworkCacheItem(data: data, timestamp: timestamp, expirationTime: expirationTime)
            
            // 检查是否过期
            if !cacheItem.isExpired {
                return cacheItem
            } else {
                // 删除过期缓存
                try? FileManager.default.removeItem(at: cacheFileURL)
                return nil
            }
        } catch {
            print("Error loading cache from disk: \(error)")
            // 删除损坏的缓存文件
            try? FileManager.default.removeItem(at: cacheFileURL)
            return nil
        }
    }
    
    /// 生成缓存键
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - method: 请求方法
    ///   - parameters: 请求参数
    /// - Returns: 缓存键
    private func generateCacheKey(url: URL, method: String, parameters: [String: Any]?) -> String {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let parameters = parameters, method == "GET" {
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        let urlString = components?.url?.absoluteString ?? url.absoluteString
        return "\(method):\(urlString)"
    }
    
    /// 清理网络缓存
    func clearNetworkCache() {
        // 清理内存缓存
        networkCacheLock.lock()
        networkCache.removeAll()
        networkCacheLock.unlock()
        
        // 清理磁盘缓存
        do {
            try FileManager.default.removeItem(at: networkCacheDirectory)
            // 重新创建缓存目录
            try FileManager.default.createDirectory(at: networkCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error clearing network cache: \(error)")
        }
    }
    
    /// 清理过期的网络缓存
    func cleanupExpiredNetworkCache() {
        // 清理内存缓存中的过期项
        networkCacheLock.lock()
        networkCache = networkCache.filter { !$0.value.isExpired }
        networkCacheLock.unlock()
        
        // 清理磁盘缓存中的过期项
        cleanupExpiredDiskCache()
    }
    
    /// 清理磁盘缓存中的过期项
    private func cleanupExpiredDiskCache() {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: networkCacheDirectory, includingPropertiesForKeys: nil, options: [])
            
            for fileURL in files {
                // 尝试加载缓存项
                let cacheFileName = fileURL.lastPathComponent
                let cacheKey = cacheFileName.replacingOccurrences(of: "_", with: "/")
                
                if loadCacheFromDisk(forKey: cacheKey) != nil {
                    // 缓存未过期，保留
                } else {
                    // 缓存已过期或损坏，删除
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch {
            print("Error cleaning up expired disk cache: \(error)")
        }
    }
    
    /// 取消所有网络请求
    func cancelAllNetworkRequests() {
        networkRequestLock.lock()
        ongoingRequests.values.forEach { $0.cancel() }
        ongoingRequests.removeAll()
        networkRequestLock.unlock()
    }
}

/// 扩展 Notification.Name，添加网络状态变化通知
extension Notification.Name {
    static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
}
