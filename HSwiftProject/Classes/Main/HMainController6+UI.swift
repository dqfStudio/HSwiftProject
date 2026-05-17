//
//  HMainController6+UI.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HMainController6 {
    
    func numberOfSectionsInFlowView() -> Any {
        return 1
    }
    func numberOfRowsInSection(_ section: Any) -> Any {
        return 8
    }
    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> Any {
        return 65
    }
    func edgeInsetsForRowAtIndexPath(_ indexPath: IndexPath) -> Any {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
        switch (indexPath.row) {
        case 0:
            let cell = HFlowViewCellHoriValue2(style: .default, reuseIdentifier: "HFlowViewCellHoriValue2")
            cell.backgroundColor = UIColor.gray
            
//            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImage(named: "icon_no_server")

            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImage(named: "icon_no_server")

//            cell.detailWidth = 100
//            cell.accessoryWidth = 100
            
            cell.isShowAccsryArrow = true
            
//            cell.labelInterval = 0
            
            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"
//            cell.label.text = "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
//            cell.label.text = "wwwwwwwwwwwwwwwwwwww"
//            cell.label.text = "wwwwwwwwwwwwwwwwwww"
            
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
//            cell.detailLabel.text = "qqqqqqqqqqqqqqqqqqqqqqqq"

//            cell.accsryLabel.backgroundColor = UIColor.green
            
            //接收信
            cell.signalBlock = { (target: Any, signal: Any) in
                let cell = target as! HFlowViewCellHoriValue2
                NSLog("选中%@", cell.label.text ?? "")
            }
            return cell
        case 1:
            let cell = HFlowViewCellHoriValue2(style: .default, reuseIdentifier: "HFlowViewCellHoriValue2")
            cell.backgroundColor = UIColor.gray
            
//            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImage(named: "icon_no_server")
            
            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"

            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
            
            //接收信号
            cell.signalBlock = { (target: Any, signal: Any) in
                let cell = target as! HFlowViewCellHoriValue2
                NSLog("选中%@", cell.label.text ?? "")
            }
            return cell
        case 2:
            let cell = HFlowViewCellHoriValue2(style: .default, reuseIdentifier: "HFlowViewCellHoriValue2")
            cell.backgroundColor = UIColor.gray
            
//            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
//            cell.isShowAccsryArrow = true

            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImage(named: "icon_no_server")

            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImage(named: "icon_no_server")

            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"

            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
        }
        
    }
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        
    }
    
}


