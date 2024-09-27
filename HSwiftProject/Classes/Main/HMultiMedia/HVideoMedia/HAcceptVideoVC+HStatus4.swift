//
//  HAcceptVideoVC+HStatus4.swift
//  HSwiftProject
//
//  Created by Wind on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension HAcceptVideoVC {
    @objc
    func tupleExa3_numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    @objc
    func tupleExa3_sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
        case 0: return CGSize(width: self.tupleView.width, height: UIScreen.naviBarHeight + 65)
        case 1: return CGSize(width: self.tupleView.width, height: kAcceptVideoHeight1 * 1.5)
        case 2: return CGSize(width: self.tupleView.width, height: kAcceptVideoHeight1)
        case 3: return CGSize(width: self.tupleView.width, height: UIScreen.height - UIScreen.naviBarHeight - 65 - kAcceptVideoHeight1 * 1.5 - kAcceptVideoHeight1 - (kAcceptVideoHeight1 + 25) - 40 - (kAcceptVideoHeight2 + 25) - 30)
        case 4: return CGSize(width: self.tupleView.width, height: kAcceptVideoHeight1 + 25)
        case 5: return CGSize(width: self.tupleView.width, height: 40)
        case 6: return CGSize(width: self.tupleView.width, height: kAcceptVideoHeight2 + 25)
        case 7: return CGSize(width: self.tupleView.width, height: 30)
        default:break
        }
        return CGSize.zero
    }
    @objc
    func tupleExa3_tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let frame = CGRect(x: 20, y: UIScreen.naviBarHeight + 15, width: 30, height: 30)
            cell.buttonView.frame = frame
            cell.buttonView.setImage(WithName: "mdeia-reduce")
            cell.buttonView.pressed = { (sender, data) in
                self.dismiss(animated: true)
            }
            break
        case 1:
            let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width - 20 - kAcceptVideoHeight1, y: 0, width: kAcceptVideoHeight1, height: kAcceptVideoHeight1 * 1.5)
            cell.buttonView.frame = frame1
            cell.buttonView.backgroundColor = UIColor(hex: "#2C2C2C")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            break
        case 2:
            let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds
            
            let frame1 = CGRect(x: bounds.size.width / 2 - kAcceptVideoHeight1 / 2, y: 0, width: kAcceptVideoHeight1, height: kAcceptVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - kAcceptVideoHeight1 / 2, y: kAcceptVideoHeight1, width: kAcceptVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "昵称"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            break
        case 3:
            _ = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath)
            break
        case 4:
            let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: bounds.size.width / 2 - 40 - kAcceptVideoHeight1, y: 0, width: kAcceptVideoHeight1, height: kAcceptVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: bounds.size.width / 2 - 40 - kAcceptVideoHeight1, y: kAcceptVideoHeight1, width: kAcceptVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "麦克风已开"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 + 40, y: 0, width: kAcceptVideoHeight1, height: kAcceptVideoHeight1)
            cell.detailButton.frame = frame3
            cell.detailButton.setImage(WithName: "mdeia-button")
            cell.detailButton.pressed = { (sender, data) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 + 32, y: kAcceptVideoHeight1, width: kAcceptVideoHeight1 + 20, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "扬声器已关"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            break
        case 5:
            _ = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath)
            break
        case 6:
            let cell = tuple.reuseCell(HTupleViewCell.self, nil, true, indexPath) as! HTupleViewCell
            let bounds: CGRect = cell.layoutViewBounds

            let frame1 = CGRect(x: 40, y: 5, width: kAcceptVideoHeight1, height: kAcceptVideoHeight1)
            cell.buttonView.frame = frame1
            cell.buttonView.setImage(WithName: "mdeia-button")
            cell.buttonView.pressed = { (sender, data) in
                
            }
            
            let frame2 = CGRect(x: 40, y: kAcceptVideoHeight1 + 5, width: kAcceptVideoHeight1, height: 25)
            cell.label.frame = frame2
            cell.label.text = "翻转"
            cell.label.textColor = UIColor.white
            cell.label.font = UIFont.systemFont(ofSize: 12)
            cell.label.textAlignment = .center
            
            
            let frame3 = CGRect(x: bounds.size.width / 2 - kAcceptVideoHeight2 / 2, y: 0, width: kAcceptVideoHeight2, height: kAcceptVideoHeight2)
            cell.detailButton.frame = frame3
            cell.detailButton.setImage(WithName: "mdeia-button")
            cell.detailButton.pressed = { (sender, data) in
                
            }
            
            let frame4 = CGRect(x: bounds.size.width / 2 - kAcceptVideoHeight2 / 2, y: kAcceptVideoHeight2, width: kAcceptVideoHeight2, height: 25)
            cell.detailLabel.frame = frame4
            cell.detailLabel.text = "结束"
            cell.detailLabel.textColor = UIColor.white
            cell.detailLabel.font = UIFont.systemFont(ofSize: 12)
            cell.detailLabel.textAlignment = .center
            
            let frame5 = CGRect(x: bounds.size.width - 40 - kAcceptVideoHeight1, y: 5, width: kAcceptVideoHeight1, height: kAcceptVideoHeight1)
            cell.accsryButton.frame = frame5
            cell.accsryButton.setImage(WithName: "mdeia-button")
            cell.accsryButton.pressed = { (sender, data) in
                
            }
            
            let frame6 = CGRect(x: bounds.size.width - 38 - kAcceptVideoHeight1, y: kAcceptVideoHeight1 + 5, width: kAcceptVideoHeight1, height: 25)
            cell.accsryLabel.frame = frame6
            cell.accsryLabel.text = "摄像头已开"
            cell.accsryLabel.textColor = UIColor.white
            cell.accsryLabel.font = UIFont.systemFont(ofSize: 12)
            cell.accsryLabel.textAlignment = .center
            break
        case 7:
            _ = tuple.reuseCell(HTupleTmplCell.self, nil, true, indexPath)
            break

        default:
            break
        }
    }

}
