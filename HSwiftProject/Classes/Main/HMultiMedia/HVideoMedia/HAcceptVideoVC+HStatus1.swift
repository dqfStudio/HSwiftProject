//
//  HAcceptVideoVC+HStatus1.swift
//  HSwiftProject
//
//  Created by owner on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HAcceptVideoVC {
    @objc func tupleExa0_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc func tupleExa0_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 0: return CGSizeMake(self.tupleView.width, UIScreen.naviBarHeight+65);
            case 1: return CGSizeMake(self.tupleView.width, UIScreen.height-UIScreen.naviBarHeight-65-30-70-(KAcceptVideoHeight1+25)-40-(KAcceptVideoHeight2+25)-30);
            case 2: return CGSizeMake(self.tupleView.width, 30);
            case 3: return CGSizeMake(self.tupleView.width, 70);
            case 4: return CGSizeMake(self.tupleView.width, KAcceptVideoHeight1+25);
            case 5: return CGSizeMake(self.tupleView.width, 40);
            case 6: return CGSizeMake(self.tupleView.width, KAcceptVideoHeight2+25);
            case 7: return CGSizeMake(self.tupleView.width, 30);
            default:break;
        }
        return CGSizeZero;
    }
    @objc func tupleExa0_tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        switch (indexPath.row) {
            case 0:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let frame = CGRectMake(20, UIScreen.naviBarHeight+15, 30, 30);
                cell.buttonView.frame = frame
                cell.buttonView.setImageWithName("mdeia-reduce")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    self.dismiss(animated: true)
                }
                break;
            case 1:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let bounds: CGRect = cell.layoutViewBounds

                let frame1 = CGRectMake(bounds.size.width/2-40/2, 0, KAcceptVideoHeight2, KAcceptVideoHeight2)
                cell.buttonView.frame = frame1
                cell.buttonView.setImageWithName("mdeia-button")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    self.dismiss(animated: true)
                }
                
                let frame2 = CGRectMake(bounds.size.width/2-40/2, KAcceptVideoHeight2, KAcceptVideoHeight2, 25);
                cell.label.frame = frame2
                cell.label.text = "昵称"
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 12)
                cell.label.textAlignment = .center
                break;
            case 2:
                let cell = itemBlock(nil, HTupleLabelCell.self, nil, true) as! HTupleLabelCell
                cell.label.text = "邀请你视频通话..."
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 14)
                cell.label.textAlignment = .center
                cell.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
                break;
            case 3:
                _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
                break;
            case 4:
                let cell = itemBlock(nil, HTupleViewCell.self, nil, true) as! HTupleViewCell
                let bounds: CGRect = cell.layoutViewBounds

                let frame1 = CGRectMake(bounds.size.width/2-40-KAcceptVideoHeight1, 0, KAcceptVideoHeight1, KAcceptVideoHeight1)
                cell.buttonView.frame = frame1
                cell.buttonView.setImageWithName("mdeia-button")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame2 = CGRectMake(bounds.size.width/2-40-KAcceptVideoHeight1, KAcceptVideoHeight1, KAcceptVideoHeight1, 25)
                cell.label.frame = frame2
                cell.label.text = "翻转"
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 12)
                cell.label.textAlignment = .center
                
                
                let frame3 = CGRectMake(bounds.size.width/2+40, 0, KAcceptVideoHeight1, KAcceptVideoHeight1)
                cell.detailButtonView.frame = frame3
                cell.detailButtonView.setImageWithName("mdeia-button")
                cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame4 = CGRectMake(bounds.size.width/2+32, KAcceptVideoHeight1, KAcceptVideoHeight1+20, 25)
                cell.detailLabel.frame = frame4
                cell.detailLabel.text = "摄像头已开"
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

                let frame1 = CGRectMake(40, 0, KAcceptVideoHeight2, KAcceptVideoHeight2)
                cell.buttonView.frame = frame1
                cell.buttonView.setImageWithName("mdeia-button")
                cell.buttonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame2 = CGRectMake(40, KAcceptVideoHeight2, KAcceptVideoHeight2, 25)
                cell.label.frame = frame2
                cell.label.text = "拒绝"
                cell.label.textColor =  UIColor.white
                cell.label.font  = UIFont.systemFont(ofSize: 12)
                cell.label.textAlignment = .center
                
                
                let frame3 = CGRectMake(bounds.size.width-40-KAcceptVideoHeight2, 0, KAcceptVideoHeight2, KAcceptVideoHeight2)
                cell.detailButtonView.frame = frame3
                cell.detailButtonView.setImageWithName("mdeia-button")
                cell.detailButtonView.pressed = { (_ sender: Any?, _ data: Any?) in
                    
                }
                
                let frame4 = CGRectMake(bounds.size.width-30-(KAcceptVideoHeight2+20), KAcceptVideoHeight2, KAcceptVideoHeight2+20, 25)
                cell.detailLabel.frame = frame4
                cell.detailLabel.text = "接受"
                cell.detailLabel.textColor =  UIColor.white
                cell.detailLabel.font  = UIFont.systemFont(ofSize: 12)
                cell.detailLabel.textAlignment = .center
                break;
            case 7:
                _ = itemBlock(nil, HTupleBlankCell.self, nil, true)
                break;

            default:
                break;
        }
    }
}
