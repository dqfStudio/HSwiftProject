//
//  HSearchBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HSearchBar: UIStackView {
    
    var leftView: UIView?
    var rightView: UIView?

    var leftWidth = 0.0
    var rightWidth = 0.0

    var leftSpace = 0.0
    var rightSpace = 0.0
    
    lazy var textField: UITextField = {
        return UITextField()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
            
        // leftView
        if let leftView = leftView {
            leftView.widthAnchor.constraint(equalToConstant: leftWidth).isActive = true
            self.addArrangedSubview(leftView)
            if leftSpace > 0 {
                self.setCustomSpacing(leftSpace, after: leftView)
            }
        }
        
        // item
        self.addArrangedSubview(textField)
        
        // rightView
        if let rightView = rightView {
            rightView.widthAnchor.constraint(equalToConstant: rightWidth).isActive = true
            self.addArrangedSubview(rightView)
            if rightSpace > 0 {
                self.setCustomSpacing(rightSpace, after: textField)
            }
            
        }
        
    }
    
}

