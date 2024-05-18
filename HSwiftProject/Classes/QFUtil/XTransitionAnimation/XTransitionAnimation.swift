//
//  XTransitionAnimation.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class XTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    //转场动画类型
    var transitionType: HTransitionType = .push

    //动画时间, 默认0.25秒
    var transitionDuration: TimeInterval = 0.25

    //转场动画结束回调
    var transitionCompletion: HTransitionCompletion?

    //动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }

    //所有的过渡动画事务都在这个方法里面完成
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch (transitionType) {
        case .push:
            self.startPushAnimation(transitionContext)
            break
        case .pop:
            self.startPopAnimation(transitionContext)
            break
        case .present:
            self.startPresentAnimation(transitionContext)
            break
        case .dismiss:
            self.startDismissAnimation(transitionContext)
            break
        }
    }

    //动画结束
    func animationEnded(_ transitionCompleted: Bool) {
        if (transitionCompleted) {
            switch (transitionType) {
            case .push:
                self.endPushAnimation()
                break
            case .pop:
                self.endPopAnimation()
                break
            case .present:
                self.endPresentAnimation()
                break
            case .dismiss:
                self.endDismissAnimation()
                break
            }
        }
    }

    //动画开始方法
    func startPushAnimation(_ transitionContext: UIViewControllerContextTransitioning) {}
    func startPopAnimation(_ transitionContext: UIViewControllerContextTransitioning) {}
    func startPresentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {}
    func startDismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {}

    //动画结束方法
    func endPushAnimation() {}
    func endPopAnimation() {}
    func endPresentAnimation() {}
    func endDismissAnimation() {}

}

