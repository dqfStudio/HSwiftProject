//
//  HMainController5.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let kTabBarHeight: CGFloat = 50.0

//class HMainController5: HTabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.title = "table展示"
//        
//        let screenSize: CGSize = UIScreen.size
//
//        self.setTabBarFrame(CGRect(x: 0, y: UIScreen.topBarHeight, width: screenSize.width, height: kTabBarHeight),
//            contentViewFrame: CGRect(x: 0, y: UIScreen.topBarHeight + kTabBarHeight, width: screenSize.width, height: screenSize.height - UIScreen.topBarHeight - kTabBarHeight))
//
//        self.tabBar.itemTitleColor = UIColor.black
//        self.tabBar.itemTitleSelectedColor = UIColor.red
//        self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 16)
//        self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 17)
//
//        self.tabBar.isItemFontChangeFollowContentScroll = true
//        self.tabBar.isIndicatorScrollFollowContent = true
//        self.tabBar.indicatorColor = UIColor.red
//
//        self.tabBar.backgroundColor = UIColor.gray
//        self.tabBar.setIndicatorWidth(screenSize.width / 3, marginTop: kTabBarHeight - 3, marginBottom: 0, tapSwitchAnimated: false)
//        self.tabBar.setScrollEnabledAndItemWidth(screenSize.width / 3)
//
//        self.tabBar.addBottomLineViewWithColor(UIColor.black)
//
//        self.tabContentView.backgroundColor = UIColor.clear
//        self.tabContentView.setContentScrollEnabled(true, tapSwitchAnimated:false)
//        self.tabContentView.loadViewOfChildContollerWhileAppear = true
//
//        self.initViewControllers()
//    }
//
//    func initViewControllers() {
//        
//        let controller1 = HMainController6()
//        controller1.h_tabItemTitle = "第一个"
//        
//        let controller2 = UIViewController()
//        controller2.view.backgroundColor = UIColor.green
//        controller2.h_tabItemTitle = "第二个"
//        
//        let controller3 = UIViewController()
//        controller3.view.backgroundColor = UIColor.blue
//        controller3.h_tabItemTitle = "第三个"
//        
//        self.viewControllers = [controller1, controller2, controller3]
//    }
//
//}

class HMainController5: HCusViewController {
    
    lazy var activeBar: HActivebar = {
        let activeWidth = self.view.width
        let frame = CGRect(x: 0, y: UIScreen.topBarHeight, width: activeWidth, height: kTabBarHeight)
        let activeBar = HActivebar(frame: frame, direction: .horizontal)
        activeBar.backgroundColor = UIColor.gray
        
//        activeBar.headerSpacing = 16
//        activeBar.footerSpacing = 16
//        activeBar.itemSpacing = 10
        
//        activeBar.indicatorWidth = 20
        activeBar.indicatorWidth = self.view.width / 3
        activeBar.indicatorHeight = 3
        activeBar.indicatorColor = UIColor.red
        activeBar.showIndicator = true
//        activeBar.tupleView.tupleAlign = .center
        
//        activeBar.showTopSeparator = true
//        activeBar.topSeparatorColor = .red
        
        activeBar.showBottomSeparator = true
        activeBar.bottomSeparatorColor = UIColor.black
        
        activeBar.numberBlock = {
            return 3
        }
        activeBar.sizeBlock = { index in
            return self.view.width / 3
        }
        activeBar.itemBlock = { (tuple: HTupleView, indexPath: IndexPath) in
            let cell = tuple.reuseCell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
            cell.label.textAlignment = .center
            switch indexPath.row {
            case 0:
                cell.label.text = "第一个"
            case 1:
                cell.label.text = "第二个"
            case 2:
                cell.label.text = "第三个"
            default:
                break
            }
            if indexPath.row == activeBar.selectedIndex {
                cell.label.textColor = UIColor.red
                cell.label.font = UIFont.systemFont(ofSize: 17)
            }else {
                cell.label.textColor = UIColor.black
                cell.label.font = UIFont.systemFont(ofSize: 16)
            }
        }
        activeBar.didSelectBlock = { index in
            
        }
        return activeBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "tab展示"
        
        self.view.addSubview(activeBar)
        
        
        let activeY = UIScreen.topBarHeight + kTabBarHeight
        let activeH = UIScreen.height - UIScreen.topBarHeight - activeY
        let activeFrame = CGRect(x: 0, y: activeY, width: self.view.width, height: activeH)
        let activeView = HActiveView(frame: activeFrame)
        
        let loginVC = HLoginController()
        let registerVC = HRegisterController()
        let registerVC2 = HRegisterController()
        
        activeView.activeBar = activeBar
        activeView.viewControllers = [loginVC, registerVC, registerVC2]
        self.view.addSubview(activeView)
    }
}
