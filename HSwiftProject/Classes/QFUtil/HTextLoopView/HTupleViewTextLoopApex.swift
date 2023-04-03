//
//  HTupleViewTextLoopApex.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/8.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HTupleViewTextLoopApexBlock = (_ selectString: NSString, _ index: Int) -> Void

class HTupleViewTextLoopApex: HTupleBaseApex {

    private var _contentArr: NSArray?
    var contentArr: NSArray? {
        get {
            return _contentArr
        }
        set {
            if _contentArr != newValue {
                _contentArr = nil
                _contentArr = newValue
                if _contentArr!.count > 0 {
                    self.layoutView.addSubview(self.textLoopView)
                }
            }
        }
    }
    var selectedBlock: HTupleViewTextLoopApexBlock?
    
    private var _textLoopView: HTextLoopView?
    var textLoopView: HTextLoopView {
        if _textLoopView == nil {
            _textLoopView = HTextLoopView.textLoopViewWithFrame(self.bounds, self.contentArr!, 2.0) { (selectString, index) in
                if self.selectedBlock != nil {
                    self.selectedBlock!(selectString, index)
                }
            }
        }
        return _textLoopView!
    }
    
    override func relayoutSubviews() {
        if self.contentArr!.count > 0 {
            HLayoutTupleApex(self.textLoopView)
        }
    }

}
