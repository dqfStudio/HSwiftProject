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

class HMainController5: HTupleController {
    
    lazy var flowBar: HFlowBar = {
        let flowWidth = self.view.width
        let frame = CGRect(x: 0, y: UIScreen.topBarHeight, width: flowWidth, height: kTabBarHeight)
        let flowBar = HFlowBar(frame: frame, direction: .horizontal)
        flowBar.backgroundColor = UIColor.gray
        
//        flowBar.headerSpacing = 16
//        flowBar.footerSpacing = 16
//        flowBar.itemSpacing = 10
        
//        flowBar.indicatorWidth = 20
        flowBar.indicatorWidth = self.view.width / 3
        flowBar.indicatorHeight = 3
        flowBar.indicatorColor = UIColor.red
        flowBar.showIndicator = true
//        flowBar.tupleView.tupleAlign = .center
        
//        flowBar.showTopSeparator = true
//        flowBar.topSeparatorColor = .red
        
        flowBar.showBottomSeparator = true
        flowBar.bottomSeparatorColor = UIColor.black
        
        flowBar.numberBlock = {
            return 3
        }
        flowBar.sizeBlock = { index in
            return self.view.width / 3
        }
        flowBar.itemBlock = { (tuple: HTupleView, indexPath: IndexPath) in
            let cell = tuple.cell(HTupleLabelCell.self, nil, true, indexPath) as! HTupleLabelCell
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
            if indexPath.row == flowBar.selectedIndex {
                cell.label.textColor = UIColor.red
                cell.label.font = UIFont.systemFont(ofSize: 17)
            }else {
                cell.label.textColor = UIColor.black
                cell.label.font = UIFont.systemFont(ofSize: 16)
            }
        }
        flowBar.didSelectBlock = { index in
            
        }
        return flowBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "tab展示"
        
        self.view.addSubview(flowBar)
        
        
        let flowY = UIScreen.topBarHeight + kTabBarHeight
        let flowH = UIScreen.height - UIScreen.topBarHeight - flowY
        let flowFrame = CGRect(x: 0, y: flowY, width: self.view.width, height: flowH)
        let flowView = HFlowView(frame: flowFrame)
        
        let loginVC = HLoginController()
        let registerVC = HRegisterController()
        let registerVC2 = HRegisterController()
        
        flowView.flowBar = flowBar
        flowView.viewControllers = [loginVC, registerVC, registerVC2]
        self.view.addSubview(flowView)
    }
}
