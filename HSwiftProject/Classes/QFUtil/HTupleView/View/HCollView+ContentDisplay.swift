//
//  HCollView+ContentDisplay.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 内容展示扩展
///
/// 提供富文本支持、多媒体支持、动态内容和AR/VR支持等功能
extension HCollView {
    
    /// 内容类型
    enum ContentType {
        case text         // 文本
        case richText     // 富文本
        case image        // 图片
        case video        // 视频
        case audio        // 音频
        case mixed        // 混合内容
        case ar           // AR内容
        case vr           // VR内容
    }
    
    /// 内容展示管理器
    class ContentDisplayManager {
        
        // MARK: - 单例
        static let shared = ContentDisplayManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 是否启用富文本支持
        var richTextEnabled: Bool = true
        
        /// 是否启用多媒体支持
        var multimediaEnabled: Bool = true
        
        /// 是否启用AR/VR支持
        var arVREnabled: Bool = false
        
        /// 图片缓存
        private var imageCache: NSCache<NSString, UIImage> = NSCache()
        
        /// 视频缓存
        private var videoCache: NSCache<NSString, URL> = NSCache()
        
        // MARK: - 方法
        
        /// 加载图片
        /// - Parameters:
        ///   - url: 图片 URL
        ///   - completion: 完成回调
        func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            let cacheKey = url.absoluteString as NSString
            
            // 检查缓存
            if let cachedImage = imageCache.object(forKey: cacheKey) {
                completion(cachedImage)
                return
            }
            
            // 加载图片
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                // 缓存图片
                self?.imageCache.setObject(image, forKey: cacheKey)
                
                // 回调
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
        
        /// 加载视频
        /// - Parameters:
        ///   - url: 视频 URL
        ///   - completion: 完成回调
        func loadVideo(from url: URL, completion: @escaping (URL?) -> Void) {
            let cacheKey = url.absoluteString as NSString
            
            // 检查缓存
            if let cachedVideo = videoCache.object(forKey: cacheKey) {
                completion(cachedVideo)
                return
            }
            
            // 加载视频（实际应用中应该下载到本地）
            // 这里简化处理，直接返回原始 URL
            videoCache.setObject(url, forKey: cacheKey)
            completion(url)
        }
        
        /// 创建富文本
        /// - Parameter html: HTML 字符串
        /// - Returns: 富文本
        func createRichText(from html: String) -> NSAttributedString? {
            guard richTextEnabled else { return NSAttributedString(string: html) }
            
            guard let data = html.data(using: .utf8) else { return nil }
            
            do {
                let attributedString = try NSAttributedString(
                    data: data,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil
                )
                return attributedString
            } catch {
                print("Error creating rich text: \(error)")
                return NSAttributedString(string: html)
            }
        }
        
        /// 清除图片缓存
        func clearImageCache() {
            imageCache.removeAllObjects()
        }
        
        /// 清除视频缓存
        func clearVideoCache() {
            videoCache.removeAllObjects()
        }
        
        /// 清除所有缓存
        func clearAllCache() {
            clearImageCache()
            clearVideoCache()
        }
        
        /// 启用富文本支持
        func enableRichText() {
            richTextEnabled = true
        }
        
        /// 禁用富文本支持
        func disableRichText() {
            richTextEnabled = false
        }
        
        /// 启用多媒体支持
        func enableMultimedia() {
            multimediaEnabled = true
        }
        
        /// 禁用多媒体支持
        func disableMultimedia() {
            multimediaEnabled = false
        }
        
        /// 启用AR/VR支持
        func enableARVR() {
            arVREnabled = true
        }
        
        /// 禁用AR/VR支持
        func disableARVR() {
            arVREnabled = false
        }
    }
    
    /// 内容展示管理器
    var contentDisplayManager: ContentDisplayManager {
        return ContentDisplayManager.shared
    }
    
    /// 加载图片
    /// - Parameters:
    ///   - url: 图片 URL
    ///   - completion: 完成回调
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        contentDisplayManager.loadImage(from: url, completion: completion)
    }
    
    /// 加载视频
    /// - Parameters:
    ///   - url: 视频 URL
    ///   - completion: 完成回调
    func loadVideo(from url: URL, completion: @escaping (URL?) -> Void) {
        contentDisplayManager.loadVideo(from: url, completion: completion)
    }
    
    /// 创建富文本
    /// - Parameter html: HTML 字符串
    /// - Returns: 富文本
    func createRichText(from html: String) -> NSAttributedString? {
        return contentDisplayManager.createRichText(from: html)
    }
    
    /// 清除图片缓存
    func clearImageCache() {
        contentDisplayManager.clearImageCache()
    }
    
    /// 清除视频缓存
    func clearVideoCache() {
        contentDisplayManager.clearVideoCache()
    }
    
    /// 清除所有缓存
    func clearAllCache() {
        contentDisplayManager.clearAllCache()
    }
    
    /// 启用富文本支持
    func enableRichText() {
        contentDisplayManager.enableRichText()
    }
    
    /// 禁用富文本支持
    func disableRichText() {
        contentDisplayManager.disableRichText()
    }
    
    /// 启用多媒体支持
    func enableMultimedia() {
        contentDisplayManager.enableMultimedia()
    }
    
    /// 禁用多媒体支持
    func disableMultimedia() {
        contentDisplayManager.disableMultimedia()
    }
    
    /// 启用AR/VR支持
    func enableARVR() {
        contentDisplayManager.enableARVR()
    }
    
    /// 禁用AR/VR支持
    func disableARVR() {
        contentDisplayManager.disableARVR()
    }
    
    /// 预加载内容
    /// - Parameters:
    ///   - indexPaths: 要预加载的索引路径
    ///   - contentLoader: 内容加载闭包
    func preloadContent(at indexPaths: [IndexPath], contentLoader: @escaping (IndexPath) -> Void) {
        let preloadQueue = DispatchQueue(label: "com.hcollview.preload", qos: .userInitiated, attributes: .concurrent)
        
        for indexPath in indexPaths {
            preloadQueue.async {
                contentLoader(indexPath)
            }
        }
    }
}
