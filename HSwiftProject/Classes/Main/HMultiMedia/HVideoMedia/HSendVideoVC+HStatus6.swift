//
//  HSendVideoVC+HStatus6.swift
//  HSwiftProject
//
//  Created by Wind on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HSendVideoVC {
    @objc
    func tupleExa5_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc
    func tupleExa5_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return CGSize(width: self.tupleView.width, height: UIScreen.naviBarHeight + 65)
        case 1: return CGSize(width: self.tupleView.width, height: kSendVideoHeight1 * 1.5)
        case 2: return CGSize(width: self.tupleView.width, height: kSendVideoHeight1)
        case 3: return CGSize(width: self.tupleView.width, height: UIScreen.height - UIScreen.naviBarHeight - 65 - kSendVideoHeight1 * 1.5 - kSendVideoHeight1 - (kSendVideoHeight1 + 25) - 40 - (kSendVideoHeight2 + 25) - 30)
        case 4: return CGSize(width: self.tupleView.width, height: kSendVideoHeight1 + 25)
        case 5: return CGSize(width: self.tupleView.width, height: 40)
        case 6: return CGSize(width: self.tupleView.width, height: kSendVideoHeight2 + 25)
        case 7: return CGSize(width: self.tupleView.width, height: 30)
        default:break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa5_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(HTupleViewCell.self, nil, true) as! HTupleViewCell
            let frame = CGRect(x: 20, y: UIScreen.naviBarHeight + 15, width: 30, height: 30)
            cell.buttonView.frame = frame
            cell.buttonView.setImage(WithName: "mdeia-reduce")
            cell.buttonView.pressed = { (sender, data) in
                self.dismiss(animated: true)
            }
            break
        case 1:
            let cell = itemBlock(HTupleViewCell.self, nil, true) as! HTupleViewCell

            let bounds = cell.layoutViewBounds
            
            let frame1 = CGRect(x: bounds.size.width - 20 - kSendVideoHeight1, y: 0, width: kSendVideoHeight1, height: kSendVideoHeight1 * 1.5)
            cell.buttonView.frame = frame1
            cell.buttonView.backgroundColor = UIColor(hex: "#2C2C2C")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            break
        case 2:
            let cell = itemBlock(HTupleViewCell.self, nil, true) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - kSendVideoHeight1 / 2, y: 0, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
        let frame2 = CGRect(x: bounds.size.width / 2 - kSendVideoHeight1 / 2, y: kSendVideoHeight1, width: kSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "昵称"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            break
        case 3:
            _ = itemBlock(HTupleBaseCell.self, nil, true)
            break
        case 4:
            let cell = itemBlock(HTupleViewCell.self, nil, true) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - 40 - kSendVideoHeight1, y: 0, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - 40 - kSendVideoHeight1, y: kSendVideoHeight1, width: kSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "麦克风已开"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 + 40, y: 0, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.detailButtonView.frame = frame3
            cell.detailButtonView.setImage(WithName: "mdeia-button")
            cell.detailButtonView.pressed = { (sender, data) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 + 32, y: kSendVideoHeight1, width: kSendVideoHeight1 + 20, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "扬声器已关"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            break
        case 5:
            _ = itemBlock(HTupleBaseCell.self, nil, true)
            break
        case 6:
            let cell = itemBlock(HTupleViewCell.self, nil, true) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: 40, y: 5, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: 40, y: kSendVideoHeight1 + 5, width: kSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "翻转"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 - kSendVideoHeight2 / 2, y: 0, width: kSendVideoHeight2, height: kSendVideoHeight2)
            cell.detailButtonView.frame = frame3
            cell.detailButtonView.setImage(WithName: "mdeia-button")
            cell.detailButtonView.pressed = { (sender, data) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 - kSendVideoHeight2 / 2, y: kSendVideoHeight2, width: kSendVideoHeight2, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "结束"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            
            let frame5 = CGRect(x: bounds.size.width - 40 - kSendVideoHeight1, y: 5, width: kSendVideoHeight1, height: kSendVideoHeight1)
            cell.accessoryButtonView.frame = frame5
            cell.accessoryButtonView.setImage(WithName: "mdeia-button")
            cell.accessoryButtonView.pressed = { (sender, data) in
                
            }
            
            let frame6 = CGRect(x: bounds.size.width - 38 - kSendVideoHeight1, y: kSendVideoHeight1 + 5, width: kSendVideoHeight1, height: 25)
            cell.accessoryLabel.frame = frame6
            cell.accessoryLabel.text = "摄像头已开"
            cell.accessoryLabel.textColor = UIColor.white
            cell.accessoryLabel.font = UIFont.systemFont(ofSize: 12)
            cell.accessoryLabel.textAlignment = .center
            break
        case 7:
            _ = itemBlock(HTupleBaseCell.self, nil, true)
            break

        default:
            break
        }
    }
}
