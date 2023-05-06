//
//  HGameCategoryVC+HSection2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HGameCategoryVC {

    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: 65)
    }
    @objc
    func tupleExa2_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    @objc
    func tupleExa2_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        cell.backgroundColor = UIColor.gray
        cell.isShouldShowSeparator = true
        cell.separatorInset = UILREdgeInsets(left: 10, right: 10)
        
        let frame = cell.layoutViewBounds
        
        var tmpFrame = frame
        tmpFrame.size.width = tmpFrame.height
        cell.imageView.frame = tmpFrame
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImageWithName("icon_no_server")
        
        var tmpFrame2: CGRect = CGRect(x: 0, y: 0, width: 7, height: 13)
        
        tmpFrame2.origin.x = frame.width - tmpFrame2.width
        tmpFrame2.origin.y = frame.height / 2 - tmpFrame2.height / 2
        cell.accessoryImageView.frame = tmpFrame2
        cell.accessoryImageView.setImageWithName("icon_tuple_arrow_right")
        
        var tmpFrame3: CGRect = tmpFrame
        tmpFrame3.origin.x = tmpFrame2.minX - tmpFrame3.width - 10
        cell.detailImageView.frame = tmpFrame3
        cell.detailImageView.backgroundColor = UIColor.red
        cell.detailImageView.setImageWithName("icon_no_server")
        
        var tmpFrame4: CGRect = frame
        tmpFrame4.origin.x += tmpFrame.maxY + 10
        tmpFrame4.size.width = tmpFrame3.minX - tmpFrame.width - 10 - 10
        tmpFrame4.size.height = tmpFrame.size.height / 2
        cell.label.frame = tmpFrame4
        cell.label.backgroundColor = UIColor.red
        
        var tmpFrame5: CGRect = tmpFrame4
        tmpFrame5.origin.y += tmpFrame4.maxY
        cell.detailLabel.frame = tmpFrame5
        cell.detailLabel.backgroundColor = UIColor.yellow

    }
    
}
