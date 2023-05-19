//
//  HFormView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/19.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HFormItemBlock = () -> UIView
typealias HFormWidthBlock = () -> CGFloat
typealias HFormSpaceBlock = () -> CGFloat

class HFormView: UIStackView {
    
    var headerBlock: HFormItemBlock?
    var footerBlock: HFormItemBlock?
    var itemBlock: HFormItemBlock?

    var headerWidthBlock: HFormWidthBlock?
    var footerWidthBlock: HFormWidthBlock?

    var headerSpaceBlock: HFormSpaceBlock?
    var footerSpaceBlock: HFormSpaceBlock?
    
    func reloadData() {

        // Set the stack view properties
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        
        if let itemBlock = itemBlock {
            
            // header
            if let headerBlock = headerBlock {
                let header = headerBlock()
                if let headerWidthBlock = headerWidthBlock {
                    let width = headerWidthBlock()
                    header.widthAnchor.constraint(equalToConstant: width).isActive = true
                }
                self.addArrangedSubview(header)
                
                if let headerSpaceBlock = headerSpaceBlock {
                    let space = headerSpaceBlock()
                    self.setCustomSpacing(space, after: header)
                }
            }
            
            // item
            let item = itemBlock()
            self.addArrangedSubview(item)
            
            // footer
            if let footerBlock = footerBlock {
                let footer = footerBlock()
                if let footerWidthBlock = footerWidthBlock {
                    let width = footerWidthBlock()
                    footer.widthAnchor.constraint(equalToConstant: width).isActive = true
                }
                self.addArrangedSubview(footer)
                
                if let footerSpaceBlock = footerSpaceBlock {
                    let space = footerSpaceBlock()
                    self.setCustomSpacing(space, after: item)
                }
            }
            
        }
        
    }
    
}

