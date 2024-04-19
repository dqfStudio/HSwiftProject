//
//  HMainController6+Ext.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HMainController6 {

    func ext_tableRow(_ table: HTableView, atIndexPath indexPath: IndexPath) {
        switch (indexPath.row) {
        case 3:
            let cell = table.cell(HTableViewCellHoriValue1.self, nil, true, indexPath) as! HTableViewCellHoriValue1
            cell.backgroundColor = UIColor.gray
            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.label.backgroundColor = UIColor.green
            cell.label.text = "label"
            cell.label.textAlignment = .center

            cell.detailLabel.backgroundColor = UIColor.red
            cell.detailLabel.text = "detailLabel"
            cell.detailLabel.textAlignment = .center
            
            cell.accsryLabel.backgroundColor = UIColor.yellow
            cell.accsryLabel.text = "accessoryLabel"
            cell.accsryLabel.textAlignment = .center
            break
        case 4:
            let cell = table.cell(HTableFieldCell.self, nil, true, indexPath) as! HTableFieldCell
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
            cell.textField.rightButton.pressed = { (sender, data) in
                
            }
            break
        case 5:
            let cell = table.cell(HTableCellValue1.self, nil, true, indexPath) as! HTableCellValue1
            cell.backgroundColor = UIColor.gray
            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.textLabel?.backgroundColor = UIColor.green
            cell.textLabel?.text = "label"
            cell.textLabel?.textAlignment = .center

            cell.detailTextLabel?.backgroundColor = UIColor.red
            cell.detailTextLabel?.text = "detailLabel"
            cell.detailTextLabel?.textAlignment = .center
            break
        case 6:
            let cell = table.cell(HTableCellValue2.self, nil, true, indexPath) as! HTableCellValue2
            cell.backgroundColor = UIColor.gray
            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.textLabel?.backgroundColor = UIColor.green
            cell.textLabel?.text = "label"
            cell.textLabel?.textAlignment = .center

            cell.detailTextLabel?.backgroundColor = UIColor.red
            cell.detailTextLabel?.text = "detailLabel"
            cell.detailTextLabel?.textAlignment = .center
            break
        case 7:
            let cell = table.cell(HTableCellSubtitle.self, nil, true, indexPath) as! HTableCellSubtitle
            cell.backgroundColor = UIColor.gray
            cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
            
            cell.textLabel?.backgroundColor = UIColor.green
            cell.textLabel?.text = "label"
            cell.textLabel?.textAlignment = .center

            cell.detailTextLabel?.backgroundColor = UIColor.red
            cell.detailTextLabel?.text = "detailLabel"
            cell.detailTextLabel?.textAlignment = .center
            break
        default: break
        }
        
    }

}

