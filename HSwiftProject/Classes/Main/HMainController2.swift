//
//  HMainController2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController2: HViewController, HTupleViewDelegate {
    
    lazy var tupleView: HTupleView = {
        var frame = UIScreen.bound
        frame.origin.y += UIScreen.topBarHeight
        frame.size.height -= UIScreen.topBarHeight
        let tupleView = HTupleView(frame: frame)
        return tupleView
    }()

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            self.tupleView.releaseTupleBlock()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "第二页"
        self.navigationBar.leftItem.isHidden = true
        self.tupleView.delegate = self
        self.tupleView.tupleStatus = .block
        self.view.addSubview(self.tupleView)
        
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let width = self.view.width
//        let height = UIScreen.topBarHeight
//        let frame = CGRect(x: 0, y: 100, width: width, height: height)
//        let naviBar = HNavigationBar(frame: frame)
//        naviBar.backgroundColor = .yellow
//        
////        naviBar.lineBarColor = .green
//        
//        self.view.addSubview(naviBar)
//        
////        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//////            naviBar.leftItem.text = "leftItem"
////            naviBar.leftItem.backgroundColor = .red
////            naviBar.leftItem.image = UIImage(named: "hvc_back_icon")
////
////            naviBar.titleItem.text = "title"
////            naviBar.titleItem.backgroundColor = .blue
////
//////            naviBar.rightItem.text = "rightItem"
//////            naviBar.rightItem.backgroundColor = .green
////
////
////            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
////                naviBar.rightItem.text = "rightItem"
////                naviBar.rightItem.backgroundColor = .green
////            })
////        })
//        
//        naviBar.leftItem.text = "leftItem"
//        naviBar.leftItem.backgroundColor = .red
//
//        naviBar.titleItem.text = "title"
//        naviBar.titleItem.backgroundColor = .red
//
//        naviBar.rightItem.text = "rightItem"
//        naviBar.rightItem.backgroundColor = .red
//        
////        self.view.addSubview(naviBar)
//        
//        
//        return
//        
//        HUserDefaults.setUserCoreKey("23234")
//        
//        HUserDefaults.defaults.set("ff", forKey: "ee")
//        HUserDefaults.defaults.object(forKey: "ee")
//        HUserDefaults.defaults.removeObject(forKey: "ee")
//        HUserDefaults.defaults.synchronize()
//        
//        HUserDefaults.user.set("ww", forKey: "rr")
//        HUserDefaults.user.object(forKey: "rr")
//        HUserDefaults.user.removeObject(forKey: "rr")
//        HUserDefaults.user.synchronize()
//        
//        HUserDefaults.user.userId = "11"
//        HUserDefaults.user.isUserFirstLaunch = true
//        
//        HUserDefaults.defaults.isUserLogin = true
//        HUserDefaults.defaults.isAPPFirstLaunch = true
//        
////        HUserStore.defaults.isLogin = true
//        
////        let dotIndicatorBar = HDotIndicatorBar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 36))
//////        dotIndicatorBar.backgroundColor = .red
////        dotIndicatorBar.itemSelectedWidth = 36 * 4
////        dotIndicatorBar.itemSpace = 8
////        dotIndicatorBar.items = 5
////
////
////        self.view.addSubview(dotIndicatorBar)
////        return
//        
//        let webButtonView = HWebButtonView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 60))
//        webButtonView.backgroundColor = .red
////        webButtonView.setImageUrlString("https://d1e084oasoo524.cloudfront.net/images/Group_Chat-Banner.png")
//        webButtonView.imagePosition = .left
////        webButtonView.renderColor = .yellow
//        webButtonView.imageSpace = 10
//        webButtonView.image = UIImage(named: "hvc_back_icon")
////        webButtonView.setImage(WithName: "hvc_back_icon")
////        webButtonView.imageSize = CGSize(width: 23, height: 23)
//        
////        webButtonView.imageView.backgroundColor = .green
//        
//        webButtonView.text = "封疆大吏是否能啦"
////        webButtonView.titleLabel.text = "封疆大吏是否能啦"
////        webButtonView.titleLabel.font = UIFont.systemFont(ofSize: 17)
////        webButtonView.titleLabel.backgroundColor = .blue
//        
////        webButtonView.pressed = { (sender, data) in
////            NSLog("")
////        }
//        
//        webButtonView.pressed = { (sender, data) in
//            NSLog("")
//        }
//        
//        self.view.addSubview(webButtonView)
//        return
//        
//        let webActionView = HWebActionView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 60))
//        webActionView.backgroundColor = .red
////        webActionView.setImageUrlString("https://d1e084oasoo524.cloudfront.net/images/Group_Chat-Banner.png")
//        webActionView.imagePosition = .left
////        webActionView.renderColor = .yellow
//        webActionView.imageSpace = 10
//        webActionView.setImage(WithName: "hvc_back_icon")
////        webActionView.imageSize = CGSize(width: 23, height: 23)
//        
////        webActionView.imageView.backgroundColor = .green
//        
//        webActionView.titleLabel.text = "封疆大吏是否能啦"
////        webActionView.titleLabel.font = UIFont.systemFont(ofSize: 17)
////        webActionView.titleLabel.backgroundColor = .blue
//        
//        webActionView.pressed = { (sender, data) in
//            NSLog("")
//        }
//        
//        self.view.addSubview(webActionView)
//        return
//
//        let toolbar = HScrollbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))
//
//        toolbar.titleColor = .blue
//        toolbar.titleFont = UIFont.font(ofSize: 14, weight: .regular)
//        toolbar.titleBGColor = .green
//
//        toolbar.titleSelectedColor = .red
//        toolbar.titleSelectedFont = UIFont.font(ofSize: 17, weight: .regular)
//        toolbar.titleSelectedBGColor = .yellow
//
//        toolbar.items = ["item1", "item2", "item3", "item4", "item5", "item6"]
//        toolbar.itemWidth = UIScreen.width / 6
//
//        toolbar.isScrollEnabled = false
//
//        toolbar.selectedIndex = 1
//
//        toolbar.selectedBlock = { index in
//            NSLog(index)
//        }
//
//        toolbar.cornerRadius = 20
//        self.view.addSubview(toolbar)
//        
//    }

}

extension HMainController2 {
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
    func attributesForItemAtIndexPath(_ tuple: HTupleView, atIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 10:
                let attributes = tuple.attributes(with: HTupleBannerCell.self, nil, true, indexPath)
                attributes.size = CGSize(width: tuple.width, height: 130)
                attributes.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attributes.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleBannerCell
                    if cell.imageUrlArr == nil {
                        cell.imageUrlArr = ["https://freechatoss.s3.ap-southeast-1.amazonaws.com/face/default/102.png",
                                            "https://freechatoss.s3.ap-southeast-1.amazonaws.com/face/default/102.png",
                                            "https://freechatoss.s3.ap-southeast-1.amazonaws.com/face/default/102.png"]
                        
    //                    if cell.imageUrlArr == nil {
    //                    var imageUrlArr: [String] = []
    //                    self.bannerItems.forEach { item in
    //                        if let imageURL = item.imageURL, imageURL.hasPrefix("http") {
    //                            imageUrlArr.append(imageURL)
    //                        } else {
    //                            imageUrlArr.append("community_banner_placeholder")
    //                        }
    //                    }
    //                    cell.imageUrlArr = imageUrlArr
                        cell.selectedBannerBlock = { (_ index: Int, _ url: String) in
    //                        if index >= 0, index < self.bannerItems.count {
    //                            let openBannerItem = self.bannerItems[index]
    //                            if let urlString = openBannerItem.link, urlString.hasPrefix("http") {
    //                                let param = FCWebVCParams().setUrlString(urlString)
    //                                let webVC = FCNFTWebViewVC(parameters: param)
    //                                self.present(FCNavVC.configFullScreenModalNav(vc: webVC), animated: true)
    //                            }
    //                        }
                        }
                    }
                    //接收信号
                    cell.signalBlock = { (target, signal) in
                        let cell = target as! HTupleViewCellHoriValue3
                        NSLog("选中%d", cell.label)
                    }
                    
                    cell.selectBlock = {

                    }
                }
            case 0:
                let attributes = tuple.attributes(with: HTupleTextImageCell.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attributes.size = CGSize(width: width, height: 65)
                attributes.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attributes.cellBlock = { (tuple, baseCell) in
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

                    cell.accessoryLabel.backgroundColor = UIColor.yellow
                    cell.accessoryLabel.text = "accessoryLabel"
                    
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.imageSpacing = 10.0
                    cell.labelSpacing = 5.0
                    cell.detailSpacing = 5.0
                    cell.accessorySpacing = 10.0
                    
                    cell.selectBlock = {

                    }
                }
            case 1:
                let attributes = tuple.attributes(with: HTupleTextImageCell.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attributes.size = CGSize(width: width, height: 65)
                attributes.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attributes.cellBlock = { (tuple, baseCell) in
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

                    cell.accessoryLabel.backgroundColor = UIColor.yellow
                    cell.accessoryLabel.text = "accessoryLabel"
                    
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.imageSpacing = 10.0
                    cell.labelSpacing = 5.0
                    cell.detailSpacing = 5.0
                    cell.accessorySpacing = 10.0
                    
                    cell.selectBlock = {

                    }
                }
            case 2:
                let attributes = tuple.attributes(with: HTupleViewCellHoriValue1.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attributes.size = CGSize(width: width, height: 65)
                attributes.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attributes.cellBlock = { (tuple, baseCell) in
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

                    cell.accessoryLabel.backgroundColor = UIColor.yellow
                    cell.accessoryLabel.text = "accessoryLabel"
                    
                    //cell.detailView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.isShowAccessoryArrow = true
                    
                    cell.selectBlock = {

                    }
                }
            case 3:
                let attributes = tuple.attributes(with: HTupleViewCellHoriValue2.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attributes.size = CGSize(width: width, height: 65)
                attributes.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attributes.cellBlock = { (tuple, baseCell) in
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

                    cell.accessoryLabel.backgroundColor = UIColor.yellow
                    cell.accessoryLabel.text = "accessoryLabel"
                    
                    //cell.detailView.edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
                    cell.detailView.imageSize = CGSize(width: 25, height: 25)
                    cell.detailView.backgroundColor = UIColor.red
                    cell.detailView.setImage(WithName: "icon_no_server")
                    cell.detailView.cornerRadius = 25 / 2
                    
                    cell.isShowAccessoryArrow = true
                    
                    cell.selectBlock = {

                    }
                }
            case 4:
                let attributes = tuple.attributes(with: HTupleTextFieldCell.self, nil, true, indexPath)
                let width = tuple.width(forSection: indexPath.section)
                attributes.size = CGSize(width: width, height: 65)
                attributes.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                attributes.cellBlock = { (tuple, baseCell) in
                    let cell = baseCell as! HTupleTextFieldCell
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
            let attributes = tuple.attributes(with: HTupleViewCellVertValue1.self, nil, true, indexPath)
            let width = (tuple.width(forSection: indexPath.section) - 16) / 3
            attributes.size = CGSize(width: width, height: width + 5 + 25)
            attributes.edgeInsets = UIEdgeInsets.zero
            attributes.cellBlock = { (tuple, baseCell) in
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
                        let navi = HNavigationController(rootViewController: HUserLiveVC())
                        self.present(navi, animated: true)
                    }else {
                        let alertVC = HPullController.showVideoAlert { index in }
                        self.presentController(alertVC, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }
}
