//
//  HGameCategoryVC+HSection0.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HGameCategoryVC {

    @objc
    func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: 65)
    }
    @objc
    func tupleExa0_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    @objc
    func tupleExa0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        cell.backgroundColor = UIColor.gray
        cell.separatorView.separatorInset = UILREdgeInsets(left: 0, right: 10)
        
        let frame = cell.layoutViewBounds
        
        var tmpFrame = frame
        tmpFrame.size.width = tmpFrame.height
        cell.imageView.frame = tmpFrame
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImage(WithName: "icon_no_server")
        
        var tmpFrame2 = frame
        tmpFrame2.origin.x += tmpFrame.maxY + 10
        tmpFrame2.size.width = frame.width - tmpFrame2.minX
        tmpFrame2.size.height = tmpFrame.height / 3
        cell.label.frame = tmpFrame2
        cell.label.backgroundColor = UIColor.red
        
        var tmpFrame3 = tmpFrame2
        tmpFrame3.origin.y += tmpFrame2.maxY
        cell.detailLabel.frame = tmpFrame3
        cell.detailLabel.backgroundColor = UIColor.yellow
        
        var tmpFrame4 = tmpFrame2
        tmpFrame4.origin.y += tmpFrame3.maxY
        cell.accessoryLabel.frame = tmpFrame4
        cell.accessoryLabel.backgroundColor = UIColor.green

    }
    
}
