//
//  HMainController1.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController1: HTupleController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional.tup after loading the view.
        self.title = "第一页"
        self.navigationBar.leftItem.isHidden = true
        self.tupleView.delegate = self
        self.tupleView.tupleStatus = .block
        extendedInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.bottomBarHeight + 30, right: 0)
    }
        
}

//extension HMainController1 {
//
//    func numberOfSectionsInTupleView() -> Any {
//        return 2
//    }
//    func numberOfItemsInSection(_ section: Any) -> Any {
//        switch section as! Int {
//        case 0:
//            return 5
//        case 1:
//            return 9
//        default:
//            return 1
//        }
//    }
//    func insetForSection(_ section: Any) -> Any {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
//    func colorForSection(_ section: Any) -> UIColor {
//        return UIColor.red
//    }
//    func minimumLineSpacingForSectionAt(_ section: Any) -> Any {
//        switch section as! Int {
//        case 1:
//            return 8
//        default:
//            return 0
//        }
//    }
//    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        switch indexPath.section {
//        case 0:
//            switch indexPath.row {
//            case 0:
//                return CGSize(width: self.tupleView.width, height: 130)
//            case 1:
//                let width = self.tupleView.width(forSection: indexPath.section)
//                return CGSize(width: width, height: 65)
//            case 2:
//                let width = self.tupleView.width(forSection: indexPath.section)
//                return CGSize(width: width, height: 65)
//            case 3:
//                let width = self.tupleView.width(forSection: indexPath.section)
//                return CGSize(width: width, height: 65)
//            case 4:
//                let width = self.tupleView.width(forSection: indexPath.section)
//                return CGSize(width: width, height: 65)
//            default:
//                break
//            }
//        case 1:
//            let width = (self.tupleView.width(forSection: indexPath.section) - 16) / 3
//            //width = self.tupleView.fixSlit(withWidth: width, colCount: 3, index: indexPath.row - 3)
//            return CGSize(width: width, height: width + 5 + 25)
//        default:
//            break
//        }
//        return CGSize(width: self.tupleView.width, height: 50)
//    }
//    func edgeInsetsForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
//        switch indexPath.section {
//        case 0:
//            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        default:
//            return UIEdgeInsets.zero
//        }
//    }
//    func tupleItem(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            switch indexPath.row {
//            case 0:
//                let cell = tuple.cell(HTupleBannerCell.self, nil, true, indexPath) as! HTupleBannerCell
//                if cell.imageUrlArr == nil {
//                    cell.imageUrlArr = [
//                        "https://img2.baidu.com/it/u=399019925,2499719398&fm=253&fmt=auto&app=138&f=JPEG?w=355&h=130",
//                        "https://img2.baidu.com/it/u=399019925,2499719398&fm=253&fmt=auto&app=138&f=JPEG?w=355&h=130",
//                        "https://img2.baidu.com/it/u=399019925,2499719398&fm=253&fmt=auto&app=138&f=JPEG?w=355&h=130"]
//                    
////                    if cell.imageUrlArr == nil {
////                    var imageUrlArr: [String] = []
////                    self.bannerItems.forEach { item in
////                        if let imageURL = item.imageURL, imageURL.hasPrefix("http") {
////                            imageUrlArr.append(imageURL)
////                        } else {
////                            imageUrlArr.append("community_banner_placeholder")
////                        }
////                    }
////                    cell.imageUrlArr = imageUrlArr
//                    cell.selectedBannerBlock = { (_ index: Int, _ url: String) in
////                        if index >= 0, index < self.bannerItems.count {
////                            let openBannerItem = self.bannerItems[index]
////                            if let urlString = openBannerItem.link, urlString.hasPrefix("http") {
////                                let param = FCWebVCParams().setUrlString(urlString)
////                                let webVC = FCNFTWebViewVC(parameters: param)
////                                self.present(FCNavVC.configFullScreenModalNav(vc: webVC), animated: true)
////                            }
////                        }
//                    }
//                }
//                //接收信号
//                cell.signalBlock = { (target, signal) in
//                    let cell = target as! HTupleViewCellHoriValue3
//                    NSLog("选中%d", cell.label)
//                }
//            case 1:
//                let cell = tuple.cell(HTupleTextImageCell.self, nil, true, indexPath) as! HTupleTextImageCell
//                cell.backgroundColor = UIColor.gray
//
//                cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
//                
//                cell.imageView.backgroundColor = UIColor.red
//                cell.imageView.image = UIImage(named: "icon_no_server")
//                cell.imageView.imageSize = CGSize(width: 25, height: 25)
//                cell.imageView.cornerRadius = 25 / 2
//
//                cell.label.backgroundColor = UIColor.green
//                cell.label.text = "label"
//
//                cell.detailLabel.backgroundColor = UIColor.red
//                cell.detailLabel.text = "detailLabel"
//
//                cell.accsryLabel.backgroundColor = UIColor.yellow
//                cell.accsryLabel.text = "accessoryLabel"
//                
//                cell.detailView.backgroundColor = UIColor.red
//                cell.detailView.imageSize = CGSize(width: 25, height: 25)
//                cell.detailView.setImage(WithName: "icon_no_server")
//                cell.detailView.cornerRadius = 25 / 2
//                
//                cell.imageSpacing = 10.0
//                cell.labelSpacing = 5.0
//                cell.detailSpacing = 5.0
//                cell.accsrySpacing = 10.0
//            case 2:
//                let cell = tuple.cell(HTupleViewCellHoriValue1.self, nil, true, indexPath) as! HTupleViewCellHoriValue1
//                cell.backgroundColor = UIColor.gray
//
//                cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
//                
//                //cell.imageView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
//                cell.imageView.imageSize = CGSize(width: 25, height: 25)
//                cell.imageView.backgroundColor = UIColor.red
//                cell.imageView.setImage(WithName: "icon_no_server")
//                cell.imageView.cornerRadius = 25 / 2
//
//                cell.label.backgroundColor = UIColor.green
//                cell.label.text = "label"
//
//                cell.detailLabel.backgroundColor = UIColor.red
//                cell.detailLabel.text = "detailLabel"
//
//                cell.accsryLabel.backgroundColor = UIColor.yellow
//                cell.accsryLabel.text = "accessoryLabel"
//                
//                //cell.detailView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
//                cell.detailView.imageSize = CGSize(width: 25, height: 25)
//                cell.detailView.backgroundColor = UIColor.red
//                cell.detailView.setImage(WithName: "icon_no_server")
//                cell.detailView.cornerRadius = 25 / 2
//                
//                cell.isShowAccsryArrow = true
//            case 3:
//                let cell = tuple.cell(HTupleViewCellHoriValue2.self, nil, true, indexPath) as! HTupleViewCellHoriValue2
//                cell.backgroundColor = UIColor.gray
//
//                cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
//                
//                //cell.imageView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
//                cell.imageView.imageSize = CGSize(width: 25, height: 25)
//                cell.imageView.backgroundColor = UIColor.red
//                cell.imageView.setImage(WithName: "icon_no_server")
//                cell.imageView.cornerRadius = 25 / 2
//
//                cell.label.backgroundColor = UIColor.green
//                cell.label.text = "label"
//
//                cell.detailLabel.backgroundColor = UIColor.red
//                cell.detailLabel.text = "detailLabel"
//
//                cell.accsryLabel.backgroundColor = UIColor.yellow
//                cell.accsryLabel.text = "accessoryLabel"
//                
//                //cell.detailView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
//                cell.detailView.imageSize = CGSize(width: 25, height: 25)
//                cell.detailView.backgroundColor = UIColor.red
//                cell.detailView.setImage(WithName: "icon_no_server")
//                cell.detailView.cornerRadius = 25 / 2
//                
//                cell.isShowAccsryArrow = true
//            case 4:
//                let cell = tuple.cell(HTupleFieldCell.self, nil, true, indexPath) as! HTupleFieldCell
//                cell.backgroundColor = UIColor.gray
//                cell.textField.backgroundColor = UIColor.red
//
//                cell.textField.leftWidth = 50
//                cell.textField.leftLabel.textAlignment = .center
//                cell.textField.leftLabel.text = "验证码"
//                cell.textField.leftLabel.backgroundColor = UIColor.green
//
//                cell.textField.placeholder = "请输入验证码"
//                cell.textField.placeholderColor = UIColor.white
//                cell.textField.textColor = UIColor.white
//
//                cell.textField.rightWidth = 90
//                //普通view
//                /*
//                cell.textField.rightButton.text = "获取验证码"
//                cell.textField.rightButton.backgroundColor = UIColor.green
//                cell.textField.rightButton.pressed = { (sender, data) in
//
//                }
//                 */
//                //短信验证码
//                cell.textField.rightCountDownButton.text = "获取验证码"
//                cell.textField.rightCountDownButton.backgroundColor = UIColor.green
//                cell.textField.rightCountDownButton.countDownButtonHandler { (countDownButton, tag) in
//                    countDownButton.startCountDownWithSecond(60)
//                }
//                cell.textField.rightCountDownButton.countDownChanging({ (countDownButton, second) -> String in
//                    return String(format: "还剩%lu秒", second)
//                })
//                cell.textField.rightCountDownButton .countDownFinished { (countDownButton, second) -> String in
//                    return "重新获取"
//                }
//                //图形验证码
//                /*
//                cell.textField.rightVerifyCodeView.backgroundColor = UIColor.green
//                cell.textField.rightVerifyCodeView.textSize = 20
//                cell.textField.rightVerifyCodeView.textColor = UIColor.black
//                cell.textField.rightVerifyCodeView.charsArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
//                 */
//            default:
//                break
//            }
//        case 1:
//            let cell = tuple.cell(HTupleViewCellVertValue1.self, nil, true, indexPath) as! HTupleViewCellVertValue1
//            cell.backgroundColor = UIColor.gray
//            cell.layoutFirstSpacing = 5
//            
//            cell.imageView.backgroundColor = UIColor.red
//            cell.imageView.setImage(WithName: "icon_no_server")
//
//            cell.labelHeight = 25
//            cell.label.backgroundColor = .green
//            cell.label.textAlignment = .center
//            cell.label.text = "黑客帝国"
//            cell.selectBlock = {
//                if indexPath.row == 0 {
//                    let navi = HNavigationController.fullScreenModalNavi(rootVC: HUserLiveVC())
//                    self.present(navi, animated: true)
//                }else {
//                    let alertVC = HPullController.showVideoAlert { index in }
//                    self.presentController(alertVC, completion: nil)
//                }
//            }
//        default:
//            break
//        }
//    }
//        
//}

extension HMainController1 {
    func numberOfSectionsInTupleView() -> Any {
        return 2
    }
    func numberOfItemsInSection(_ section: Any) -> Any {
        switch section as! Int {
        case 0:
            return 5
        case 1:
            return 9
        default:
            return 1
        }
    }
    func insetForSection(_ section: Any) -> Any {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func colorForSection(_ section: Any) -> UIColor {
        return UIColor.red
    }
    func minimumLineSpacingForSectionAt(_ section: Any) -> Any {
        switch section as! Int {
        case 1:
            return 8
        default:
            return 0
        }
    }
    func attributeForItemAtIndexPath(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let attribute = tuple.attribute(HTupleBannerCell.self, nil, true, indexPath)
                attribute.size = CGSize(width: tuple.width, height: 130)
                attribute.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attribute.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleBannerCell
                    cell.imageUrlArr = [
                        "https://img2.baidu.com/it/u=399019925,2499719398&fm=253&fmt=auto&app=138&f=JPEG?w=355&h=130",
                        "https://img2.baidu.com/it/u=399019925,2499719398&fm=253&fmt=auto&app=138&f=JPEG?w=355&h=130",
                        "https://img2.baidu.com/it/u=399019925,2499719398&fm=253&fmt=auto&app=138&f=JPEG?w=355&h=130"]
                        
//                        if cell.imageUrlArr == nil {
//                        var imageUrlArr: [String] = []
//                        self.bannerItems.forEach { item in
//                            if let imageURL = item.imageURL, imageURL.hasPrefix("http") {
//                                imageUrlArr.append(imageURL)
//                            } else {
//                                imageUrlArr.append("community_banner_placeholder")
//                            }
//                        }
//                        cell.imageUrlArr = imageUrlArr
                    cell.selectedBannerBlock = { (_ index: Int, _ url: String) in
//                            if index >= 0, index < self.bannerItems.count {
//                                let openBannerItem = self.bannerItems[index]
//                                if let urlString = openBannerItem.link, urlString.hasPrefix("http") {
//                                    let param = FCWebVCParams().setUrlString(urlString)
//                                    let webVC = FCNFTWebViewVC(parameters: param)
//                                    self.present(FCNavVC.configFullScreenModalNav(vc: webVC), animated: true)
//                                }
//                            }
                    }
                    
                    //接收信号
                    cell.signalBlock = { (target, signal) in
                        let cell = target as! HTupleViewCellHoriValue3
                        NSLog("选中%d", cell.label)
                    }
                    
                    cell.selectBlock = {

                    }
                }
            case 1:
                let attribute = tuple.attribute(HTupleTextImageCell.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attribute.size = CGSize(width: width, height: 65)
                attribute.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attribute.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleTextImageCell
                    cell.backgroundColor = UIColor.gray

                    cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
                    
                    cell.imageView.backgroundColor = UIColor.red
                    cell.imageView.image = UIImage(named: "icon_no_server")
                    cell.imageView.imageSize = CGSize(width: 25, height: 25)
                    cell.imageView.cornerRadius = 25 / 2

                    cell.label.backgroundColor = UIColor.green
                    cell.label.text = "label"

                    cell.detailLabel.backgroundColor = UIColor.red
                    cell.detailLabel.text = "detailLabel"

                    cell.accsryLabel.backgroundColor = UIColor.yellow
                    cell.accsryLabel.text = "accessoryLabel"
                    
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.imageSpacing = 10.0
                    cell.labelSpacing = 5.0
                    cell.detailSpacing = 5.0
                    cell.accsrySpacing = 10.0
                    
                    cell.selectBlock = {

                    }
                }
            case 2:
                let attribute = tuple.attribute(HTupleViewCellHoriValue1.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attribute.size = CGSize(width: width, height: 65)
                attribute.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attribute.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleViewCellHoriValue1
                    cell.backgroundColor = UIColor.gray

                    cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
                    
                    //cell.imageView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
                    cell.imageView.imageSize = CGSize(width: 25, height: 25)
                    cell.imageView.backgroundColor = UIColor.red
                    cell.imageView.setImage(WithName: "icon_no_server")
                    cell.imageView.cornerRadius = 25 / 2

                    cell.label.backgroundColor = UIColor.green
                    cell.label.text = "label"

                    cell.detailLabel.backgroundColor = UIColor.red
                    cell.detailLabel.text = "detailLabel"

                    cell.accsryLabel.backgroundColor = UIColor.yellow
                    cell.accsryLabel.text = "accessoryLabel"
                    
                    //cell.detailView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.isShowAccsryArrow = true
                    
                    cell.selectBlock = {

                    }
                }
            case 3:
                let attribute = tuple.attribute(HTupleViewCellHoriValue2.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attribute.size = CGSize(width: width, height: 65)
                attribute.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attribute.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleViewCellHoriValue2
                    cell.backgroundColor = UIColor.gray

                    cell.separatorView.separatorInset = UILREdgeInsets(left: 10, right: 10)
                    
                    //cell.imageView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
                    cell.imageView.imageSize = CGSize(width: 25, height: 25)
                    cell.imageView.backgroundColor = UIColor.red
                    cell.imageView.setImage(WithName: "icon_no_server")
                    cell.imageView.cornerRadius = 25 / 2

                    cell.label.backgroundColor = UIColor.green
                    cell.label.text = "label"

                    cell.detailLabel.backgroundColor = UIColor.red
                    cell.detailLabel.text = "detailLabel"

                    cell.accsryLabel.backgroundColor = UIColor.yellow
                    cell.accsryLabel.text = "accessoryLabel"
                    
                    //cell.detailView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.isShowAccsryArrow = true
                    
                    cell.selectBlock = {

                    }
                }
            case 4:
                let attribute = tuple.attribute(HTupleFieldCell.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attribute.size = CGSize(width: width, height: 65)
                attribute.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attribute.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleFieldCell
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
                    /*
                    cell.textField.rightButton.text = "获取验证码"
                    cell.textField.rightButton.backgroundColor = UIColor.green
                    cell.textField.rightButton.pressed = { (sender, data) in

                    }
                     */
                    //短信验证码
                    cell.textField.rightCountDownButton.text = "获取验证码"
                    cell.textField.rightCountDownButton.backgroundColor = UIColor.green
                    cell.textField.rightCountDownButton.countDownButtonHandler { (countDownButton, tag) in
                        countDownButton.startCountDownWithSecond(60)
                    }
                    cell.textField.rightCountDownButton.countDownChanging({ (countDownButton, second) -> String in
                        return String(format: "还剩%lu秒", second)
                    })
                    cell.textField.rightCountDownButton .countDownFinished { (countDownButton, second) -> String in
                        return "重新获取"
                    }
                    
                    cell.selectBlock = {

                    }
                }
            default:
                break
            }
        case 1:
            let attribute = tuple.attribute(HTupleViewCellVertValue1.self, nil, true, indexPath)
            let width = (tuple.width(forSection: indexPath.section) - 16) / 3
            attribute.size = CGSize(width: width, height: width + 5 + 25)
            attribute.edgeInsets = UIEdgeInsets.zero
            attribute.cellBlock = { (tuple, baseCell) in
                let cell = baseCell as! HTupleViewCellVertValue1
                cell.backgroundColor = UIColor.gray
                cell.layoutFirstSpacing = 5
                
                cell.imageView.backgroundColor = UIColor.red
                cell.imageView.setImage(WithName: "icon_no_server")

                cell.labelHeight = 25
                cell.label.backgroundColor = .green
                cell.label.textAlignment = .center
                cell.label.text = "黑客帝国"
                cell.selectBlock = {
                    if indexPath.row == 0 {
                        let navi = HNavigationController.fullScreenModalNavi(rootVC: HUserLiveVC())
                        self.present(navi, animated: true)
                    }else {
                        let dropVC = HFlowDropVC.showPacketSheet(true) { index in }
                        self.presentController(dropVC, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }
}
