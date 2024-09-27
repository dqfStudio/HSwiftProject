//
//  HTupleViewTextLoopApex.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/8.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HTupleViewTextLoopApexBlock = (_ selectString: NSString, _ index: Int) -> Void

class HTupleViewTextLoopApex: HTupleTmplApex {

    var contentArr: NSArray? {
        didSet {
            if let arr = contentArr, arr.count > 0, let textLoopView = self.textLoopView, textLoopView.superview == nil {
                self.layoutView.addSubview(textLoopView)
            }
        }
    }
    var selectedBlock: HTupleViewTextLoopApexBlock?
    
    private var _textLoopView: HTextLoopView?
    var textLoopView: HTextLoopView? {
        if let arr = contentArr, arr.count > 0, _textLoopView == nil {
            _textLoopView = HTextLoopView.textLoopViewWithFrame(self.bounds, arr, 2.0) { (selectString, index) in
                self.selectedBlock?(selectString, index)
            }
        }
        return _textLoopView
    }
    
    override func relayoutSubviews() {
        if let arr = contentArr, arr.count > 0, let textLoopView = self.textLoopView {
            HLayoutTupleApex(textLoopView)
        }
    }

}
