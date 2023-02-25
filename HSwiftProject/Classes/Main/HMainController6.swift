//
//  HMainController6.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController6: HTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.tableView.delegate = self
    }

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
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    func tableRow(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTableRow
        
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTableViewCellHoriValue4.self, nil, true) as! HTableViewCellHoriValue4
            cell.backgroundColor = UIColor.gray
            cell.isShouldShowSeparator = true
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImageWithName("icon_no_server")

            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImageWithName("icon_no_server")

//            cell.detailWidth = 100
//            cell.accessoryWidth = 100
            
            cell.showAccessoryArrow = true
            
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
                NSLog("选中%d",cell.label)
            }
            break;
        case 1:
            let cell = itemBlock(nil, HTableViewCellHoriValue4.self, nil, true) as! HTableViewCellHoriValue4
            cell.backgroundColor = UIColor.gray
            cell.isShouldShowSeparator = true
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            
            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImageWithName("icon_no_server")
            
            cell.label.backgroundColor = UIColor.red

            cell.detailLabel.backgroundColor = UIColor.yellow
            
            //接收信号
            cell.signalBlock = { (target, signal) in
                let cell = target as! HTableViewCellHoriValue4
                NSLog("选中%d",cell.label)
            }
            break;
        case 2:
            let cell = itemBlock(nil, HTableViewCellHoriValue4.self, nil, true) as! HTableViewCellHoriValue4
            cell.backgroundColor = UIColor.gray
            cell.isShouldShowSeparator = true
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            
//            cell.showAccessoryArrow = true

            cell.imageView.backgroundColor = UIColor.red
            cell.imageView.setImageWithName("icon_no_server")

            cell.detailView.backgroundColor = UIColor.red
            cell.detailView.setImageWithName("icon_no_server")

            cell.label.backgroundColor = UIColor.red

            cell.detailLabel.backgroundColor = UIColor.yellow
            break;
        case 3:
            let cell = itemBlock(nil, HTableViewCellHoriValue3.self, nil, true) as! HTableViewCellHoriValue3
            cell.backgroundColor = UIColor.gray
            cell.isShouldShowSeparator = true
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
            
            cell.detailWidth  = cell.layoutViewBounds.width/3
            cell.accessoryWidth = cell.layoutViewBounds.width/3
            cell.label.backgroundColor = UIColor.green
            cell.label.text = "label"
            cell.label.textAlignment = .center

            cell.detailLabel.backgroundColor = UIColor.red
            cell.detailLabel.text = "detailLabel"
            cell.detailLabel.textAlignment = .center
            
            cell.accessoryLabel.backgroundColor = UIColor.yellow
            cell.accessoryLabel.text = "accessoryLabel"
            cell.accessoryLabel.textAlignment = .center
            break;
        case 4:
            let cell = itemBlock(nil, HTableTextFieldCell.self, nil, true) as! HTableTextFieldCell
            cell.backgroundColor = UIColor.gray
            cell.textField.backgroundColor = UIColor.red
            
            cell.textField.leftWidth = 50
            cell.textField.leftLabel.textAlignment = .center
            cell.textField.leftLabel.text = "验证码"
            cell.textField.leftLabel.backgroundColor = UIColor.green
            
            cell.textField.placeholder = "请输入验证码"
            cell.textField.placeholderColor = UIColor.white
            cell.textField.textColor = UIColor.white
            
            cell.textField.rightWidth = 90
            cell.textField.rightButton.text = "获取验证码"
            cell.textField.rightButton.backgroundColor = UIColor.green
            cell.textField.rightButton.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            break;
        default: break
        }
        
    }
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        
    }

}
