//
//  HMainController6+Ext.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HMainController6 {

    func ext_tableRow(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTableRow
        switch (indexPath.row) {
        case 3:
            let cell = itemBlock(nil, HTableViewCellHoriValue1.self, nil, true) as! HTableViewCellHoriValue1
            cell.backgroundColor = UIColor.gray
            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.label.backgroundColor = UIColor.green
            cell.label.text = "label"
            cell.label.textAlignment = .center

            cell.detailLabel.backgroundColor = UIColor.red
            cell.detailLabel.text = "detailLabel"
            cell.detailLabel.textAlignment = .center
            
            cell.accessoryLabel.backgroundColor = UIColor.yellow
            cell.accessoryLabel.text = "accessoryLabel"
            cell.accessoryLabel.textAlignment = .center
            break
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
            break
        default: break
        }
        
    }

}

