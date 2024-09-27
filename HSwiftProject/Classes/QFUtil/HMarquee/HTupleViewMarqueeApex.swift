//
//  HTupleViewMarqueeApex.swift
//  HSwiftProject
//
//  Created by Wind on 2020/2/20.
//  Copyright © 2020 wind. All rights reserved.
//

import UIKit

typealias HTupleViewMarqueeApexBlock = () -> Void

class HTupleViewMarqueeApex: HTupleTmplApex {

    ///显示的文字
    var msg: String? {
        didSet {
            if msg != oldValue {
                self.marquee.msg = msg
                self.marquee.start()
            }
        }
    }
    ///背景颜色
    var bgColor: UIColor? {
        didSet {
            if bgColor != oldValue {
                self.marquee.backgroundColor = bgColor
            }
        }
    }
    ///字体颜色
    var txtColor: UIColor? {
        didSet {
            if txtColor != oldValue {
                self.marquee.txtColor = txtColor
            }
        }
    }
    
    var selectedBlock: HTupleViewMarqueeApexBlock?
    
    lazy private var marquee: HMarquee = {
        let marquee = HMarquee(frame: self.bounds, speed: .MediumSlow, msg: nil)
        marquee.changeTapMarqueeAction {
            self.selectedBlock?()
        }
        return marquee
    }()

    override func relayoutSubviews() {
        HLayoutTupleApex(self.marquee)
    }

    override func initUI() {
        self.layoutView.addSubview(self.marquee)
    }

}
