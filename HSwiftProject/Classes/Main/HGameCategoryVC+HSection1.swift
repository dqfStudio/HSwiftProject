//
//  HGameCategoryVC+HSection1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HGameCategoryVC {

    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        return 1
    }
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return CGSize(width: self.tupleView.width, height: 65)
    }
    @objc
    func tupleExa1_edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    @objc
    func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(HTupleViewCell.self, nil, true) as! HTupleViewCell
        cell.backgroundColor = UIColor.gray
        cell.separatorView.separatorInset = UILREdgeInsets(left: 0, right: 10)
        
        let frame = cell.layoutViewBounds
        
        var tmpFrame = frame
        tmpFrame.size.width = tmpFrame.height
        cell.imageView.frame = tmpFrame
        cell.imageView.backgroundColor = UIColor.red
        cell.imageView.setImage(WithName: "icon_no_server")
        
        var tmpFrame2: CGRect = CGRect(x: 0, y: 0, width: 7, height: 13)
        tmpFrame2.origin.x = frame.width - tmpFrame2.width
        tmpFrame2.origin.y = frame.height / 2 - tmpFrame2.height / 2
        cell.accsryView.frame = tmpFrame2
        cell.accsryView.setImage(WithName: "icon_tuple_arrow_right")
        
        var tmpFrame3: CGRect = frame
        tmpFrame3.origin.x += tmpFrame.maxY + 10
        tmpFrame3.size.width = tmpFrame2.minX - tmpFrame3.minX - 10
        tmpFrame3.size.height = tmpFrame.size.height / 2
        cell.label.frame = tmpFrame3
        cell.label.backgroundColor = UIColor.red
        
        var tmpFrame4: CGRect = tmpFrame3
        tmpFrame4.origin.y += tmpFrame3.maxY
        cell.detailLabel.frame = tmpFrame4
        cell.detailLabel.backgroundColor = UIColor.yellow

    }
    
}
