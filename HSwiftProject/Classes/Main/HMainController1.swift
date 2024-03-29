//
//  HMainController1.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController1: HTupleController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional.tup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.leftNaviButton.isHidden = true
        self.title = "第一页"
        self.tupleView.delegate = self
    }

    func numberOfSectionsInTupleView() -> Any {
        return 1
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        return 8
    }
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    func colorForSection(_ section: Any) -> UIColor {
        return UIColor.red
    }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch indexPath.row {
        case 0:
            return CGSizeMake(self.tupleView.widthForSection(indexPath.section), 65)
        case 1:
            return CGSizeMake(self.tupleView.widthForSection(indexPath.section), 65)
        case 2:
            return CGSizeMake(self.tupleView.widthForSection(indexPath.section), 65)
        case 3:
            var width: CGFloat = self.tupleView.widthForSection(indexPath.section)
            width = self.tupleView.fixSlitWith(width, colCount: 3, index: indexPath.row-3)
            return CGSizeMake(width, 120)
        case 4:
            var width: CGFloat = self.tupleView.widthForSection(indexPath.section)
            width = self.tupleView.fixSlitWith(width, colCount: 3, index: indexPath.row-3)
            return CGSizeMake(width, 120)
        case 5:
            var width: CGFloat = self.tupleView.widthForSection(indexPath.section)
            width = self.tupleView.fixSlitWith(width, colCount: 3, index: indexPath.row-3)
            return CGSizeMake(width, 120)
        default:
            return CGSizeMake(self.tupleView.widthForSection(indexPath.section), 65)
        }
    }
    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        switch (indexPath.row) {
            case 3:
                return UIEdgeInsetsMake(10, 10, 10, 5)
            case 4:
                return UIEdgeInsetsMake(10, 5, 10, 5)
            case 5:
                return UIEdgeInsetsMake(10, 5, 10, 10)
            default:
                return UIEdgeInsetsMake(10, 10, 10, 10)
        }
    }
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        
        switch indexPath.row {
            case 0:
                let cell = itemBlock(nil, HTupleViewCellHoriValue4.self, nil, true) as! HTupleViewCellHoriValue4
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")

                cell.detailView.backgroundColor = UIColor.red
                cell.detailView.setImageWithName("icon_no_server")

    //            cell.detailWidth = 100
    //            cell.accessoryWidth = 100

                cell.showAccessoryArrow = true

    //            cell.labelInterval = 0

                cell.label.backgroundColor = UIColor.red
                cell.label.text = "wwwwwwwwwwwwww"
    //            cell.label.text:"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"
    //            cell.label.text:"wwwwwwwwwwwwwwwwwwww"
    //            cell.label.text:"wwwwwwwwwwwwwwwwwww"

                cell.detailLabel.backgroundColor = UIColor.yellow
                cell.detailLabel.text = "qqqqqqqqqqqqq"
    //            cell.detailLabel.text:"qqqqqqqqqqqqqqqqqqqqqqqq"

    //            cell.accessoryLabel.backgroundColor = UIColor.green

                //接收信号
                cell.signalBlock = { (target, signal) in
                    let cell = target as! HTupleViewCellHoriValue4
                    NSLog("选中%d",cell.label)
                }
            case 1:
                let cell = itemBlock(nil, HTupleViewCellHoriValue4.self, nil, true) as! HTupleViewCellHoriValue4
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")

                cell.label.backgroundColor = UIColor.red

                cell.detailLabel.backgroundColor = UIColor.yellow

                //接收信号
                cell.signalBlock = { (target, signal) in
                    let cell = target as! HTupleViewCellHoriValue4
                    NSLog("选中%d",cell.label)
                }
            case 2:
                let cell = itemBlock(nil, HTupleViewCellHoriValue4.self, nil, true) as! HTupleViewCellHoriValue4
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

    //            cell.showAccessoryArrow = true

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")

                cell.detailView.backgroundColor = UIColor.red
                cell.detailView.setImageWithName("icon_no_server")

                cell.label.backgroundColor = UIColor.red

                cell.detailLabel.backgroundColor = UIColor.yellow
            case 3:
                let cell = itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 0)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")
                cell.imageView.fillet = true

                cell.labelHeight = 25
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
            case 4:
                let cell = itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")
                cell.imageView.fillet = true

                cell.labelHeight = 25
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
            case 5:
                let cell = itemBlock(nil, HTupleViewCellVertValue1.self, nil, true) as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(0, 10)

                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImageWithName("icon_no_server")
                cell.imageView.fillet = true

                cell.labelHeight = 25
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
            
                cell.didSelectCell = { (target, indexPath) in
                    let cell = target as! HTupleViewCellVertValue1
                    NSLog("选中黑客帝国%d",cell.labelHeight)
                    let navi = HNavigationController.init(rootViewController: HLiveRoomVC.init())
                    UIApplication.navi?.present(navi, animated: true, completion: nil)
                }
            case 6:
                let cell = itemBlock(nil, HTupleViewCellHoriValue3.self, nil, true) as! HTupleViewCellHoriValue3
                cell.backgroundColor = UIColor.gray
                cell.isShouldShowSeparator = true
                cell.separatorInset = UILREdgeInsetsMake(10, 10)

                cell.detailWidth  = cell.layoutViewBounds.width/3
                cell.accessoryWidth = cell.layoutViewBounds.width/3
                cell.label.backgroundColor = UIColor.green
                cell.label.text = "label"
                cell.label.textAlignment = .center

                cell.detailLabel.backgroundColor = UIColor.red
                cell.detailLabel.text = "detailLabel"
                cell.detailLabel.textAlignment = .center

                cell.accessoryLabel.backgroundColor = UIColor.yellow
                cell.accessoryLabel.text = "accessoryLabel"
                cell.accessoryLabel.textAlignment = .center
            case 7:
                let cell = itemBlock(nil, HTupleTextFieldCell.self, nil, true) as! HTupleTextFieldCell
                cell.backgroundColor = UIColor.gray
                cell.textField.backgroundColor = UIColor.red

                cell.textField.leftWidth = 50
                cell.textField.leftLabel.textAlignment = .center
                cell.textField.leftLabel.text = "验证码"
                cell.textField.leftLabel.backgroundColor = UIColor.green

                cell.textField.placeholder = "请输入验证码"
                cell.textField.placeholderColor = UIColor.white
                cell.textField.textColor = UIColor.white

                cell.textField.rightWidth = 90
                //普通view
//                cell.textField.rightButton.text = "获取验证码"
//                cell.textField.rightButton.backgroundColor = UIColor.green
//                cell.textField.rightButton.pressed = { (sender: AnyObject, data: AnyObject) in
//
//                } as? callback
                //短信验证码
                cell.textField.rightCountDownButton.text = "获取验证码";
                cell.textField.rightCountDownButton.backgroundColor = UIColor.green
                cell.textField.rightCountDownButton.countDownButtonHandler { (countDownButton, tag) in
                    countDownButton.startCountDownWithSecond(60)
                }
                cell.textField.rightCountDownButton.countDownChanging({ (countDownButton, second) -> NSString in
                    return NSString(format: "还剩%lu秒",second)
                })
                cell.textField.rightCountDownButton .countDownFinished { (countDownButton, second) -> NSString in
                    return "重新获取"
                }
                //图形验证码
//                cell.textField.rightVerifyCodeView.backgroundColor = UIColor.green
//                cell.textField.rightVerifyCodeView.textSize = 20
//                cell.textField.rightVerifyCodeView.textColor = UIColor.black
//                cell.textField.rightVerifyCodeView.charsArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            
            default: break
        }
    }
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {

    }
        
}
