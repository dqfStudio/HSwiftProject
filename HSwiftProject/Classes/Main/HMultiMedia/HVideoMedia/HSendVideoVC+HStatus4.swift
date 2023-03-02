//
//  HSendVideoVC+HStatus4.swift
//  HSwiftProject
//
//  Created by owner on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HSendVideoVC {
    @objc
    func tupleExa3_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc
    func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return CGSize(width: self.tupleView.width, height: UIScreen.naviBarHeight + 65)
        case 1: return CGSize(width: self.tupleView.width, height: KSendVideoHeight1 * 1.5)
        case 2: return CGSize(width: self.tupleView.width, height: KSendVideoHeight1)
        case 3: return CGSize(width: self.tupleView.width, height: UIScreen.height - UIScreen.naviBarHeight - 65 - KSendVideoHeight1 * 1.5 - KSendVideoHeight1 - (KSendVideoHeight1 + 25) - 40 - (KSendVideoHeight2 + 25) - 30)
        case 4: return CGSize(width: self.tupleView.width, height: KSendVideoHeight1 + 25)
        case 5: return CGSize(width: self.tupleView.width, height: 40)
        case 6: return CGSize(width: self.tupleView.width, height: KSendVideoHeight2 + 25)
        case 7: return CGSize(width: self.tupleView.width, height: 30)
        default:break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa3_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
        case 0:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
            let frame = CGRect(x: 20, y: UIScreen.naviBarHeight + 15, width: 30, height: 30)
            cell.buttonView.frame = frame
            cell.buttonView.setImageWithName("mdeia-reduce")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                self.dismiss(animated: true)
            }
            break
        case 1:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell

            let bounds = cell.layoutViewBounds
            
            let frame1 = CGRect(x: bounds.size.width - 20 - KSendVideoHeight1, y: 0, width: KSendVideoHeight1, height: KSendVideoHeight1 * 1.5)
            cell.buttonView.frame = frame1
            cell.buttonView.backgroundColor = UIColor(hex: "#2C2C2C")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            break
        case 2:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - KSendVideoHeight1 / 2, y: 0, width: KSendVideoHeight1, height: KSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImageWithName("mdeia-button")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - KSendVideoHeight1 / 2, y: KSendVideoHeight1, width: KSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "昵称"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            break
        case 3:
            _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
            break
        case 4:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - 40 - KSendVideoHeight1, y: 0, width: KSendVideoHeight1, height: KSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImageWithName("mdeia-button")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - 40 - KSendVideoHeight1, y: KSendVideoHeight1, width: KSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "麦克风已开"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 + 40, y: 0, width: KSendVideoHeight1, height: KSendVideoHeight1)
            cell.detailButtonView.frame = frame3
            cell.detailButtonView.setImageWithName("mdeia-button")
            cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 + 32, y: KSendVideoHeight1, width: KSendVideoHeight1 + 20, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "扬声器已关"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            break
        case 5:
            _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
            break
        case 6:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: 40, y: 5, width: KSendVideoHeight1, height: KSendVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImageWithName("mdeia-button")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame2 = CGRect(x: 40, y: KSendVideoHeight1 + 5, width: KSendVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "翻转"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 - KSendVideoHeight2 / 2, y: 0, width: KSendVideoHeight2, height: KSendVideoHeight2)
            cell.detailButtonView.frame = frame3
            cell.detailButtonView.setImageWithName("mdeia-button")
            cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 - KSendVideoHeight2 / 2, y: KSendVideoHeight2, width: KSendVideoHeight2, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "结束"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            
            let frame5 = CGRect(x: bounds.size.width - 40 - KSendVideoHeight1, y: 5, width: KSendVideoHeight1, height: KSendVideoHeight1)
            cell.accessoryButtonView.frame = frame5
            cell.accessoryButtonView.setImageWithName("mdeia-button")
            cell.accessoryButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame6 = CGRect(x: bounds.size.width - 38 - KSendVideoHeight1, y: KSendVideoHeight1 + 5, width: KSendVideoHeight1, height: 25)
            cell.accessoryLabel.frame = frame6
            cell.accessoryLabel.text = "摄像头已开"
            cell.accessoryLabel.textColor = UIColor.white
            cell.accessoryLabel.font = UIFont.systemFont(ofSize: 12)
            cell.accessoryLabel.textAlignment = .center
            break
        case 7:
            _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
            break

        default:
            break
        }
    }
}
