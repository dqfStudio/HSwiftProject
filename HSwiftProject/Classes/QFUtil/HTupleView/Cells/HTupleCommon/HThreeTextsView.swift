//
//  HThreeTextsView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/26.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HThreeTextsView: UIStackView {
    
    /// 左边布局View
    private lazy var leftView: UIView = {
        return UIView()
    }()
    
    /// 右边布局View
    private lazy var rightView: UIView = {
        return UIView()
    }()
    
    /// 中间label、detailLabel和accessoryLabel布局View
    private lazy var textLayoutView: UIStackView = {
        return UIStackView()
    }()
    
    /// label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    /// detailLabel
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    /// accessoryLabel
    lazy var accessoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 在label后面添加自定义间隔
    var firstSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var secondSpacing: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        /// 左边布局View
        self.addArrangedSubview(leftView)
        
        /// 中间label、detailLabel和accessoryLabel布局View
        self.addArrangedSubview(textLayoutView)
        
        /// label
        textLayoutView.addArrangedSubview(label)
        /// detailLabel
        textLayoutView.addArrangedSubview(detailLabel)
        /// accessoryLabel
        textLayoutView.addArrangedSubview(accessoryLabel)
        // 在label后面的间隔
        textLayoutView.setCustomSpacing(firstSpacing, after: label)
        // 在detailLabel后面的间隔
        textLayoutView.setCustomSpacing(secondSpacing, after: detailLabel)
        
        /// 根据label、detailLabel和accessoryLabel的实际大小进行约束布局
        var textWidth = label.intrinsicContentSize.width + detailLabel.intrinsicContentSize.width + accessoryLabel.intrinsicContentSize.width
        textWidth += firstSpacing + secondSpacing
        textWidth = ceil(textWidth)//向上取整
        
        /// 右边布局View
        self.addArrangedSubview(rightView)
        
        /// 左右两边的间隔
        let space = (self.width - textWidth) / 2
        if space >= 0 { self.spacing = space }
        
    }
    
}

