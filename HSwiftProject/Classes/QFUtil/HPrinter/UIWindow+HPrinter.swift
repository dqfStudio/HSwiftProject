//
//  UIWindow+HPrinter.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

#if DEBUG

extension UIWindow {

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 判断自己能否接收事件
        if(self.isUserInteractionEnabled == false || self.isHidden == true || self.alpha <= 0.01) {
               return nil
        }
        // 触摸点在不在自己身上
        if (self.point(inside: point, with: event) == false) {
            return nil
        }
        // 从后往前遍历自己的子控件(重复前面的两个步骤)
        for item in self.subviews.enumerated().reversed() {
            let childV:UIView = item.element
            // point必须得要跟childV相同的坐标系.
            // 把point转换childV坐标系上面的点
            let childP:CGPoint = self.convert(point, to: childV)
            let fitView:UIView? = childV.hitTest(childP, with: event)
            if (fitView != nil) {
                fitView!.logMark()
                return fitView
            }
        }
        // 如果没有符合条件的子控件，那么就自己最适合处理
        self.logMark()
        return self
    }

}

#endif
