//
//  HMainController2.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HMainController2: HViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activeWidth = self.view.width
        
        let frame = CGRect(x: 0, y: UIScreen.topBarHeight, width: activeWidth, height: 50)
        let naviBar = HActivebar(frame: frame, direction: .horizontal)
        naviBar.backgroundColor = .yellow
        
        naviBar.topSpacing = 16
        naviBar.bottomSpacing = 16
        naviBar.itemSpacing = 10
        naviBar.indicatorWidth = 20
        naviBar.indicatorHeight = 3
        naviBar.indicatorColor = UIColor.blue
        naviBar.showIndicator = true
        naviBar.tupleView.tupleAlign = .center
        
        naviBar.showTopSeparator = true
        naviBar.topSeparatorColor = .red
        
        naviBar.showBottomSeparator = true
        naviBar.bottomSeparatorColor = .red
        
        naviBar.selectedIndex = 1
        
        naviBar.numberBlock = {
            return 3
        }
        naviBar.sizeBlock = { index in
            return 70
        }
        naviBar.itemBlock = { (tuple: HTupleView, indexPath: IndexPath) in
            let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.text = "\(indexPath.row)"
            cell.label.textColor = UIColor.red
            cell.label.textAlignment = .center
        }
        naviBar.didSelectBlock = { index in
            
        }
        
        self.view.addSubview(naviBar)
        
        
        let activeY = UIScreen.topBarHeight + 50
        let activeH = UIScreen.height - activeY - 50
        let activeFrame = CGRect(x: 0, y: activeY, width: activeWidth, height: activeH)
        let activeView = HActiveView(frame: activeFrame)
        
        let loginVC = HLoginController()
        let registerVC = HRegisterController()
        let registerVC2 = HRegisterController()
        
        activeView.activeBar = naviBar
        activeView.viewControllers = [loginVC, registerVC, registerVC2]
        self.view.addSubview(activeView)
        
        return
        
//        let width = self.view.width
//        let height = UIScreen.topBarHeight
//        let frame = CGRect(x: 0, y: 100, width: width, height: height)
//        let naviBar = HNavigationBar(frame: frame)
//        naviBar.backgroundColor = .yellow
//        
////        naviBar.lineBarColor = .green
//        
//        self.view.addSubview(naviBar)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
////            naviBar.leftItem.text = "leftItem"
//            naviBar.leftItem.backgroundColor = .red
//            naviBar.leftItem.image = UIImage(named: "hvc_back_icon")
//
//            naviBar.titleItem.text = "title"
//            naviBar.titleItem.backgroundColor = .blue
//
////            naviBar.rightItem.text = "rightItem"
////            naviBar.rightItem.backgroundColor = .green
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//                naviBar.rightItem.text = "rightItem"
//                naviBar.rightItem.backgroundColor = .green
//            })
//        })
        
//        naviBar.leftItem.text = "leftItem"
//        naviBar.leftItem.backgroundColor = .red
//
//        naviBar.titleItem.text = "title"
//        naviBar.titleItem.backgroundColor = .red
//
//        naviBar.rightItem.text = "rightItem"
//        naviBar.rightItem.backgroundColor = .red
        
//        self.view.addSubview(naviBar)
        
        
        return
        
        HUserDefaults.setUserCoreKey("23234")
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
        
        HUserDefaults.user.userId = "11"
        HUserDefaults.user.isUserFirstLaunch = true
        
        HUserDefaults.defaults.isUserLogin = true
        HUserDefaults.defaults.isAPPFirstLaunch = true
        
//        HUserStore.defaults.isLogin = true
        
//        let dotIndicatorBar = HDotIndicatorBar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 36))
////        dotIndicatorBar.backgroundColor = .red
//        dotIndicatorBar.itemSelectedWidth = 36 * 4
//        dotIndicatorBar.itemSpace = 8
//        dotIndicatorBar.items = 5
//
//
//        self.view.addSubview(dotIndicatorBar)
//        return
        
        let webButtonView = HWebButtonView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 60))
        webButtonView.backgroundColor = .red
//        webButtonView.setImageUrlString("https://d1e084oasoo524.cloudfront.net/images/Group_Chat-Banner.png")
        webButtonView.imagePosition = .left
//        webButtonView.renderColor = .yellow
        webButtonView.imageSpace = 10
        webButtonView.image = UIImage(named: "hvc_back_icon")
//        webButtonView.setImage(WithName: "hvc_back_icon")
//        webButtonView.imageSize = CGSize(width: 23, height: 23)
        
//        webButtonView.imageView.backgroundColor = .green
        
        webButtonView.text = "封疆大吏是否能啦"
//        webButtonView.titleLabel.text = "封疆大吏是否能啦"
//        webButtonView.titleLabel.font = UIFont.systemFont(ofSize: 17)
//        webButtonView.titleLabel.backgroundColor = .blue
        
//        webButtonView.pressed = { (sender, data) in
//            NSLog("")
//        }
        
        webButtonView.pressed = { (sender, data) in
            NSLog("")
        }
        
        self.view.addSubview(webButtonView)
        return
        
        let webActionView = HWebActionView(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 60))
        webActionView.backgroundColor = .red
//        webActionView.setImageUrlString("https://d1e084oasoo524.cloudfront.net/images/Group_Chat-Banner.png")
        webActionView.imagePosition = .left
//        webActionView.renderColor = .yellow
        webActionView.imageSpace = 10
        webActionView.setImage(WithName: "hvc_back_icon")
//        webActionView.imageSize = CGSize(width: 23, height: 23)
        
//        webActionView.imageView.backgroundColor = .green
        
        webActionView.titleLabel.text = "封疆大吏是否能啦"
//        webActionView.titleLabel.font = UIFont.systemFont(ofSize: 17)
//        webActionView.titleLabel.backgroundColor = .blue
        
        webActionView.pressed = { (sender, data) in
            NSLog("")
        }
        
        self.view.addSubview(webActionView)
        return

        let toolbar = HScrollbar(frame: CGRect(x: 0, y: 200, width: UIScreen.width, height: 40))

        toolbar.titleColor = .blue
        toolbar.titleFont = UIFont.font(ofSize: 14, weight: .regular)
        toolbar.titleBGColor = .green

        toolbar.titleSelectedColor = .red
        toolbar.titleSelectedFont = UIFont.font(ofSize: 17, weight: .regular)
        toolbar.titleSelectedBGColor = .yellow

        toolbar.items = ["item1", "item2", "item3", "item4", "item5", "item6"]
        toolbar.itemWidth = UIScreen.width / 6

        toolbar.isScrollEnabled = false

        toolbar.selectedIndex = 1

        toolbar.selectedBlock = { index in
            NSLog(index)
        }

        toolbar.cornerRadius = 20
        self.view.addSubview(toolbar)
        
    }

}
