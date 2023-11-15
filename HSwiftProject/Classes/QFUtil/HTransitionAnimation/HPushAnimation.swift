//
//  HPushAnimation.swift
//  HSwiftProject
//
//  Created by Wind on 23/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HPushAnimation: HTransitionAnimation {
    
    var pushAnimationType: HPushAnimationType = .ocdoor

    // 重写父类方法
    override func startPushAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        switch (pushAnimationType) {
        case .ocdoor:
            self.animationForPushView(transitionContext)
            break
        }
    }
    override func startPopAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        switch (pushAnimationType) {
        case .ocdoor:
            self.animationForPopView(transitionContext)
            break
        }
    }

    override func endPushAnimation() {
        if let completion = self.transitionCompletion {
            completion(.push)
        }
    }
    override func endPopAnimation() {
        if let completion = self.transitionCompletion {
            completion(.pop)
        }
    }

    // 自定义动画实现方法
    //弹出动画，开关门动画
    func animationForPushView(_ transitionContext: UIViewControllerContextTransitioning) {
        //取出转场前后视图控制器上的视图view
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        let containerView = transitionContext.containerView
        //左侧动画视图
        let leftView: UIView = UIView(frame: CGRect(x: -toView.width / 2, y: 0, width: toView.width / 2, height: toView.height))
        leftView.clipsToBounds = true
        leftView.addSubview(toView)
        //右侧动画视图
        //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
        guard let rightToView = toView.snapshotView(afterScreenUpdates: true) else { return }
        rightToView.frame = CGRect(x: -toView.width / 2, y: 0, width: toView.width, height: toView.height)
        let rightView: UIView = UIView(frame: CGRect(x: toView.width, y: 0, width: toView.width / 2, height: toView.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightToView)
        
        //加入动画视图
        containerView.addSubview(fromView)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionFlipFromRight) {
            leftView.frame = CGRect(x: 0, y: 0, width: toView.width / 2, height: toView.height)
            rightView.frame = CGRect(x: toView.width / 2, y: 0, width: toView.width / 2, height: toView.height)
        } completion: { finished in
            //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            if (transitionContext.transitionWasCancelled) {
                //手势取消
            }else {
                //手势完成
                containerView.addSubview(toView)
            }
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            toView.isHidden = false
        }
    }

    // 弹框消失
    func animationForPopView(_ transitionContext: UIViewControllerContextTransitioning) {
        //取出转场前后视图控制器上的视图view
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        let containerView = transitionContext.containerView

        //左侧动画视图
        guard let leftFromView = fromView.snapshotView(afterScreenUpdates: false) else { return }
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: fromView.width / 2, height: fromView.height))
        leftView.clipsToBounds = true
        leftView.addSubview(leftFromView)
        //右侧动画视图
        guard let rightFromView = fromView.snapshotView(afterScreenUpdates: false) else { return }
        rightFromView.frame = CGRect(x: -fromView.width / 2, y: 0, width: fromView.width, height: fromView.height)
        let rightView = UIView(frame: CGRect(x: fromView.width / 2, y: 0, width: fromView.width / 2, height: fromView.height))
        rightView.clipsToBounds = true
        rightView.addSubview(rightFromView)

        containerView.addSubview(toView)
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)

        fromView.isHidden = true
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionFlipFromRight) {
            leftView.frame = CGRect(x: -fromView.width / 2, y: 0, width: fromView.width / 2, height: fromView.height)
            rightView.frame = CGRect(x: fromView.width, y: 0, width: fromView.width / 2, height: fromView.height)
        } completion: { finished in
            fromView.isHidden = false
            leftView.removeFromSuperview()
            rightView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
}
