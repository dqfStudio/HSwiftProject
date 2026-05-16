//
//  ImageCacheProtocol.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 图片缓存协议
///
/// 定义了图片缓存相关的方法，用于实现依赖注入
protocol ImageCacheProtocol {
    /// 缓存图片
    /// - Parameters:
    ///   - image: 要缓存的图片
    ///   - key: 缓存键
    func cacheImage(_ image: UIImage, forKey key: String)
    
    /// 获取缓存的图片
    /// - Parameter key: 缓存键
    /// - Returns: 缓存的图片，如果不存在则返回nil
    func getImage(forKey key: String) -> UIImage?
    
    /// 移除缓存的图片
    /// - Parameter key: 缓存键
    func removeImage(forKey key: String)
    
    /// 清理所有缓存
    func clearCache()
    
    /// 清理过期的缓存
    func cleanupExpiredCache()
}
