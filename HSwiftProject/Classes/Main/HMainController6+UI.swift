//
//  HMainController6+UI.swift
//  HSwiftProject
//
//  Created by owner on 2023/4/3.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HMainController6 {

    func numberOfSectionsInFlowView() -> Int {
        1
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        8
    }

    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        65
    }

    func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let cell = flow.reuseCell(HFlowValueRowCell.self, false, indexPath)
            cell.backgroundColor = UIColor.gray
            cell.contentImageView.backgroundColor = UIColor.red
            cell.contentImageView.setImage(named: "icon_no_server")
            cell.detailImageView.backgroundColor = UIColor.red
            cell.detailImageView.setImage(named: "icon_no_server")
            cell.showsAccessoryArrow = true
            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
            cell.selectBlock = {
                NSLog("选中%@", cell.label.text ?? "")
            }
        case 1:
            let cell = flow.reuseCell(HFlowValueRowCell.self, false, indexPath)
            cell.backgroundColor = UIColor.gray
            cell.contentImageView.backgroundColor = UIColor.red
            cell.contentImageView.setImage(named: "icon_no_server")
            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
            cell.selectBlock = {
                NSLog("选中%@", cell.label.text ?? "")
            }
        case 2:
            let cell = flow.reuseCell(HFlowValueRowCell.self, false, indexPath)
            cell.backgroundColor = UIColor.gray
            cell.contentImageView.backgroundColor = UIColor.red
            cell.contentImageView.setImage(named: "icon_no_server")
            cell.detailImageView.backgroundColor = UIColor.red
            cell.detailImageView.setImage(named: "icon_no_server")
            cell.label.backgroundColor = UIColor.red
            cell.label.text = "wwwwwwwwwwwwww"
            cell.detailLabel.backgroundColor = UIColor.yellow
            cell.detailLabel.text = "qqqqqqqqqqqqq"
        default:
            _ = flow.reuseCell(HFlowBaseCell.self, false, indexPath)
        }
    }
}
