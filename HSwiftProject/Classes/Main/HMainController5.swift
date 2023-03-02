//
//  HMainController5.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private let kTabBarHeight: CGFloat = 50.0

class HMainController5: HTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "table展示"
        
        let screenSize: CGSize = UIScreen.size

        self.setTabBarFrame(CGRect(x: 0, y: UIDevice.topBarHeight, width: screenSize.width, height: kTabBarHeight),
            contentViewFrame: CGRect(x: 0, y: kTabBarHeight, width: screenSize.width, height: screenSize.height - kTabBarHeight))

        self.tabBar.itemTitleColor = UIColor.black
        self.tabBar.itemTitleSelectedColor = UIColor.red
        self.tabBar.itemTitleFont = UIFont.systemFont(ofSize: 16)
        self.tabBar.itemTitleSelectedFont = UIFont.systemFont(ofSize: 17)

        self.tabBar.isItemFontChangeFollowContentScroll = true
        self.tabBar.isIndicatorScrollFollowContent = true
        self.tabBar.indicatorColor = UIColor.red

        self.tabBar.backgroundColor = UIColor.gray
        self.tabBar.setIndicatorWidth(screenSize.width / 3, marginTop: kTabBarHeight - 3, marginBottom: 0, tapSwitchAnimated: false)
        self.tabBar.setScrollEnabledAndItemWidth(screenSize.width / 3)

        self.tabBar.addBottomLineViewWithColor(UIColor.black)

        self.tabContentView.backgroundColor = UIColor.gray
        self.tabContentView.setContentScrollEnabled(true, tapSwitchAnimated:false)
        self.tabContentView.loadViewOfChildContollerWhileAppear = true

        self.initViewControllers()
    }

    func initViewControllers() {
        
        let controller1 = HMainController6()
        controller1.h_tabItemTitle = "第一个"
        
        let controller2 = UIViewController()
        controller2.view.backgroundColor = UIColor.green
        controller2.h_tabItemTitle = "第二个"
        
        let controller3 = UIViewController()
        controller3.view.backgroundColor = UIColor.blue
        controller3.h_tabItemTitle = "第三个"
        
        self.viewControllers = NSMutableArray(objects: controller1, controller2, controller3)
    }

}
