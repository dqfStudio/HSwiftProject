//
//  XPresentationController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class XPresentationController: UIPresentationController {
    
    //蒙层颜色
    var shadowColor: UIColor = UIColor(white: 0.1, alpha: 0.2) {
        didSet {
            self.containerView?.backgroundColor = shadowColor
        }
    }
    
    //弹出框类型
    @objc var presentType: HTransitionStyle = .alert
    
    ///点击阴影是否关闭页面
    @objc var isShadowDismiss: Bool = false

    // 重写UIPresentationController的方法
    //重写构造方法
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom自定义
        presentedViewController.modalPresentationStyle = .custom
    }

    // 呈现过渡即将开始的时候被调用的
    // 可以在此方法创建和设置自定义动画所需的view
    override func presentationTransitionWillBegin() {
        // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
       // 动画期间，背景View的动画方式
        self.containerView?.alpha = 0.0
        transitionCoordinator?.animateAlongsideTransition(in: nil, animation: { context in
            self.containerView?.alpha = 1.0
        }, completion: nil)
    }

    // 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
    override func presentationTransitionDidEnd(_ completed: Bool) {
        //NSLog(@"过渡结束")
    }

    // 消失过渡即将开始的时候被调用的
    override func dismissalTransitionWillBegin() {
        self.containerView?.alpha = 0.0
    }

    // 消失过渡完成之后调用，此时应该将视图移除
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.presentedView?.removeFromSuperview()
        }
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var shouldRemovePresentersView: Bool {
        return false
    }

}
