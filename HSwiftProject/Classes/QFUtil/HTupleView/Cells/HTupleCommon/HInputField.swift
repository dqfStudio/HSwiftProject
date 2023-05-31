//
//  HInputField.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/20.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HInputField: UIStackView {
    
    private var allReuseViews = NSMapTable<NSString, AnyObject>.strongToStrongObjects()
    
    var leftView: UIView? {
        get { return allReuseViews.object(forKey: "leftView") as? UIView }
        set { allReuseViews.setObject(newValue, forKey: "leftView") }
    }
    var rightView: UIView? {
        get { return allReuseViews.object(forKey: "rightView") as? UIView }
        set { allReuseViews.setObject(newValue, forKey: "rightView") }
    }
    lazy var textField: UITextField = {
        return UITextField()
    }()

    var leftWidth = 0.0
    var rightWidth = 0.0

    var leftSpace = 0.0
    var rightSpace = 0.0
    
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

