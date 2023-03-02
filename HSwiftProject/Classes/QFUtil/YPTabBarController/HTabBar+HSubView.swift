//
//  HTabBar+HSubView.swift
//  HSwiftProject
//
//  Created by wind on 2019/12/2.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension HTabBar {
    ///顶部添加分割线
    func addTopLineViewWithColor(_ color: UIColor) {
        let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
        let lineView: UIView = UIView(frame: frame)
        lineView.backgroundColor = color
        self.addSubview(lineView)
        self.sendSubviewToBack(lineView)
    }
    ///底部添加分割线
    func addBottomLineViewWithColor(_ color: UIColor) {
        let frame: CGRect = CGRect(x: 0, y: self.frame.height - 1, width: UIScreen.main.bounds.width, height: 1)
        let lineView: UIView = UIView(frame: frame)
        lineView.backgroundColor = color
        self.addSubview(lineView)
        self.sendSubviewToBack(lineView)
    }
    ///添加空白适配
    func addBottomBlankViewWithColor(_ color: UIColor) {
        if UIDevice.isIPhoneX {
            var frame: CGRect = self.bounds
            frame.origin.y = frame.size.height
            frame.size.height = UIDevice.bottomBarHeight
            let bottomView: UIView = UIView(frame: frame)
            bottomView.backgroundColor = color
            self.addSubview(bottomView)
            self.clipsToBounds = false
        }
    }
}
