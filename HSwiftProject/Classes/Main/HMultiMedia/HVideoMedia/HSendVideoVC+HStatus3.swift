//
//  HSendVideoVC+HStatus3.swift
//  HSwiftProject
//
//  Created by Wind on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HSendVideoVC {
    @objc
    func tupleExa2_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc
    func tupleExa2_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return CGSize(width: self.tupleView.width, height: UIScreen.naviBarHeight + 65)
        case 1: return CGSize(width: self.tupleView.width, height: UIScreen.height - UIScreen.naviBarHeight - 65 - 30 - 70 - (kSendVideoHeight1 + 25) - 40 - (kSendVideoHeight2 + 25) - 30)
        case 2: return CGSize(width: self.tupleView.width, height: 30)
        case 3: return CGSize(width: self.tupleView.width, height: 70)
        case 4: return CGSize(width: self.tupleView.width, height: kSendVideoHeight1 + 25)
        case 5: return CGSize(width: self.tupleView.width, height: 40)
        case 6: return CGSize(width: self.tupleView.width, height: kSendVideoHeight2 + 25)
        case 7: return CGSize(width: self.tupleView.width, height: 30)
        default:break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa2_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let cell = tuple.cell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let frame = CGRect(x: 20, y: UIScreen.naviBarHeight + 15, width: 30, height: 30)
            cell.buttonView.frame = frame
            cell.buttonView.setImage(WithName: "mdeia-reduce")
            cell.buttonView.pressed = { (sender, data) in
                self.dismiss(animated: true)
            }
            break
        case 1:
            _ = tuple.cell(HTupleBaseCell.self, nil, true, indexPath)
            break
        case 2:
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.text = "暂时无法接通，请稍后尝试..."
            cell.label.textColor = UIColor.white
            cell.label.font = .systemFont(ofSize: 14.0)
            cell.label.textAlignment = .center
            cell.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            break
        case 3:
            _ = tuple.cell(HTupleBaseCell.self, nil, true, indexPath)
            break
        case 4:
            let cell = tuple.cell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - 40 - kSendVideoHeight1, y: 0, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - 40 - kSendVideoHeight1, y: kSendVideoHeight1, width: kSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "翻转"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 + 40, y: 0, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.detailButton.frame = frame3
            cell.detailButton.setImage(WithName: "mdeia-button")
            cell.detailButton.pressed = { (sender, data) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 + 32, y: kSendVideoHeight1, width: kSendVideoHeight1 + 20, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "摄像头已开"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            break
        case 5:
            _ = tuple.cell(HTupleBaseCell.self, nil, true, indexPath)
            break
        case 6:
            let cell = tuple.cell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - kSendVideoHeight2 / 2, y: 0, width: kSendVideoHeight2, height: kSendVideoHeight2)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - kSendVideoHeight2 / 2, y: kSendVideoHeight2, width: kSendVideoHeight2, height: 25)
            cell.label.frame = frame2
            cell.label.text = "挂断"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            break
        case 7:
            _ = tuple.cell(HTupleBaseCell.self, nil, true, indexPath)
            break

        default:
            break
        }
    }

}
