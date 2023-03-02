//
//  UIViewController+HTransition.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //转场动画内容视图的大小
    @objc var containerSize: CGSize {
        return CGSize.zero
    }
    //转场动画的时间
    @objc var animationDuration: CGFloat {
        return 0.25
    }
    //转场动画内容视图阴影部分颜色
    @objc var shadowColor: UIColor? {
        return nil
    }
    //转场动画内容视图点击是否整体消失
    @objc var isShadowDismiss: Bool {
        return false
    }
    //是否隐藏视觉展示效果，如毛玻璃效果
    @objc var hideVisualView: Bool {
        return false
    }
    //转场类型
    @objc var presetType: HTransitionStyle {
        return .alert
    }
    //push转场动画具体类型
    @objc var animationType: HPushAnimationType {
        return .ocdoor
    }
    
}
