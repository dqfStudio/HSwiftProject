//
//  HActiveNaviController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/5.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HActiveNaviController: HBaseNaviController {
    
    var barTintColor = UIColor.clear
    var navBarBGColor = UIColor.black
    var isTranslucent = true
    var navBarShadowVisible = false
    var navBarTitleTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.font(ofSize: 17, weight: .medium)]
    var navTintColor = UIColor.white

    /// Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set related properties
        self.pvc_naviBar()
    }
    
    // Set related properties
    private func pvc_naviBar() {
        self.navigationBar.barTintColor = barTintColor
        //self.navigationBar.setBackgroundImage(navBarBGColor.image(scale: 0), for: .any, barMetrics: .default)
        self.navigationBar.isTranslucent = isTranslucent
        self.navigationBar.shadowImage = navBarShadowVisible ? nil : UIImage()
        self.navigationBar.titleTextAttributes = navBarTitleTextAttributes
        self.navigationBar.tintColor = navTintColor
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = nil
        
        if #available(iOS 15.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = navBarBGColor
            navBarAppearance.backgroundEffect = nil
            navBarAppearance.shadowColor = UIColor.clear
            navBarAppearance.titleTextAttributes = navBarTitleTextAttributes
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    class func fullScreenModalNavi(rootVC: UIViewController) -> HActiveNaviController {
        let navi = HActiveNaviController(rootViewController: rootVC)
        navi.modalPresentationStyle = .fullScreen
        return navi
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
            viewController.addNaviLeftItem(self.navigationBar.tintColor)
        }
        super.pushViewController(viewController, animated: true)
    }
    
    func setNaviBarBackgroundColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = color
            //navBarAppearance.backgroundImage = color.image()
            navBarAppearance.backgroundEffect = nil
            navBarAppearance.shadowColor = UIColor.clear
            navBarAppearance.titleTextAttributes = navBarTitleTextAttributes
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }

}
