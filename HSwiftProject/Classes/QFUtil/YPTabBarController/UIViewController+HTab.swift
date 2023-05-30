//
//  UIViewController+HTab.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/30.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

private var h_tabItemTitleKey = "h_tabItemTitleKey"
private var h_tabItemImageKey = "h_tabItemImageKey"
private var h_tabItemSelectedImageKey = "h_tabItemSelectedImageKey"
private var h_disableMinContentHeightKey = "h_disableMinContentHeightKey"

extension UIViewController {
    
    var h_tabItem: HTabItem? {
        let tabBar: HTabBar? = self.h_tabBarController?.tabBar
        if tabBar == nil {
            return nil
        }
        if !(self.h_tabBarController?.viewControllers?.contains(self) ?? false) {
            return nil
        }
        
        let index = self.h_tabBarController?.viewControllers?.index(of: self)
        return tabBar?.items?[index!] as? HTabItem
    }

    var h_tabBarController: HTabBarController? {
        if self.parent?.isKind(of: HTabBarController.self) ?? false {
            return self.parent as? HTabBarController
        }
        return nil
    }

    /// tabItem的标题
    var h_tabItemTitle: String? {
        get { return self.getAssociatedValueForKey(&h_tabItemTitleKey) as? String }
        set {
            self.h_tabItem?.title = newValue
            self.setAssociateValue(newValue, key: &h_tabItemTitleKey)
        }
    }
    
    /// tabItem的图像
    var h_tabItemImage: UIImage? {
        get { return self.getAssociatedValueForKey(&h_tabItemImageKey) as? UIImage }
        set {
            self.h_tabItem?.image = newValue
            self.setAssociateValue(newValue, key: &h_tabItemImageKey)
        }
    }
    
    /// tabItem的选中图像
    var h_tabItemSelectedImage: UIImage? {
        get { return self.getAssociatedValueForKey(&h_tabItemSelectedImageKey) as? UIImage }
        set {
            self.h_tabItem?.selectedImage = newValue
            self.setAssociateValue(newValue, key: &h_tabItemSelectedImageKey)
        }
    }

    /**
     *  ViewController对应的Tab被Select后，执行此方法，此方法为回调方法
     *
     *  @param isFirstTime  是否为第一次被选中
     */
    @objc
    func h_tabItemDidSelected(_ isFirstTime: Bool) {
        
    }

    /**
     *  ViewController对应的Tab被Deselect后，执行此方法，此方法为回调方法
     */
    @objc
    func h_tabItemDidDeselected() {
        
    }

    /**
     *  返回用于显示的View，默认是self.view
     *  当设置headerView的时候，需要把scrollView或者tableView返回
     */
    var h_displayView: UIView {
        return self.view
    }

    /**
     *  返回是否开启最小ContentHeight
     */
    var h_disableMinContentHeight: Bool {
        get { return self.getAssociatedValueForKey(&h_disableMinContentHeightKey) as? Bool ?? false }
        set { self.setAssociateWeakValue(newValue, key: &h_disableMinContentHeightKey) }
    }

}
