//
//  HTextStackView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/26.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HTextStackView: UIStackView {
    
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
    
    func reloadData() {
        
        guard self.frame != .zero else {
            return
        }
        
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
        var textWidth1 = label.intrinsicContentSize.width + accessoryLabel.intrinsicContentSize.width
        textWidth1 = ceil(textWidth1)//向上取整
        
        var textWidth2 = detailLabel.intrinsicContentSize.width
        textWidth2 = ceil(textWidth2)//向上取整
        
        var textSpace = firstSpacing + secondSpacing
        textSpace = ceil(textSpace)//向上取整
        
        if textWidth1 + textWidth2 + textSpace < self.width {
            textLayoutView.widthAnchor.constraint(equalToConstant: textWidth1 + textWidth2 + textSpace).isActive = true
        } else if textWidth2 + textSpace < self.width {
            label.widthAnchor.constraint(equalToConstant: (self.width - textWidth2 - textSpace) / 2).isActive = true
            detailLabel.widthAnchor.constraint(equalToConstant: textWidth2).isActive = true
            accessoryLabel.widthAnchor.constraint(equalToConstant: (self.width - textWidth2 - textSpace) / 2).isActive = true
            textLayoutView.widthAnchor.constraint(equalToConstant: self.width).isActive = true
        } else {
            label.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
            detailLabel.widthAnchor.constraint(equalToConstant: self.width).isActive = true
            accessoryLabel.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
            textLayoutView.widthAnchor.constraint(equalToConstant: self.width).isActive = true
        }
        
        /// 右边布局View
        self.addArrangedSubview(rightView)
        
        /// 左右两边的间隔
        let space = (self.width - textWidth1 - textWidth2 - textSpace) / 2
        if space >= 0 { self.spacing = space }
        
    }
    
}

