//
//  UIViewController+HAnimation.swift
//  HSwiftProject
//
//  Created by Wind on 23/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

private var pushAnimationKey = "pushAnimationKey"
private var presentAnimationKey = "presentAnimationKey"

extension UIViewController {

    //动画管理类(Present、Dismiss)
    var presentAnimation: HPresentAnimation? {
        get {
            return objc_getAssociatedObject(self, &presentAnimationKey) as? HPresentAnimation
        }
        set {
            objc_setAssociatedObject(self, &presentAnimationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //动画管理类(Push、Pop)
    var pushAnimation: HPushAnimation? {
        get {
            return objc_getAssociatedObject(self, &pushAnimationKey) as? HPushAnimation
        }
        set {
            objc_setAssociatedObject(self, &pushAnimationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push) {
            self.pushAnimation?.transitionType = .push
            return self.pushAnimation
        }else if (operation == .pop) {
            self.pushAnimation?.transitionType = .pop
            return self.pushAnimation
        }
        return nil
    }
}

extension UIViewController {

    // Present、Dismiss -> Alert、Sheet
    /*
     viewController 要显示的控制器
     completion     动画结束后的回调
    */
    func presentController(_ viewController:UIViewController, completion: HTransitionCompletion?) {
        let animation = HPresentAnimation()
        animation.presetType = viewController.presetType
        animation.contentSize = viewController.containerSize
        animation.transitionDuration = viewController.animationDuration
        animation.shadowColor = viewController.shadowColor
        animation.isShadowDismiss = viewController.isShadowDismiss
        animation.transitionCompletion = completion
        self.presentAnimation = animation
        viewController.modalPresentationStyle = .custom //设置目标vc的动画为自定义
        viewController.transitioningDelegate = animation //设置动画管理代理类
        self.present(viewController, animated: true, completion: nil)
    }

    // Push、Pop
    /*
     viewController 要显示的控制器
     completion     动画结束后的回调
    */
    func pushViewController(_ viewController: UIViewController, completion: HTransitionCompletion?) {
        let animation = HPushAnimation()
        animation.pushAnimationType = viewController.animationType
        animation.transitionCompletion = completion
        self.pushAnimation = animation
        var navigationVC: UINavigationController?
        if (self.isKind(of: UINavigationController.self)) {
            navigationVC = self as? UINavigationController
        }else {
            navigationVC = viewController.navigationController
        }
        navigationVC?.delegate = self as? UINavigationControllerDelegate
        navigationVC?.pushViewController(viewController, animated: true)
    }

}
