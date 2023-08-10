//
//  HTuplePostVM.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/10.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var edgeSpace = 16.0
private var lineSpace = 16.0

private var imageSpace = 8.0
private var imageSize = 60.0
private var videoSize = 90.0

private var extendSpace = 28.0
private var translateSpace = 28.0

private var textHeightOmit = 60.0

enum HPostExtend: Int {
    case undefine = 0  // 未定义
    case extend = 1  // 需要加载更多
    case isExtended = 2  // 已加载了更多
}

enum HPostTranslate: Int {
    case undefine = 0  // 未定义
    case translate = 1  // 需要翻译
    case isTranslated = 2  // 已经翻译过了
}

class HTuplePostVM: NSObject {
    
    var avatar: String?
    var name: String?
    var date: String?
    
    var post: String? {
        didSet {
            if let ct = post, ct.count > 0 {
                textHeight = ct.heightWithFont(UIFont.font(ofSize: 14, weight: .regular), constrainedToWidth: UIScreen.width - 32)
                // 是否显示更多信息
                if textHeight > textHeightOmit {
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
            tmpHeight += textHeightOmit + lineSpace
        } else {
            tmpHeight += textHeight + lineSpace
        }
        // 是否需要翻译
        if postTranslate == .isTranslated {
            tmpHeight += textHeight
        } else if postTranslate == .translate {
            tmpHeight += translateSpace
        }
        // 视频
        if let count = imageUrls?.count, count > 0 {
            let cc = ceil(CGFloat((count - 1) / 2))
            let height = (cc + 1) * imageSize + cc * imageSpace
            tmpHeight += height + lineSpace
        }
        // 视频
        if videoUrl?.count ?? 0 > 0 {
            tmpHeight += videoSize + lineSpace
        }
        return tmpHeight
    }
    
}
