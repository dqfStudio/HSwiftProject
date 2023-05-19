//
//  HFormView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/19.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HFormItemBlock = () -> UIView

class HFormView: UIStackView {
    
    var headerBlock: HFormItemBlock?
    var footerBlock: HFormItemBlock?
    var itemBlock: HFormItemBlock?

    var headerWidth = 0.0
    var footerWidth = 0.0

    var headerSpace = 0.0
    var footerSpace = 0.0
    
    func reloadData() {

        // Set the stack view properties
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        
        if let itemBlock = itemBlock {
            
            // header
            if let headerBlock = headerBlock {
                let header = headerBlock()
                header.widthAnchor.constraint(equalToConstant: headerWidth).isActive = true
                self.addArrangedSubview(header)
                self.setCustomSpacing(headerSpace, after: header)
            }
            
            // item
            let item = itemBlock()
            self.addArrangedSubview(item)
            
            // footer
            if let footerBlock = footerBlock {
                let footer = footerBlock()
                footer.widthAnchor.constraint(equalToConstant: footerWidth).isActive = true
                self.addArrangedSubview(footer)
                self.setCustomSpacing(footerSpace, after: item)
            }
            
        }
        
    }
    
}

