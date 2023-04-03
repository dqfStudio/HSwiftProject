//
//  HTupleViewMarqueeCell.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/20.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HTupleViewMarqueeCellBlock = () -> Void

class HTupleViewMarqueeCell: HTupleBaseCell {

    ///显示的文字
    private var _msg: String?
    var msg: String? {
        get {
            return _msg
        }
        set {
            if _msg != newValue {
                _msg = nil
                _msg = newValue
                self.marquee.msg = newValue
                self.marquee.start()
            }
        }
    }
    ///背景颜色
    private var _bgColor: UIColor?
    var bgColor: UIColor? {
        get {
            return _bgColor
        }
        set {
            if _bgColor != newValue {
                _bgColor = nil
                _bgColor = newValue
                self.marquee.backgroundColor = newValue
            }
        }
    }
    ///字体颜色
    private var _txtColor: UIColor?
    var txtColor: UIColor? {
        get {
            return _txtColor
        }
        set {
            if _txtColor != newValue {
                _txtColor = nil
                _txtColor = newValue
                self.marquee.txtColor = newValue
            }
        }
    }
    var selectedBlock: HTupleViewMarqueeCellBlock?
    
    private var _marquee: HMarquee?
    private var marquee: HMarquee {
        if _marquee == nil {
            _marquee = HMarquee(frame: self.bounds, speed: .MediumSlow, msg: nil)
            _marquee!.changeTapMarqueeAction {
                if self.selectedBlock != nil {
                    self.selectedBlock!()
                }
            }
        }
        return _marquee!
    }

    override func relayoutSubviews() {
        HLayoutTupleCell(self.marquee)
    }

    override func initUI() {
        self.layoutView.addSubview(self.marquee)
    }

}
