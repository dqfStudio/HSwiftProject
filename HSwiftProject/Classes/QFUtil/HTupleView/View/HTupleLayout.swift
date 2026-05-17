//
//  HTupleLayout.swift
//  HSwiftProject
//
//  Created by owner on 2024/10/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HTupleLayout: NSObject {
    
    static private let layoutFont = UIFont.font(ofSize: 14, weight: .regular)
    
    /// 计算文字高度
    static private func textHeight(_ text: String, constrainedToWidth width: CGFloat) -> CGFloat {
        let nsText = text as NSString
        let boundingRect = nsText.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: layoutFont],
            context: nil
        )
        return ceil(boundingRect.height)
    }
    
    /// 根据 HPostVM 内容动态计算 cell 高度
    /// 图片区域调用 HCollView 框架的 imageAreaHeightForItem 管理尺寸下载和刷新
    static func getPost(item: HPostVM, tuple: HTupleView, cellWidth: CGFloat, at indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = 0.0
        
        // 1. 头像区域固定 48pt
        let headerHeight: CGFloat = 48.0
        cellHeight += headerHeight + 10
        
        // 2. 文字区域
        if let text = item.post, text.count > 0 {
            let tHeight = self.textHeight(text, constrainedToWidth: cellWidth)
            cellHeight += tHeight + 10
        }
        
        // 3. 图片区域 — 由 HCollView 框架管理
        if let urls = item.imageUrls, urls.count > 0 {
            let imageCount = urls.count
            var imageAreaHeight: CGFloat = 0.0
            
            if imageCount == 1 {
                // 单张图：框架自动下载尺寸、返回等比高度
                if let url = urls[0] as? String,
                   let size = HCollImageSizeCache.shared.size(for: url),
                   size.width > 0 {
                    imageAreaHeight = cellWidth * (size.height / size.width)
                } else {
                    imageAreaHeight = cellWidth // fallback
                }
            } else {
                // 多张图：框架自动管理所有图片尺寸
                let columns: Int = imageCount == 4 ? 2 : min(imageCount, 3)
                // 计算图片网格高度
                let spacing: CGFloat = 4.0
                let itemSpacing = spacing * CGFloat(columns - 1)
                let itemWidth = (cellWidth - itemSpacing) / CGFloat(columns)
                // 取所有图片中最大宽高比作为行高基准
                var maxAspect: CGFloat = 1.0
                for urlObj in urls {
                    if let url = urlObj as? String,
                       let size = HCollImageSizeCache.shared.size(for: url),
                       size.width > 0 {
                        let aspect = size.height / size.width
                        if aspect > maxAspect { maxAspect = aspect }
                    }
                }
                let rowHeight = itemWidth * maxAspect
                let rows = ceil(CGFloat(imageCount) / CGFloat(columns))
                imageAreaHeight = rowHeight * rows + spacing * (rows - 1)
            }
            
            cellHeight += imageAreaHeight + 10
        }
        
        // 4. 视频区域
        if let _ = item.videoUrl, item.videoUrl?.count ?? 0 > 0 {
            cellHeight += postVideoSize + 10
        }
        
        // 5. 底部操作栏
        cellHeight += 40.0 + 25.0
        
        return cellHeight
    }
    
}
