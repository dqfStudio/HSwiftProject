//
//  HAcceptVideoVC+HStatus2.swift
//  HSwiftProject
//
//  Created by owner on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HAcceptVideoVC {
    @objc
    func tupleExa1_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc
    func tupleExa1_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return CGSize(width: self.tupleView.width, height: UIScreen.naviBarHeight + 65)
        case 1: return CGSize(width: self.tupleView.width, height: KAcceptVideoHeight1 * 1.5)
        case 2: return CGSize(width: self.tupleView.width, height: KAcceptVideoHeight1)
        case 3: return CGSize(width: self.tupleView.width, height: UIScreen.height - UIScreen.naviBarHeight - 65 - KAcceptVideoHeight1 * 1.5 - KAcceptVideoHeight1 - (KAcceptVideoHeight1 + 25) - 40 - (KAcceptVideoHeight2 + 25) - 30)
        case 4: return CGSize(width: self.tupleView.width, height: KAcceptVideoHeight1 + 25)
        case 5: return CGSize(width: self.tupleView.width, height: 40)
        case 6: return CGSize(width: self.tupleView.width, height: KAcceptVideoHeight2 + 25)
        case 7: return CGSize(width: self.tupleView.width, height: 30)
        default:break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa1_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
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
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width - 20 - KAcceptVideoHeight1, y: 0, width: KAcceptVideoHeight1, height: KAcceptVideoHeight1 * 1.5)
            cell.buttonView.frame = frame1
            cell.buttonView.backgroundColor = UIColor(hex: "#2C2C2C")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            break
        case 2:
            let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
        
            let bounds: CGRect = cell.layoutViewBounds
            
            let frame1 = CGRect(x: bounds.size.width / 2 - KAcceptVideoHeight1 / 2, y: 0, width: KAcceptVideoHeight1, height: KAcceptVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImageWithName("mdeia-button")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - KAcceptVideoHeight1 / 2, y: KAcceptVideoHeight1, width: KAcceptVideoHeight1, height: 25)
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

            let frame1 = CGRect(x: bounds.size.width / 2 - 40 - KAcceptVideoHeight1, y: 0, width: KAcceptVideoHeight1, height: KAcceptVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImageWithName("mdeia-button")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - 40 - KAcceptVideoHeight1, y: KAcceptVideoHeight1, width: KAcceptVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "麦克风已开"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 + 40, y: 0, width: KAcceptVideoHeight1, height: KAcceptVideoHeight1)
            cell.detailButtonView.frame = frame3
            cell.detailButtonView.setImageWithName("mdeia-button")
            cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 + 32, y: KAcceptVideoHeight1, width: KAcceptVideoHeight1 + 20, height: 25)
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

            let frame1 = CGRect(x: 40, y: 5, width: KAcceptVideoHeight1, height: KAcceptVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImageWithName("mdeia-button")
            cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame2 = CGRect(x: 40, y: KAcceptVideoHeight1 + 5, width: KAcceptVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "翻转"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 - KAcceptVideoHeight2 / 2, y: 0, width: KAcceptVideoHeight2, height: KAcceptVideoHeight2)
            cell.detailButtonView.frame = frame3
            cell.detailButtonView.setImageWithName("mdeia-button")
            cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 - KAcceptVideoHeight2 / 2, y: KAcceptVideoHeight2, width: KAcceptVideoHeight2, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "结束"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            
            let frame5 = CGRect(x: bounds.size.width - 40 - KAcceptVideoHeight1, y: 5, width: KAcceptVideoHeight1, height: KAcceptVideoHeight1)
            cell.accessoryButtonView.frame = frame5
            cell.accessoryButtonView.setImageWithName("mdeia-button")
            cell.accessoryButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                
            }
            
            let frame6 = CGRect(x: bounds.size.width - 38 - KAcceptVideoHeight1, y: KAcceptVideoHeight1 + 5, width: KAcceptVideoHeight1, height: 25)
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
