//
//  HActiveTabbarVC.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/6.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit
import Accelerate

class HActiveTabbarVC: UITabBarController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1 //初始选择1
    }

}

// MARK: - UI
extension HActiveTabbarVC {
    private func makeUI() {
//        tabbarLine.backgroundColor = UIColor(rgb: 0xF5F6F7)
//        self.tabBar.addSubview(tabbarLine)
//        tabbarLine.snp.makeConstraints { make in
//            make.left.right.top.equalToSuperview()
//            make.height.equalTo(1)
//        }
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().layer.borderWidth = 0
//        tabBar.tintColor = UIColor.white//选中
//        tabBar.unselectedItemTintColor = UIColor(rgb: 0x808080)//未选中
        tabBar.backgroundColor = UIColor.white
        
        /*
        let discoverNav = FCNavVC(rootViewController: FCDiscoverContainer())
        discoverNav.tabBarItem = makeTabItem(title: "发现".localized(),
                                             image: "tab_discover",
                                             selectedImage: "tab_discover_sel")
        
        let chatsNav = FCNavVC(rootViewController: FCChatsVC())
        self.chatsNav = chatsNav
        chatsNav.tabBarItem = makeTabItem(title: "聊天".localized(),
                                           image: "tab_msg2",
                                           selectedImage: "tab_msg_sel")
        
        let contactsNav = FCNavVC(rootViewController: HContactsVC())
        contactsNav.tabBarItem = makeTabItem(title: "联系人".localized(),
                                             image: "tab_contacts",
                                             selectedImage: "tab_contacts_sel")
        // vc列表
        let viewControllers = [discoverNav, chatsNav, contactsNav]
        setViewControllers(viewControllers, animated: false)
         */
    }

    private func makeTabItem(title: String?, image: String, selectedImage: String) -> UITabBarItem {
        let itemImage = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        let selectedItemImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        let item = UITabBarItem(title: nil, image: itemImage, selectedImage: selectedItemImage)
        //item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.itemBg], for: .normal)
        //item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.text], for: .selected)
        return item
    }
}

// MARK: - Event
extension HActiveTabbarVC {
    //震动
    private func vibrate() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// MARK: - UITabBarControllerDelegate
extension HActiveTabbarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.vibrate()
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}

// MARK: - Landscape and portrait
extension HActiveTabbarVC {
    // Whether to rotate automatically, returning YES can rotate automatically
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    // Return the supported direction
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    // This is the preferred direction
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
