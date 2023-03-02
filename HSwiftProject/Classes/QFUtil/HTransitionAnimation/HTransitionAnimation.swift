//
//  HTransitionAnimation.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HTransitionAnimation : NSObject, UIViewControllerAnimatedTransitioning {

    //转场动画类型
    private var _transitionType : HTransitionType = .push
    var transitionType : HTransitionType {
        get {
            return _transitionType
        }
        set {
            _transitionType = newValue
        }
    }

    //动画时间, 默认0.25秒
    private var _transitionDuration: TimeInterval = 0.25
    var transitionDuration: TimeInterval {
        get {
            return _transitionDuration
        }
        set {
            _transitionDuration = newValue
        }
    }

    //转场动画结束回调
    var transitionCompletion: HTransitionCompletion?

    //动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }

    //所有的过渡动画事务都在这个方法里面完成
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch (_transitionType) {
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
            switch (_transitionType) {
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
