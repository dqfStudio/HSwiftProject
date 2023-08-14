//
//  HInputBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HInputBar: UIView {
    
    lazy var textView: HTextView = {
        let textView = HTextView()
//        textView.placeholder = "请输入你闪亮的评论~~~"
//        textView.placeholderColor = UIColor.text3
        textView.layoutManager.allowsNonContiguousLayout = false
        textView.isExclusiveTouch = true
        textView.backgroundColor = .white
        textView.enablesReturnKeyAutomatically = true
        textView.isUserInteractionEnabled = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 8)
        textView.isScrollEnabled = false
//        textView.delegate = self
        textView.font = UIFont.font(ofSize: 14, weight: .regular)
//        textView.textColor = UIColor.text
        return textView
    }()
    
}
