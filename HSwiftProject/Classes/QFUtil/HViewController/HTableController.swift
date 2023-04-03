//
//  HTableController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTableController: HViewController, HTableViewDelegate {
    
    private var _tableView: HTableView?
    var tableView: HTableView {
        if _tableView == nil {
            _tableView = HTableView(frame: CGRect.zero)
        }
        return _tableView!
    }
    
    ///default YES
    var autoLayout: Bool = true
    ///default YES
    var topExtendedLayout: Bool = true
    ///default 0.0
    var bottomExtendedHeight: CGFloat = 0.0
    ///default UIEdgeInsetsZero
    var extendedInset: UIEdgeInsets = UIEdgeInsetsZero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UIScreen.isIPhoneX) {
            extendedInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.bottomBarHeight, right: 0)
        }
        self.view.addSubview(self.tableView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if (type == .pop || type == .dismiss) {
            self.tableView.releaseTableBlock()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if autoLayout {//默认为YES
            var frame: CGRect = self.view.bounds
            if topExtendedLayout {//默认为YES
                frame.origin.y += UIScreen.topBarHeight
                frame.size.height -= UIScreen.topBarHeight
            }
            frame.size.height -= bottomExtendedHeight
            self.tableView.frame = frame
            if UIEdgeInsetsZero != extendedInset {//设置过值
                if tableView.contentInset != extendedInset {//设置的值与现有的值不相等
                    self.tableView.contentInset = extendedInset
                }
            }
        }
    }
}
