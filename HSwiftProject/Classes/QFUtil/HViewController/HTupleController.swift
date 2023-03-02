//
//  HTupleController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/26.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTupleController : HViewController, HTupleViewDelegate {
    
    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if _tupleView == nil {
            _tupleView = HTupleView(frame: CGRect.zero)
        }
        return _tupleView!
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
        if (UIDevice.isIPhoneX) {
            extendedInset = UIEdgeInsets(top: 0, left: 0, bottom: UIDevice.bottomBarHeight, right: 0)
        }
        self.view.addSubview(self.tupleView)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if (type == .pop || type == .dismiss) {
            self.tupleView.releaseTupleBlock()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if autoLayout {//默认为YES
            var frame: CGRect = self.view.bounds
            if topExtendedLayout {//默认为YES
                frame.origin.y += UIDevice.topBarHeight
                frame.size.height -= UIDevice.topBarHeight
            }
            frame.size.height -= bottomExtendedHeight
            self.tupleView.frame = frame
            if UIEdgeInsetsZero != extendedInset {//设置过值
                if tupleView.contentInset != extendedInset {//设置的值与现有的值不相等
                    self.tupleView.contentInset = extendedInset
                }
            }
        }
    }

}
