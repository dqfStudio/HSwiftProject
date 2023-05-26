//
//  HTextStackView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/26.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HTextStackView: UIStackView {
    
    lazy var label: UILabel = {
        return UILabel()
    }()
    
    lazy var detailLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var accessoryLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var leftView: UIView = {
        return UIView()
    }()
    
    private lazy var rightView: UIView = {
        return UIView()
    }()
    
    private lazy var textStackView: UIStackView = {
        return UIStackView()
    }()
    
    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 5.0
    
    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 5.0
    
    func reloadData() {
        
        self.addArrangedSubview(leftView)
        
        self.addArrangedSubview(textStackView)
        
        textStackView.addArrangedSubview(label)
        textStackView.addArrangedSubview(detailLabel)
        textStackView.addArrangedSubview(accessoryLabel)
        textStackView.setCustomSpacing(firstTextSpacing, after: label)
        textStackView.setCustomSpacing(secondTextSpacing, after: detailLabel)
        
        let textWidth1 = label.intrinsicContentSize.width + accessoryLabel.intrinsicContentSize.width
        let textWidth2 = detailLabel.intrinsicContentSize.width
        let textSpace = firstTextSpacing + secondTextSpacing
        
        if textWidth1 + textWidth2 + textSpace < self.width {
            textStackView.widthAnchor.constraint(equalToConstant: textWidth1 + textWidth2 + textSpace).isActive = true
        } else if textWidth2 + textSpace < self.width {
            label.widthAnchor.constraint(equalToConstant: (self.width - textWidth2 - textSpace) / 2).isActive = true
            detailLabel.widthAnchor.constraint(equalToConstant: textWidth2).isActive = true
            accessoryLabel.widthAnchor.constraint(equalToConstant: (self.width - textWidth2 - textSpace) / 2).isActive = true
            textStackView.widthAnchor.constraint(equalToConstant: self.width).isActive = true
        } else {
            label.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
            detailLabel.widthAnchor.constraint(equalToConstant: self.width).isActive = true
            accessoryLabel.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
            textStackView.widthAnchor.constraint(equalToConstant: self.width).isActive = true
        }
        
        self.addArrangedSubview(rightView)
        
        let space = (self.width - textWidth1 - textWidth2 - textSpace) / 2
        if space >= 0 { self.spacing = space }
        
    }
    
}

