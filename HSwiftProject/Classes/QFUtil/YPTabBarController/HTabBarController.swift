//
//  HTabBarController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/2.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTabBarController : HViewController, HTabContentViewDelegate {

    var tabBar: HTabBar {
        return self.tabContentView.tabBar
    }

    private var _tabContentView: HTabContentView = HTabContentView()
    var tabContentView: HTabContentView {
        return _tabContentView
    }
    
    var viewControllers: NSArray? {
        get {
            return self.tabContentView.viewControllers
        }
        set {
            self.tabContentView.viewControllers = newValue
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self._setup()
    }

    private func _setup() {
        self.tabContentView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tabContentView)
        self.view.addSubview(self.tabBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.h_willAppearInjectBlock != nil {
            self.h_willAppearInjectBlock!(self, animated)
        }
    }

    /**
     *  设置tabBar和contentView的frame，
     *  默认是tabBar在底部，contentView填充其余空间
     *  如果设置了headerView，此方法不生效
     */
    func setTabBarFrame(_ tabBarFrame: CGRect, contentViewFrame: CGRect) {
        if self.tabContentView.headerView != nil {
            return
        }
        self.tabBar.frame = tabBarFrame
        self.tabContentView.frame = contentViewFrame
    }
    
    //震动
    private func vibrate() {
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
    }

    func tabContentView(_ tabConentView: HTabContentView, shouldSelectTabAtIndex index: Int) -> Bool {
        self.vibrate()
        return true
    }
    
}
