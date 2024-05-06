//
//  HFlowDropVC+Extern.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

extension HFlowDropVC {
    @discardableResult
    static func showPacketSheet(_ containVip: Bool, completion: @escaping (_ actionStyle: Int) -> Void) -> HFlowDropVC {
        let dropVC = HFlowDropVC(topSpacing: 0)
        dropVC.numberBlock = {
            return containVip ? 4 : 3
        }
        dropVC.heightBlock = { index in
            return 56
        }
        dropVC.itemBlock = { (tuple: HTupleView, indexPath: IndexPath) in
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
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
