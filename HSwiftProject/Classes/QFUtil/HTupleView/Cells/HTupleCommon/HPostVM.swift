//
//  HPostVM.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/10.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

// 左右间距
var postEdgeSpace = 16.0
// 行间距
var postLineSpace = 16.0
// 图片间距
var postImageSpace = 8.0
// 图片大小
var postImageSize: CGFloat {
    return (UIScreen.width - 32 - 2 * postImageSpace) / 3
}
// 视频大小
var postVideoSize: CGFloat {
    return (UIScreen.width - 32) * 180.0 / 343.0
}

// 更多按钮高度
var postExtendSpace = 28.0
// 翻译按钮高度
var postTranslateSpace = 28.0

// 默认帖子内容高度，超过此高度就显示省略
var postTextHeightOmit = 60.0

// 更多状态定义
enum HPostExtend: Int {
    case undefine = 0  // 未定义
    case extend = 1  // 需要加载更多
    case isExtended = 2  // 已加载了更多
}

// 翻译状态定义
enum HPostTranslate: Int {
    case undefine = 0  // 未定义
    case translate = 1  // 需要翻译
    case isTranslated = 2  // 已经翻译过了
}

class HPostVM: NSObject {
    
    // 头像
    var avatar: String?
    // 名称
    var name: String?
    // 日期
    var date: String?
    
    // 帖子内容
    var post: String? {
        didSet {
            if let ct = post, ct.count > 0 {
                textHeight = ct.heightWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToWidth: UIScreen.width - 32)
                // 是否显示更多信息
                if textHeight > postTextHeightOmit {
                    postExtend = .extend
                } else {
                    postExtend = .undefine
                }
                // 是否需要翻译
                postTranslate = .translate
                
            } else {
                // 是否显示更多信息
                postExtend = .undefine
                // 是否需要翻译
                postTranslate = .undefine
            }
        }
    }
    
    // 是否显示更多信息
    var postExtend: HPostExtend = .undefine
    
    // 是否需要翻译
    var postTranslate: HPostTranslate = .undefine
    
    // 图片
    var imageUrls: [String]?
    
    // 视频
    var videoUrl: String?
    
    // text高度
    var textHeight: CGFloat = 0.0
    
    // cell高度
    var cellHeight: CGFloat {
        var tmpHeight = 0.0
        // text高度
        if postExtend == .extend {
            tmpHeight += postTextHeightOmit + postLineSpace
        } else {
            tmpHeight += textHeight + postLineSpace
        }
        // 是否需要翻译
        if postTranslate == .isTranslated {
            tmpHeight += textHeight
        } else if postTranslate == .translate {
            tmpHeight += postTranslateSpace
        }
        // 视频
        if let count = imageUrls?.count, count > 0 {
            let cc = ceil(CGFloat((count - 1) / 2))
            let height = (cc + 1) * postImageSize + cc * postImageSpace
            tmpHeight += height + postLineSpace
        }
        // 视频
        if videoUrl?.count ?? 0 > 0 {
            tmpHeight += postVideoSize + postLineSpace
        }
        
        // header高度
        tmpHeight += 72
        // footer高度
        tmpHeight += 65
        
        return tmpHeight
    }
    
}
