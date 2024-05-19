//
//  HTupleSheetVC+Extern.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

extension HTupleSheetVC {
    @discardableResult
    static func showPacketSheet(_ containVip: Bool, completion: @escaping (_ actionStyle: Int) -> Void) -> HTupleSheetVC {
        let sheetVC = HTupleSheetVC(bottomSpacing: 8)
        sheetVC.numberBlock = {
            return containVip ? 5 : 4
        }
        sheetVC.heightBlock = { index in
            if index == 0 {
                return 28
            }
            return 56
        }
        sheetVC.itemBlock = { (tuple: HTupleView, indexPath: IndexPath) in
            if indexPath.row == 0 {
                let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
                let frame = cell.layoutViewBounds
                cell.label.frame = CGRect(x: (frame.width - 38) / 2, y: 8, width: 38, height: 4)
                //cell.label.backgroundColor = UIColor.color272729
                cell.label.cornerRadius = 2
            }else {
                let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
                cell.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
                cell.label.font = UIFont.font(ofSize: 16, weight: .regular)
                cell.label.textAlignment = .center
                cell.label.textColor = UIColor.white
                
                switch indexPath.row {
                case 1:
                    cell.label.text = "平均红包".localized()
                case 2:
                    cell.label.text = "随机红包".localized()
                case 3:
                    cell.label.text = "口令红包".localized()
                case 4:
                    cell.label.text = "会员红包".localized()
                default:
                    break
                }
                
                cell.selectBlock = {
                    sheetVC.naviBack()
                    completion(indexPath.row - 1)
                }
            }
        }
        return sheetVC
    }
}
