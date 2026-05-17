//
//  HCollView+Networking.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import Alamofire

/// HCollView 网络请求管理扩展
///
/// 提供网络请求队列、缓存、重试等功能
extension HCollView {
    
    /// 网络请求管理器
    class NetworkManager {
        
        // MARK: - 单例
        static let shared = NetworkManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 请求队列
        private let requestQueue = DispatchQueue(label: "com.hcollview.network", qos: .userInitiated, attributes: .concurrent)
        
        /// 请求缓存
        private var requestCache: [String: Data] = [:]
        
        /// 进行中的请求
        private var pendingRequests: Set<String> = []
        
        // MARK: - 方法
        
        /// 发送 GET 请求
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - parameters: 请求参数
        ///   - headers: 请求头
        ///   - cachePolicy: 缓存策略
        ///   - retryCount: 重试次数
        ///   - completion: 完成回调
        func get(_ url: String,
                 parameters: [String: Any]? = nil,
                 headers: HTTPHeaders? = nil,
                 cachePolicy: CachePolicy = .useCacheElseLoad,
                 retryCount: Int = 3,
                 completion: @escaping (Data?, Error?) -> Void) {
            
            let requestKey = generateRequestKey(url: url, parameters: parameters)
            
            // 检查是否有缓存
            if cachePolicy != .reloadIgnoringCacheData {
                if let cachedData = requestCache[requestKey] {
                    completion(cachedData, nil)
                    return
                }
            }
            
            // 检查是否有相同的请求正在进行
            if pendingRequests.contains(requestKey) {
                return
            }
            
            // 添加到进行中请求
            pendingRequests.insert(requestKey)
            
            // 发送请求
            AF.request(url, method: .get, parameters: parameters, headers: headers)
                .responseData(queue: requestQueue) { [weak self] response in
                    guard let self = self else { return }
                    
                    // 从进行中请求中移除
                    self.pendingRequests.remove(requestKey)
                    
                    switch response.result {
                    case .success(let data):
                        // 缓存数据
                        if cachePolicy != .reloadIgnoringCacheData {
                            self.requestCache[requestKey] = data
                        }
                        completion(data, nil)
                    case .failure(let error):
                        // 重试
                        if retryCount > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.get(url, parameters: parameters, headers: headers, cachePolicy: cachePolicy, retryCount: retryCount - 1, completion: completion)
                            }
                        } else {
                            completion(nil, error)
                        }
                    }
                }
        }
        
        /// 发送 POST 请求
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - parameters: 请求参数
        ///   - headers: 请求头
        ///   - retryCount: 重试次数
        ///   - completion: 完成回调
        func post(_ url: String,
                  parameters: [String: Any]? = nil,
                  headers: HTTPHeaders? = nil,
                  retryCount: Int = 3,
                  completion: @escaping (Data?, Error?) -> Void) {
            
            let requestKey = generateRequestKey(url: url, parameters: parameters)
            
            // 检查是否有相同的请求正在进行
            if pendingRequests.contains(requestKey) {
                return
            }
            
            // 添加到进行中请求
            pendingRequests.insert(requestKey)
            
            // 发送请求
            AF.request(url, method: .post, parameters: parameters, headers: headers)
                .responseData(queue: requestQueue) { [weak self] response in
                    guard let self = self else { return }
                    
                    // 从进行中请求中移除
                    self.pendingRequests.remove(requestKey)
                    
                    switch response.result {
                    case .success(let data):
                        completion(data, nil)
                    case .failure(let error):
                        // 重试
                        if retryCount > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.post(url, parameters: parameters, headers: headers, retryCount: retryCount - 1, completion: completion)
                            }
                        } else {
                            completion(nil, error)
                        }
                    }
                }
        }
        
        /// 取消请求
        /// - Parameter url: 请求 URL
        func cancelRequest(_ url: String) {
            // 这里可以实现取消请求的逻辑
            // 例如使用 Alamofire 的 RequestInterceptor
        }
        
        /// 清除缓存
        func clearCache() {
            requestCache.removeAll()
        }
        
        /// 生成请求键
        /// - Parameters:
        ///   - url: 请求 URL
        ///   - parameters: 请求参数
        /// - Returns: 请求键
        private func generateRequestKey(url: String, parameters: [String: Any]?) -> String {
            if let parameters = parameters, !parameters.isEmpty {
                let paramsString = parameters.map { "\($0.key)=\($0.value)" }.sorted().joined(separator: "&")
                return "\(url)?\(paramsString)"
            } else {
                return url
            }
        }
        
        /// 缓存策略
        enum CachePolicy {
            case reloadIgnoringCacheData  // 忽略缓存，重新加载
            case useCacheElseLoad         // 使用缓存，如果没有则加载
            case returnCacheDataElseLoad  // 返回缓存数据，如果没有则加载
        }
    }
    
    /// 网络请求管理器
    var networkManager: NetworkManager {
        return NetworkManager.shared
    }
    
    /// 加载网络数据
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - parameters: 请求参数
    ///   - completion: 完成回调
    func loadData(from url: String, parameters: [String: Any]? = nil, completion: @escaping (Data?, Error?) -> Void) {
        networkManager.get(url, parameters: parameters) { [weak self] data, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    completion(data, nil)
                }
            }
        }
    }
    
    /// 加载分页数据
    /// - Parameters:
    ///   - url: 请求 URL
    ///   - page: 页码
    ///   - pageSize: 每页数量
    ///   - parameters: 其他请求参数
    ///   - completion: 完成回调
    func loadPagedData(from url: String, page: Int, pageSize: Int, parameters: [String: Any]? = nil, completion: @escaping (Data?, Error?) -> Void) {
        var params = parameters ?? [:]
        params["page"] = page
        params["pageSize"] = pageSize
        
        networkManager.get(url, parameters: params) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    completion(data, nil)
                }
            }
        }
    }
}
