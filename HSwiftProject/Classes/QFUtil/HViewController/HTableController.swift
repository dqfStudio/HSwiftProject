//
//  HTableController.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTableController: HViewController, HTableViewDelegate {
    
    lazy var tableView: HTableView = {
        return HTableView(frame: .zero)
    }()
    
    /// Whether to use auto layout. Default is YES.
    var autoLayout: Bool = true
    /// Whether to extend the top layout. Default is YES.
    var topExtendedLayout: Bool = true
    /// The height of the extended bottom layout. Default is 0.0.
    var bottomExtendedHeight: CGFloat = 0.0
    /// The extended insets. Default is UIEdgeInsetsZero.
    var extendedInset: UIEdgeInsets = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIScreen.isIPhoneX {
            extendedInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.bottomBarHeight, right: 0)
        }
        view.addSubview(tableView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            tableView.releaseTableBlock()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if autoLayout {//Default is YES
            var frame = view.bounds
            if topExtendedLayout {//Default is YES
                frame.origin.y += UIScreen.topBarHeight
                frame.size.height -= UIScreen.topBarHeight
            }
            frame.size.height -= bottomExtendedHeight
            self.tableView.frame = frame
            if extendedInset != .zero {//If the value has been set
                if self.tableView.contentInset != extendedInset {//If the set value is not equal to the current value
                    self.tableView.contentInset = extendedInset
                }
            }
        }
    }
}
