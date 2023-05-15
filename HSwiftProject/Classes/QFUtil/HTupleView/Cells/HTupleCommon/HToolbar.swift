//
//  HToolbar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HToolbar: UIStackView, HTupleViewDelegate {
 
    lazy var tupleView: HTupleView = {
        return HTupleView(frame: self.bounds, scrollDirection: .horizontal)
    }()
    
    lazy var lineBar: UIView = {
        return UIView(frame: self.bounds)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        self.tupleView.delegate = self
        self.addArrangedSubview(tupleView)
        
        lineBar.widthAnchor.constraint(equalToConstant: 3).isActive = true
        self.addArrangedSubview(lineBar)
        
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 2
    }

    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleButtonCell.self, nil, true) as! HTupleButtonCell
        cell.sizeBlock = {
            return CGSize(width: 150, height: 40)
        }
        cell.cellBlock = {
            cell.backgroundColor = UIColor.red
        }
        
    }
    
}
