//
//  HPresentAnimation.swift
//  HSwiftProject
//
//  Created by Wind on 22/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

class HPresentAnimation : HTransitionAnimation, UIViewControllerTransitioningDelegate {

    //转场视图尺寸大小
    @objc var contentSize: CGSize = CGSize.zero

    //转场动画类型(默认Alert)
    var presetType: HTransitionStyle = .alert

    //转场视图点击背景是否dismiss (消失）默认NO
    @objc var isShadowDismiss: Bool = false

    //转场视图背景颜色
    @objc var shadowColor: UIColor = UIColor(white: 0.1, alpha: 0.2)

    //管理要显示视图的VC
    @objc private var presentationVC: HPresentationController?

    // UIViewControllerTransitioningDelegate
    // 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .present
        return self
    }
    // 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .dismiss
        return self
    }

    // 重写父类方法
    override func startPresentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        self.animationForPresentedView(transitionContext)
    }
    override func startDismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        self.animationForDismissedView(transitionContext)
    }

    override func endPresentAnimation() {
        if let completion = self.transitionCompletion {
            completion(.present)
        }
    }
    override func endDismissAnimation() {
        if let completion = self.transitionCompletion {
            completion(.dismiss)
        }
    }

    // 自定义动画实现方法
    //弹出动画
    private func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        //获得要显示的view
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        transitionContext.containerView.addSubview(presentedView)
        
        //蒙层颜色
        self.presentationVC?.shadowColor = self.shadowColor
        //设置阴影
//        transitionContext.containerView.layer.shadowColor = self.coverColor.CGColor
//        transitionContext.containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
//        transitionContext.containerView.layer.shadowOpacity = 0.5
//        transitionContext.containerView.layer.shadowRadius = 10.0
        
        //动画时间
        let duration = self.transitionDuration(using: transitionContext)
        
        if self.presetType == .alert {
            presentedView.alpha = 0.0
            presentedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 50, options: .curveEaseInOut) {
                presentedView.alpha = 1.0
                presentedView.transform = .identity
            } completion: { finished in
                if finished {
                    transitionContext.completeTransition(true)
                }
            }
        } else if self.presetType == .sheet {
            presentedView.alpha = 0.0
            let screenHeight = UIScreen.main.bounds.height
            presentedView.frame = CGRect(x: 0, y: screenHeight, width: self.contentSize.width, height: self.contentSize.height)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                presentedView.alpha = 1.0
                presentedView.frame = CGRect(x: 0, y: screenHeight - self.contentSize.height, width: self.contentSize.width, height: self.contentSize.height)
            } completion: { finished in
                if finished {
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
    // 弹框消失
    private func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        //动画时间
        let duration = self.transitionDuration(using: transitionContext)
        
        if self.presetType == .alert {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
                presentedView.removeFromSuperview()
                transitionContext.completeTransition(true)
            } completion: { finished in
                
            }
        }else if self.presetType == .sheet {
            UIView.animate(withDuration: duration) {
                presentedView.transform = CGAffineTransform(translationX: 0, y: self.contentSize.height)
            } completion: { finished in
                if finished {
                    presentedView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
            }
        }
    }

}

extension HPresentAnimation {
    // UIViewControllerTransitioningDelegate
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationVC = HPresentationController(presentedViewController: presented, presenting: presenting)
        presentationVC.presentType = self.presetType
        presentationVC.contentSize = self.contentSize
        presentationVC.isShadowDismiss = self.isShadowDismiss
        presentationVC.shadowColor = self.shadowColor
        self.presentationVC = presentationVC
        return presentationVC
    }
}
