//
//  HCollDropVC+Extern.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

extension HCollDropVC {
    @discardableResult
    static func showPacketSheet(_ containVip: Bool, completion: @escaping (_ actionStyle: Int) -> Void) -> HCollDropVC {
        let dropVC = HCollDropVC(topSpacing: 0)
        dropVC.numberBlock = {
            return containVip ? 4 : 3
        }
        dropVC.heightBlock = { index in
            return 56
        }
        dropVC.itemBlock = { (coll: HCollView, indexPath: IndexPath) in
            let cell = coll.reuseCell(HCollLabelCell.self, true, indexPath)
            cell.edgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            cell.label.font = UIFont.font(ofSize: 16, weight: .regular)
            cell.label.textAlignment = .center
            cell.label.textColor = UIColor.white
            
            switch indexPath.row {
            case 0:
                cell.label.text = "平均红包".localized()
            case 1:
                cell.label.text = "随机红包".localized()
            case 2:
                cell.label.text = "口令红包".localized()
            case 3:
                cell.label.text = "会员红包".localized()
            default:
                break
            }
            
            cell.selectBlock = {
                dropVC.naviBack()
                completion(indexPath.row)
            }
        }
        return dropVC
    }
}
