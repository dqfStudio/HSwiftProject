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
    
    var header: UIView? {
        get { return allReuseViews.object(forKey: "header") as? UIView }
        set { allReuseViews.setObject(newValue, forKey: "header") }
    }
    var footer: UIView? {
        get { return allReuseViews.object(forKey: "footer") as? UIView }
        set { allReuseViews.setObject(newValue, forKey: "footer") }
    }
    lazy var textField: UITextField = {
        return UITextField()
    }()

    var headerWidth = 0.0
    var footerWidth = 0.0

    var headerSpace = 0.0
    var footerSpace = 0.0
    
    func reloadData() {
            
        // header
        if let header = header {
            header.widthAnchor.constraint(equalToConstant: headerWidth).isActive = true
            self.addArrangedSubview(header)
            if headerSpace > 0 {
                self.setCustomSpacing(headerSpace, after: header)
            }
        }
        
        // item
        self.addArrangedSubview(textField)
        
        // footer
        if let footer = footer {
            footer.widthAnchor.constraint(equalToConstant: footerWidth).isActive = true
            self.addArrangedSubview(footer)
            if footerSpace > 0 {
                self.setCustomSpacing(footerSpace, after: textField)
            }
            
        }
        
    }
    
}

