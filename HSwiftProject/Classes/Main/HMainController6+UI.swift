//
//  HMainController6+UI.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HMainController6 {
    
    func numberOfSectionsInTableView() -> Any {
        return 1
    }
    func numberOfRowsInSection(_ section: Any) -> Any {
        return 5
    }
    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> Any {
        return 65
    }
    func edgeInsetsForRowAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func tableRow(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTableRow
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTableViewCellHoriValue4.self, nil, true) as! HTableViewCellHoriValue4
            cell.backgroundColor = UIColor.gray
            cell.isShowSeparator = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImageWithName("icon_no_server")

            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImageWithName("icon_no_server")

//            cell.detailWidth = 100
//            cell.accessoryWidth = 100
            
            cell.isShowAccessoryArrow = true
            
//            cell.labelInterval = 0
            
            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"
//            cell.label.text = "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
//            cell.label.text = "wwwwwwwwwwwwwwwwwwww"
//            cell.label.text = "wwwwwwwwwwwwwwwwwww"
            
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
//            cell.detailLabel.text = "qqqqqqqqqqqqqqqqqqqqqqqq"

//            cell.accessoryLabel.backgroundColor = UIColor.green
            
            //接收信
            cell.signalBlock = { (target, signal) in
                let cell = target as! HTableViewCellHoriValue4
                NSLog("选中%d", cell.label)
            }
            break
        case 1:
            let cell = itemBlock(nil, HTableViewCellHoriValue4.self, nil, true) as! HTableViewCellHoriValue4
            cell.backgroundColor = UIColor.gray
            cell.isShowSeparator = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImageWithName("icon_no_server")
            
            cell.label.backgroundColor = UIColor.red

            cell.detailLabel.backgroundColor = UIColor.yellow
            
            //接收信号
            cell.signalBlock = { (target, signal) in
                let cell = target as! HTableViewCellHoriValue4
                NSLog("选中%d", cell.label)
            }
            break
        case 2:
            let cell = itemBlock(nil, HTableViewCellHoriValue4.self, nil, true) as! HTableViewCellHoriValue4
            cell.backgroundColor = UIColor.gray
            cell.isShowSeparator = true
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
//            cell.isShowAccessoryArrow = true

            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImageWithName("icon_no_server")

            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImageWithName("icon_no_server")

            cell.label.backgroundColor = UIColor.red

            cell.detailLabel.backgroundColor = UIColor.yellow
            break
        default:
            self.ext_tableRow(itemBlock, atIndexPath: indexPath)
            break
        }
        
    }
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        
    }
    
}


