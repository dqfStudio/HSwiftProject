//
//  HCollView+NetworkOptimization.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import Alamofire

/// HCollView 网络优化扩展
///
/// 提供网络请求优化、离线模式支持和网络状态适应等功能
extension HCollView {
    
    /// 网络优化管理器
    class NetworkOptimizationManager {
        
        // MARK: - 单例
        static let shared = NetworkOptimizationManager()
        
        // MARK: - 属性
        
        /// 网络请求队列
        private let requestQueue = DispatchQueue(label: "com.hcollview.network", qos: .userInitiated, attributes: .concurrent)
        
        /// 进行中的请求
        private var pendingRequests: [String: DataRequest] = [:]
        
        /// 请求缓存
        private var requestCache: [String: Data] = [:]
        
        /// 网络状态
        private var networkStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
        
        /// 网络状态管理器
        private let reachabilityManager = NetworkReachabilityManager()
        
        /// 是否启用离线模式
        var offlineModeEnabled: Bool = true
        
        /// 是否启用网络状态适应
        var networkStateAdaptationEnabled: Bool = true
        
        // MARK: - 初始化
        
        /// 初始化
        private init() {
            startNetworkMonitoring()
        }
        
        // MARK: - 方法
        
        /// 开始网络监控
        private func startNetworkMonitoring() {
            reachabilityManager?.startListening {
                [weak self] status in
                self?.networkStatus = status
                
                // 通知网络状态变化
                NotificationCenter.default.post(name: .HCollViewNetworkStatusChanged, object: status)
            }
        }
        
        /// 停止网络监控
        func stopNetworkMonitoring() {
            reachabilityManager?.stopListening()
        }
        
        /// 获取网络状态
        /// - Returns: 网络状态
        func getNetworkStatus() -> NetworkReachabilityManager.NetworkReachabilityStatus {
            return networkStatus
        }
        
        /// 是否有网络连接
        /// - Returns: 是否有网络连接
        func isNetworkAvailable() -> Bool {
            return reachabilityManager?.isReachable ?? false
        }
        
        /// 是否是 Wi-Fi 连接
        /// - Returns: 是否是 Wi-Fi 连接
        func isWiFi() -> Bool {
            guard let reachabilityManager = reachabilityManager else { return false }
            if case .reachable(.ethernetOrWiFi) = reachabilityManager.status {
                return true
            }
            return false
        }
        
        /// 是否是移动网络连接
        /// - Returns: 是否是移动网络连接
        func isCellular() -> Bool {
            guard let reachabilityManager = reachabilityManager else { return false }
            if case .reachable(.cellular) = reachabilityManager.status {
                return true
            }
            return false
        }
        
        /// 发送请求
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - method: 请求方法
        ///   - parameters: 请求参数
        ///   - headers: 请求头
        ///   - cachePolicy: 缓存策略
        ///   - completion: 完成回调
        func request(
            _ url: String,
            method: HTTPMethod = .get,
            parameters: [String: Any]? = nil,
            headers: HTTPHeaders? = nil,
            cachePolicy: CachePolicy = .useCacheElseLoad,
            completion: @escaping (Data?, Error?) -> Void
        ) {
            let requestKey = generateRequestKey(url: url, method: method, parameters: parameters)
            
            // 检查是否有相同的请求正在进行
            if let pendingRequest = pendingRequests[requestKey] {
                // 取消之前的请求
                pendingRequest.cancel()
            }
            
            // 检查缓存
            if cachePolicy != .reloadIgnoringCacheData {
                if let cachedData = requestCache[requestKey] {
                    completion(cachedData, nil)
                    return
                }
            }
            
            // 检查网络状态
            if !isNetworkAvailable() {
                // 网络不可用，尝试从缓存获取
                if offlineModeEnabled && cachePolicy == .returnCacheDataElseLoad {
                    if let cachedData = requestCache[requestKey] {
                        completion(cachedData, nil)
                        return
                    }
                }
                
                completion(nil, NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "网络连接不可用"]))
                return
            }
            
            // 根据网络状态调整请求策略
            if networkStateAdaptationEnabled {
                adjustRequestForNetworkState(url: url, method: method, parameters: parameters, headers: headers) { 
                    [weak self] adjustedUrl, adjustedMethod, adjustedParameters, adjustedHeaders in
                    
                    self?.sendRequest(
                        adjustedUrl,
                        method: adjustedMethod,
                        parameters: adjustedParameters,
                        headers: adjustedHeaders,
                        requestKey: requestKey,
                        cachePolicy: cachePolicy,
                        completion: completion
                    )
                }
            } else {
                sendRequest(
                    url,
                    method: method,
                    parameters: parameters,
                    headers: headers,
                    requestKey: requestKey,
                    cachePolicy: cachePolicy,
                    completion: completion
                )
            }
        }
        
        /// 发送请求
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - method: 请求方法
        ///   - parameters: 请求参数
        ///   - headers: 请求头
        ///   - requestKey: 请求键
        ///   - cachePolicy: 缓存策略
        ///   - completion: 完成回调
        private func sendRequest(
            _ url: String,
            method: HTTPMethod = .get,
            parameters: [String: Any]? = nil,
            headers: HTTPHeaders? = nil,
            requestKey: String,
            cachePolicy: CachePolicy,
            completion: @escaping (Data?, Error?) -> Void
        ) {
            // 创建请求
            let request = AF.request(url, method: method, parameters: parameters, headers: headers)
            pendingRequests[requestKey] = request
            
            // 发送请求
            request.responseData(queue: requestQueue) { [weak self] response in
                guard let self = self else { return }
                
                // 从进行中请求中移除
                self.pendingRequests.removeValue(forKey: requestKey)
                
                switch response.result {
                case .success(let data):
                    // 缓存数据
                    if cachePolicy != .reloadIgnoringCacheData {
                        self.requestCache[requestKey] = data
                    }
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
        
        /// 根据网络状态调整请求
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - method: 请求方法
        ///   - parameters: 请求参数
        ///   - headers: 请求头
        ///   - completion: 完成回调
        private func adjustRequestForNetworkState(
            url: String,
            method: HTTPMethod,
            parameters: [String: Any]?,
            headers: HTTPHeaders?,
            completion: @escaping (String, HTTPMethod, [String: Any]?, HTTPHeaders?) -> Void
        ) {
            var adjustedUrl = url
            var adjustedMethod = method
            var adjustedParameters = parameters
            var adjustedHeaders = headers
            
            // 根据网络状态调整请求
            if isCellular() {
                // 移动网络，使用低质量图片
                adjustedUrl = adjustUrlForCellular(url)
            }
            
            completion(adjustedUrl, adjustedMethod, adjustedParameters, adjustedHeaders)
        }
        
        /// 为移动网络调整 URL
        /// - Parameter url: 原始 URL
        /// - Returns: 调整后的 URL
        private func adjustUrlForCellular(_ url: String) -> String {
            // 这里可以根据实际情况调整 URL，例如添加低质量参数
            return url
        }
        
        /// 取消请求
        /// - Parameter url: 请求 URL
        func cancelRequest(_ url: String) {
            for (key, request) in pendingRequests where key.contains(url) {
                request.cancel()
                pendingRequests.removeValue(forKey: key)
            }
        }
        
        /// 取消所有请求
        func cancelAllRequests() {
            for (_, request) in pendingRequests {
                request.cancel()
            }
            pendingRequests.removeAll()
        }
        
        /// 清除缓存
        func clearCache() {
            requestCache.removeAll()
        }
        
        /// 生成请求键
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - method: 请求方法
        ///   - parameters: 请求参数
        /// - Returns: 请求键
        private func generateRequestKey(url: String, method: HTTPMethod, parameters: [String: Any]?) -> String {
            var key = "\(method.rawValue):\(url)"
            
            if let parameters = parameters, !parameters.isEmpty {
                let paramsString = parameters.map { "\($0.key)=\($0.value)" }.sorted().joined(separator: "&")
                key += "?\(paramsString)"
            }
            
            return key
        }
        
        /// 缓存策略
        enum CachePolicy {
            case reloadIgnoringCacheData  // 忽略缓存，重新加载
            case useCacheElseLoad         // 使用缓存，如果没有则加载
            case returnCacheDataElseLoad  // 返回缓存数据，如果没有则加载
        }
        
        /// 启用离线模式
        func enableOfflineMode() {
            offlineModeEnabled = true
        }
        
        /// 禁用离线模式
        func disableOfflineMode() {
            offlineModeEnabled = false
        }
        
        /// 启用网络状态适应
        func enableNetworkStateAdaptation() {
            networkStateAdaptationEnabled = true
        }
        
        /// 禁用网络状态适应
        func disableNetworkStateAdaptation() {
            networkStateAdaptationEnabled = false
        }
    }
    
    /// 网络优化管理器
    var networkOptimizationManager: NetworkOptimizationManager {
        return NetworkOptimizationManager.shared
    }
    
    /// 发送网络请求
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - method: 请求方法
    ///   - parameters: 请求参数
    ///   - headers: 请求头
    ///   - cachePolicy: 缓存策略
    ///   - completion: 完成回调
    func sendRequest(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        cachePolicy: NetworkOptimizationManager.CachePolicy = .useCacheElseLoad,
        completion: @escaping (Data?, Error?) -> Void
    ) {
        networkOptimizationManager.request(url, method: method, parameters: parameters, headers: headers, cachePolicy: cachePolicy, completion: completion)
    }
    
    /// 取消请求
    /// - Parameter url: 请求 URL
    func cancelRequest(_ url: String) {
        networkOptimizationManager.cancelRequest(url)
    }
    
    /// 取消所有请求
    func cancelAllRequests() {
        networkOptimizationManager.cancelAllRequests()
    }
    
    /// 清除网络缓存
    func clearNetworkCache() {
        networkOptimizationManager.clearCache()
    }
    
    /// 获取网络状态
    /// - Returns: 网络状态
    func getNetworkStatus() -> NetworkReachabilityManager.NetworkReachabilityStatus {
        return networkOptimizationManager.getNetworkStatus()
    }
    
    /// 是否有网络连接
    /// - Returns: 是否有网络连接
    func isNetworkAvailable() -> Bool {
        return networkOptimizationManager.isNetworkAvailable()
    }
    
    /// 是否是 Wi-Fi 连接
    /// - Returns: 是否是 Wi-Fi 连接
    func isWiFi() -> Bool {
        return networkOptimizationManager.isWiFi()
    }
    
    /// 是否是移动网络连接
    /// - Returns: 是否是移动网络连接
    func isCellular() -> Bool {
        return networkOptimizationManager.isCellular()
    }
    
    /// 启用离线模式
    func enableOfflineMode() {
        networkOptimizationManager.enableOfflineMode()
    }
    
    /// 禁用离线模式
    func disableOfflineMode() {
        networkOptimizationManager.disableOfflineMode()
    }
    
    /// 启用网络状态适应
    func enableNetworkStateAdaptation() {
        networkOptimizationManager.enableNetworkStateAdaptation()
    }
    
    /// 禁用网络状态适应
    func disableNetworkStateAdaptation() {
        networkOptimizationManager.disableNetworkStateAdaptation()
    }
    
    /// 注册网络状态变化通知
    func registerForNetworkStatusChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: .HCollViewNetworkStatusChanged,
            object: nil
        )
    }
    
    /// 取消注册网络状态变化通知
    func unregisterForNetworkStatusChanges() {
        NotificationCenter.default.removeObserver(self, name: .HCollViewNetworkStatusChanged, object: nil)
    }
    
    /// 网络状态变化回调
    @objc private func networkStatusChanged(notification: Notification) {
        if let status = notification.object as? NetworkReachabilityManager.NetworkReachabilityStatus {
            // 处理网络状态变化
            switch status {
            case .reachable(.ethernetOrWiFi):
                // Wi-Fi 连接
                reloadData()
            case .reachable(.cellular):
                // 移动网络连接
                reloadData()
            case .notReachable:
                // 无网络连接
                break
            case .unknown:
                // 未知网络状态
                break
            }
        }
    }
}

/// 通知名称扩展
extension Notification.Name {
    static let HCollViewNetworkStatusChanged = Notification.Name("HCollViewNetworkStatusChanged")
}
