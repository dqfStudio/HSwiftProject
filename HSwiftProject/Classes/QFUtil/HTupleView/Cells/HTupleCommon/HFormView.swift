//
//  HFormView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/19.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HFormView: UIStackView {
    
    private var allReuseCells = NSMapTable<NSString, AnyObject>.strongToStrongObjects()
    
    var header: UIView? {
        get { return allReuseCells.object(forKey: "header") as? UIView }
        set { allReuseCells.setObject(newValue, forKey: "header") }
    }
    var footer: UIView? {
        get { return allReuseCells.object(forKey: "footer") as? UIView }
        set { allReuseCells.setObject(newValue, forKey: "footer") }
    }
    var item: UIView? {
        get { return allReuseCells.object(forKey: "item") as? UIView }
        set { allReuseCells.setObject(newValue, forKey: "item") }
    }

    var headerWidth = 0.0
    var footerWidth = 0.0

    var headerSpace = 0.0
    var footerSpace = 0.0
    
    func reloadData() {
        
        if let item = item {
            
            // header
            if let header = header {
                header.widthAnchor.constraint(equalToConstant: headerWidth).isActive = true
                self.addArrangedSubview(header)
                self.setCustomSpacing(headerSpace, after: header)
            }
            
            // item
            self.addArrangedSubview(item)
            
            // footer
            if let footer = footer {
                footer.widthAnchor.constraint(equalToConstant: footerWidth).isActive = true
                self.addArrangedSubview(footer)
                self.setCustomSpacing(footerSpace, after: item)
            }
            
        }
        
    }
    
}

