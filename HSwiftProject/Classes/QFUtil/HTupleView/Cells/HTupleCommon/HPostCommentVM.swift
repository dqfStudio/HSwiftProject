//
//  HPostCommentVM.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/11.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

// 左右间距
var postCommentEdgeSpace = 16.0
// 行间距
var postCommentLineSpace = 16.0
// 更多按钮高度
var postCommentExtendSpace = 36.0
// 时间按钮高度
var postCommentTimeSpace = 28.0
// 翻译按钮高度
var postCommentTranslateSpace = 28.0

//// 默认帖子内容高度，超过此高度就显示省略
//var postTextHeightOmit = 60.0

// 更多状态定义
enum HPostCommentExtend: Int {
    case undefine = 0  // 未定义
    case extend = 1  // 需要加载更多
}

// 翻译状态定义
enum HPostCommentTranslate: Int {
    case undefine = 0  // 未定义
    case translate = 1  // 需要翻译
    case isTranslated = 2  // 已经翻译过了
}

class HPostCommentVM: NSObject {
    
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
                textHeight = ct.heightWithFont(UIFont.font(ofSize: 14, weight: .regular),
                                               constrainedToWidth: UIScreen.width - 2 * postCommentEdgeSpace - 60)
                // 是否显示更多信息
                postExtend = .extend
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
    
    // text高度
    var textHeight: CGFloat = 0.0
    
    // cell高度
    var cellHeight: CGFloat {
        var tmpHeight = 0.0
        // text高度
        tmpHeight += textHeight + postCommentLineSpace
        // 是否需要翻译
        if postTranslate == .isTranslated {
            tmpHeight += textHeight + 8.0
        } else if postTranslate == .translate {
            tmpHeight += postCommentTranslateSpace
        }
        // 评论时间按钮高度
        tmpHeight += postCommentTimeSpace
        
        // 更多按钮高度
        if postExtend == .extend {
            tmpHeight += postCommentExtendSpace
        }

        // header高度
        tmpHeight += 72
        // footer高度
        tmpHeight += 12
        
        return tmpHeight
    }
    
}
