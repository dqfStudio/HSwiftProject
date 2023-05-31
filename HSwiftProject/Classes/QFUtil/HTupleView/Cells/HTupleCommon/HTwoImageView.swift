//
//  HTwoImageView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/31.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HTwoImageView: UIStackView {
    
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
    
    // 用于imageView布局
    private lazy var imageLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    /// imageView
    lazy var imageView: UIImageView = {
        return UIImageView()
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
    
    // 用于imageView布局
    private lazy var detailLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    /// imageView
    lazy var detailView: UIImageView = {
        return UIImageView()
    }()
    
    // 在imageView后面添加自定义间隔
    var firstSpacing: CGFloat = 0.0
    
    // 在label后面添加自定义间隔
    var secondSpacing: CGFloat = 0.0
    
    // 在detailLabel后面添加自定义间隔
    var thirdSpacing: CGFloat = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        /// 左边布局View
        self.addArrangedSubview(leftView)
        
        /// 中间label、detailLabel和accessoryLabel布局View
        self.addArrangedSubview(textLayoutView)
         
        /// imageView
        imageLayoutView.addArrangedSubview(imageView)
        textLayoutView.addArrangedSubview(imageLayoutView)
        /// label
        textLayoutView.addArrangedSubview(label)
        /// detailLabel
        textLayoutView.addArrangedSubview(detailLabel)
        
        /// detailView
        detailLayoutView.addArrangedSubview(detailView)
        textLayoutView.addArrangedSubview(detailLayoutView)
        
        // 在imageView后面的间隔
        textLayoutView.setCustomSpacing(firstSpacing, after: imageLayoutView)
        // 在label后面的间隔
        textLayoutView.setCustomSpacing(secondSpacing, after: label)
        // 在detailLabel后面的间隔
        textLayoutView.setCustomSpacing(thirdSpacing, after: detailLabel)
        
        /// 根据label、detailLabel和accessoryLabel的实际大小进行约束布局
        var textWidth = label.intrinsicContentSize.width + detailLabel.intrinsicContentSize.width
        textWidth += imageView.intrinsicContentSize.width + detailView.intrinsicContentSize.width
        textWidth += firstSpacing + secondSpacing + thirdSpacing
        textWidth = ceil(textWidth)//向上取整
        
        /// 右边布局View
        self.addArrangedSubview(rightView)
        
        /// 左右两边的间隔
        let space = (self.width - textWidth) / 2
        if space >= 0 { self.spacing = space }
        
    }
    
}

