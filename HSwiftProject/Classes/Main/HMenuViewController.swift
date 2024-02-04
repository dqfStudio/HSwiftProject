//
//  HMenuViewController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
//import SwizzleSwift
//import SwiftyLoad

private let kTabBarHeight: CGFloat = 50.0

class HMenuViewController: HTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.isHidden = true
        self.initViewControllers()
        self.addSpecialItem()
        self.setupFrameOfTabBarAndContentView()
    }
    
    func initViewControllers() {
        
        let mainVC1 = HMainController1()
        mainVC1.h_tabItemTitle = "第一页"
        mainVC1.h_tabItemImage = UIImage(named: "di_index")
        mainVC1.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        let mainVC2 = HMainController2()
//        let mainVC2 = HPostVC()
        mainVC2.h_tabItemTitle = "第二页"
        mainVC2.h_tabItemImage = UIImage(named: "di_index")
        mainVC2.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        let mainVC3 = HMainController3()
        mainVC3.h_tabItemTitle = "第三页"
        mainVC3.h_tabItemImage = UIImage(named: "di_index")
        mainVC3.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        let mainVC4 = HMainController4()
        mainVC4.h_tabItemTitle = "第四页"
        mainVC4.h_tabItemImage = UIImage(named: "di_index")
        mainVC4.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        let mainVC5 = HMainController7()
        mainVC5.h_tabItemTitle = "第五页"
        mainVC5.h_tabItemImage = UIImage(named: "di_index")
        mainVC5.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        let loginVC = HLoginController()
        loginVC.h_tabItemTitle = "登录"
        loginVC.h_tabItemImage = UIImage(named: "di_index")
        loginVC.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        let registerVC = HRegisterController()
        registerVC.h_tabItemTitle = "注册"
        registerVC.h_tabItemImage = UIImage(named: "di_index")
        registerVC.h_tabItemSelectedImage = UIImage(named: "di_index_h")
        
        self.viewControllers = [mainVC1, mainVC2, mainVC3, mainVC4, mainVC5, loginVC, registerVC]
    }
    
    func setupFrameOfTabBarAndContentView() {

        // 设置默认的tabBar的frame和contentViewFrame
        let screenSize = UIScreen.main.bounds.size
        
        var contentViewY: CGFloat = 0.0
        var tabBarY: CGFloat = screenSize.height - kTabBarHeight
        tabBarY -= UIScreen.bottomBarHeight
        
        var contentViewHeight: CGFloat = tabBarY
        // 如果parentViewController为UINavigationController及其子类
        if self.parent != nil && self.navigationController != nil {
            if self.parent!.isKind(of: UINavigationController.self) && !self.navigationController!.isNavigationBarHidden && !self.navigationController!.navigationBar.isHidden {
                let navMaxY: CGFloat = self.navigationController!.navigationBar.frame.maxY
                if (!self.navigationController!.navigationBar.isTranslucent ||
                    self.edgesForExtendedLayout == Optional.none ||
                    self.edgesForExtendedLayout == .top) {
                    tabBarY = screenSize.height - kTabBarHeight - navMaxY
                    contentViewHeight = tabBarY
                } else {
                    contentViewY = navMaxY
                    contentViewHeight = screenSize.height - kTabBarHeight - contentViewY
                }
            }
        }
        
        self.setTabBarFrame(CGRect(x: 0, y: tabBarY, width: screenSize.width, height: kTabBarHeight),
                            contentViewFrame: CGRect(x: 0, y: contentViewY, width: screenSize.width, height: contentViewHeight))
        
        self.tabBar.itemTitleColor = UIColor(hex: "#535353")
        self.tabBar.itemTitleSelectedColor = UIColor(hex: "#CFA359")
        self.tabBar.itemTitleFont = .systemFont(ofSize: 14.0)
        self.tabBar.itemTitleSelectedFont = .systemFont(ofSize: 14.0)
        self.tabBar.backgroundColor = .white
        self.tabBar.addTopLineViewWithColor(UIColor.gray)
        self.tabBar.addBottomBlankViewWithColor(UIColor.white)
    }
    
    func addSpecialItem() {
        
        let specialItem: HTabItem = HTabItem(type: .custom)
        specialItem.title = "中间"
        specialItem.image = UIImage(named: "di_zhuce")
        specialItem.selectedImage = UIImage(named: "di_zhuce")
        specialItem.titleColor = UIColor(hex: "#535353")
        specialItem.titleSelectedColor = UIColor(hex: "#CFA359")
        specialItem.backgroundColor = UIColor.clear
        specialItem.titleFont = .systemFont(ofSize: 14.0)
        
        specialItem.setContentHorizontalCenterWithVerticalOffset(13, spacing: 10)
        // 设置其size，如果不设置，则默认为与其他item一样
        specialItem.size = CGSize(width: UIScreen.width / 7, height: 80)
        
        //@www
        self.tabBar.setSpecialItem(specialItem, afterItemWithIndex: 2) { (item) in
            //@sss
//            HNavigationController *registerVC = [[HNavigationController alloc] initWithRootViewController:HMainController5.new]
//            [self presentViewController:registerVC animated:YES completion:nil]
            self.navigationController?.pushViewController(HMainController5(), animated: true)
        }
    }

}

//
//extension HMenuViewController {
//
//    objc class func swizzle() {
//        Swizzle(HMenuViewController.self) {
//            #selector(viewDidLoad) <-> #selector(myViewDidLoad)
//            #selector(viewWillAppear(_:)) <-> #selector(myViewWillAppear(_:))
//        }
//    }
//
//    objc private func myViewDidLoad() {
//        print(#function)
//        myViewDidLoad()
//    }
//
//    objc private func myViewWillAppear(_ animated: Bool) {
//        print(#function)
//        myViewWillAppear(animated)
//    }
//
//}
//
//
//extension HMenuViewController : NSSwiftyLoadProtocol {
//    public static func swiftyLoad() {
//        print("UIViewController--->swiftyLoad")
//
////        static let share: HPrinterManager = {
////            let instance = HPrinterManager()
////            return instance
////        }()
//    }
//}
