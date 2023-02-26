//
//  HSendVideoVC+HStatus4.swift
//  HSwiftProject
//
//  Created by owner on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HSendVideoVC {
    @objc func tupleExa3_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 0: return CGSizeMake(self.tupleView.width, UIScreen.naviBarHeight+65);
            case 1: return CGSizeMake(self.tupleView.width, KSendVideoHeight1*1.5);
            case 2: return CGSizeMake(self.tupleView.width, KSendVideoHeight1);
            case 3: return CGSizeMake(self.tupleView.width, UIScreen.height-UIScreen.naviBarHeight-65-KSendVideoHeight1*1.5-KSendVideoHeight1-(KSendVideoHeight1+25)-40-(KSendVideoHeight2+25)-30);
            case 4: return CGSizeMake(self.tupleView.width, KSendVideoHeight1+25);
            case 5: return CGSizeMake(self.tupleView.width, 40);
            case 6: return CGSizeMake(self.tupleView.width, KSendVideoHeight2+25);
            case 7: return CGSizeMake(self.tupleView.width, 30);
            default:break;
        }
        return CGSizeZero
    }
    @objc func tupleExa3_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
            case 0:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let frame = CGRectMake(20, UIScreen.naviBarHeight+15, 30, 30)
                cell.buttonView.frame = frame
                cell.buttonView.setImageWithName("mdeia-reduce")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    self.dismiss(animated: true)
                }
                break;
            case 1:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell

                let bounds = cell.layoutViewBounds;
                
                let frame1 = CGRectMake(bounds.size.width-20-KSendVideoHeight1, 0, KSendVideoHeight1, KSendVideoHeight1*1.5)
                cell.buttonView.frame = frame1
                cell.buttonView.backgroundColor = UIColor.init(hex: "#2C2C2C")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                break;
            case 2:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let bounds: CGRect = cell.layoutViewBounds

                let frame1 = CGRectMake(bounds.size.width/2-KSendVideoHeight1/2, 0, KSendVideoHeight1, KSendVideoHeight1)
                cell.buttonView.frame = frame1
                cell.buttonView.setImageWithName("mdeia-button")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame2 = CGRectMake(bounds.size.width/2-KSendVideoHeight1/2, KSendVideoHeight1, KSendVideoHeight1, 25)
                cell.label.frame = frame2
                cell.label.text = "昵称"
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 12)
                cell.label.textAlignment = .center
                break;
            case 3:
                _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
                break;
            case 4:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let bounds: CGRect = cell.layoutViewBounds

                let frame1 = CGRectMake(bounds.size.width/2-40-KSendVideoHeight1, 0, KSendVideoHeight1, KSendVideoHeight1)
                cell.buttonView.frame = frame1
                cell.buttonView.setImageWithName("mdeia-button")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame2 = CGRectMake(bounds.size.width/2-40-KSendVideoHeight1, KSendVideoHeight1, KSendVideoHeight1, 25)
                cell.label.frame = frame2
                cell.label.text = "麦克风已开"
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 12)
                cell.label.textAlignment = .center
                
                
                let frame3 = CGRectMake(bounds.size.width/2+40, 0, KSendVideoHeight1, KSendVideoHeight1)
                cell.detailButtonView.frame = frame3
                cell.detailButtonView.setImageWithName("mdeia-button")
                cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame4 = CGRectMake(bounds.size.width/2+32, KSendVideoHeight1, KSendVideoHeight1+20, 25)
                cell.detailLabel.frame = frame4
                cell.detailLabel.text = "扬声器已关"
                cell.detailLabel.textColor =  UIColor.white
                cell.detailLabel.font  = UIFont.systemFont(ofSize: 12)
                cell.detailLabel.textAlignment = .center
                break;
            case 5:
                _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
                break;
            case 6:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let bounds: CGRect = cell.layoutViewBounds

                let frame1 = CGRectMake(40, 5, KSendVideoHeight1, KSendVideoHeight1)
                cell.buttonView.frame = frame1
                cell.buttonView.setImageWithName("mdeia-button")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame2 = CGRectMake(40, KSendVideoHeight1+5, KSendVideoHeight1, 25)
                cell.label.frame = frame2
                cell.label.text = "翻转"
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 12)
                cell.label.textAlignment = .center
                
                
                let frame3 = CGRectMake(bounds.size.width/2-KSendVideoHeight2/2, 0, KSendVideoHeight2, KSendVideoHeight2)
                cell.detailButtonView.frame = frame3
                cell.detailButtonView.setImageWithName("mdeia-button")
                cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame4 = CGRectMake(bounds.size.width/2-KSendVideoHeight2/2, KSendVideoHeight2, KSendVideoHeight2, 25)
                cell.detailLabel.frame = frame4
                cell.detailLabel.text = "结束"
                cell.detailLabel.textColor =  UIColor.white
                cell.detailLabel.font  = UIFont.systemFont(ofSize: 12)
                cell.detailLabel.textAlignment = .center
                
                let frame5 = CGRectMake(bounds.size.width-40-KSendVideoHeight1, 5, KSendVideoHeight1, KSendVideoHeight1)
                cell.accessoryButtonView.frame = frame5
                cell.accessoryButtonView.setImageWithName("mdeia-button")
                cell.accessoryButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame6 = CGRectMake(bounds.size.width-38-KSendVideoHeight1, KSendVideoHeight1+5, KSendVideoHeight1, 25)
                cell.accessoryLabel.frame = frame6
                cell.accessoryLabel.text = "摄像头已开"
                cell.accessoryLabel.textColor =  UIColor.white
                cell.accessoryLabel.font  = UIFont.systemFont(ofSize: 12)
                cell.accessoryLabel.textAlignment = .center
                break;
            case 7:
                _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
                break;

            default:
                break;
        }
    }
}
