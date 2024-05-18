////
////  HTransitionAnimator.swift
////  HSwiftProject
////
////  Created by owner on 2024/5/18.
////  Copyright © 2024 wind. All rights reserved.
////
//
//import UIKit
//
////enum AnimateType {
////    case none       //无动画
////    case vertical   //竖向
////    case horizontal //横向
////    case fade       //渐变
////}
//
//class HTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
////    enum TransitionType {
////        case present
////        case dismiss
////    }
////    
////    private var transitionType: TransitionType?
////    private var animateType: AnimateType = .none
////    private var duration: TimeInterval = 0.3
////    //针对弹框
////    private var maskView: UIView?
////    private var contentView: UIView?
//    
////    init(transitionType: TransitionType, maskView: UIView, contentView: UIView) {
////        super.init()
////        self.transitionType = transitionType
////        self.maskView = maskView
////        self.contentView = contentView
////    }
////    
////    init(transitionType: TransitionType, animateType: AnimateType = .horizontal, duration: TimeInterval = 0.3) {
////        super.init()
////        self.transitionType = transitionType
////        self.animateType = animateType
////        self.duration = duration
////    }
//    
//    //转场动画类型(默认Alert)
//    @objc var presentType: HTransitionStyle = .alert
//
//    //转场视图点击背景是否dismiss (消失）默认NO
//    @objc var isShadowDismiss: Bool = false
//
//    //转场视图背景颜色
//    @objc var shadowColor: UIColor = UIColor(white: 0.1, alpha: 0.2)
//
//    //管理要显示视图的VC
//    @objc private var presentationVC: HPresentationController?
//
//    // UIViewControllerTransitioningDelegate
//    // 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        self.transitionType = .present
//        return self
//    }
//    // 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        self.transitionType = .dismiss
//        return self
//    }
//
//    // 重写父类方法
//    override func startPresentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
//        self.animationForPresentedView(transitionContext)
//    }
//    override func startDismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
//        self.animationForDismissedView(transitionContext)
//    }
//
//    override func endPresentAnimation() {
//        if let completion = self.transitionCompletion {
//            completion(.present)
//        }
//    }
//    override func endDismissAnimation() {
//        if let completion = self.transitionCompletion {
//            completion(.dismiss)
//        }
//    }
//
//    // 自定义动画实现方法
//    //弹出动画
//    private func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
//        //获得要显示的view
//        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
//        transitionContext.containerView.addSubview(presentedView)
//        
//        //蒙层颜色
//        self.presentationVC?.shadowColor = self.shadowColor
//        //设置阴影
////        transitionContext.containerView.layer.shadowColor = self.coverColor.CGColor
////        transitionContext.containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
////        transitionContext.containerView.layer.shadowOpacity = 0.5
////        transitionContext.containerView.layer.shadowRadius = 10.0
//        
//        //动画时间
//        let duration = self.transitionDuration(using: transitionContext)
//        
//        if self.presentType == .drop {
//            presentedView.alpha = 0.0
//            presentedView.frame = CGRect(x: 0, y: -presentedView.height, width: presentedView.width, height: presentedView.height)
//            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
//                presentedView.alpha = 1.0
//                presentedView.frame = presentedView.bounds
//            } completion: { finished in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//            }
//        } else if self.presentType == .alert {
//            presentedView.alpha = 0.0
//            presentedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 50, options: .curveEaseInOut) {
//                presentedView.alpha = 1.0
//                presentedView.transform = .identity
//            } completion: { finished in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//            }
//        } else if self.presentType == .sheet {
//            presentedView.alpha = 0.0
//            presentedView.frame = CGRect(x: 0, y: presentedView.width, width: presentedView.width, height: presentedView.height)
//            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
//                presentedView.alpha = 1.0
//                presentedView.frame = presentedView.bounds
//            } completion: { finished in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//            }
//        }
//    }
//    // 弹框消失
//    private func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
//        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
//        //动画时间
//        let duration = self.transitionDuration(using: transitionContext)
//        
//        if self.presentType == .drop {
//            UIView.animate(withDuration: duration) {
//                presentedView.transform = CGAffineTransform(translationX: 0, y: -presentedView.height)
//            } completion: { finished in
//                if finished {
//                    presentedView.removeFromSuperview()
//                    transitionContext.completeTransition(true)
//                }
//            }
//        } else if self.presentType == .alert {
//            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
//                presentedView.removeFromSuperview()
//                transitionContext.completeTransition(true)
//            } completion: { finished in
//                
//            }
//        } else if self.presentType == .sheet {
//            UIView.animate(withDuration: duration) {
//                presentedView.transform = CGAffineTransform(translationX: 0, y: presentedView.height)
//            } completion: { finished in
//                if finished {
//                    presentedView.removeFromSuperview()
//                    transitionContext.completeTransition(true)
//                }
//            }
//        }
//    }
//    
////    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
////        return (animateType == .none) ? 0 : duration
////    }
////    
////    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        switch transitionType {
////        case .present:
////            if maskView != nil, contentView != nil {
////                animatePresentViewTransition(using: transitionContext)
////            } else {
////                animatePresentTransition(using: transitionContext)
////            }
////        case .dismiss:
////            if maskView != nil, contentView != nil {
////                animateDismissViewTransition(using: transitionContext)
////            } else {
////                animateDismissTransition(using: transitionContext)
////            }
////        default:
////            break
////        }
////    }
////    
////    //动画时间
////    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
////        return self.transitionDuration
////    }
////
////    //所有的过渡动画事务都在这个方法里面完成
////    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        switch (transitionType) {
////        case .push:
//////            self.startPushAnimation(transitionContext)
////            self.animationForPushView(transitionContext)
//////            break
////        case .pop:
//////            self.startPopAnimation(transitionContext)
////            self.animationForPopView(transitionContext)
//////            break
////        case .present:
//////            self.startPresentAnimation(transitionContext)
////            self.animationForPresentedView(transitionContext)
//////            break
////        case .dismiss:
//////            self.startDismissAnimation(transitionContext)
////            self.animationForDismissedView(transitionContext)
//////            break
////        }
////    }
////    
////    // MARK: - Private Method
////    // MARK: 针对模态
////    private func animatePresentTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        guard let _ = transitionContext.viewController(forKey: .from),
////            let toVC = transitionContext.viewController(forKey: .to)
////            else { return }
////        
////        let containerView = transitionContext.containerView
////        containerView.addSubview(toVC.view)
////        let duration = self.transitionDuration(using: transitionContext)
////
////        // 通知view更新布局(使autolayout值生效)
////        toVC.view.layoutIfNeeded()
////        
////        let width = UIScreen.main.bounds.size.width
////        let height = UIScreen.main.bounds.size.height
////        
////        if animateType == .none {
////            toVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
////            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////        } else if animateType == .vertical {
////            toVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
////            UIView.animate(withDuration: duration, animations: {
////                toVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
////            }) { (isFinish) in
////                let isComplete = !transitionContext.transitionWasCancelled
////                transitionContext.completeTransition(isComplete)
////            }
////        } else if animateType == .horizontal {
////            toVC.view.frame = CGRect(x: width, y: 0, width: width, height: height)
////            UIView.animate(withDuration: duration, animations: {
////                toVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
////            }) { (isFinish) in
////                let isComplete = !transitionContext.transitionWasCancelled
////                transitionContext.completeTransition(isComplete)
////            }
////        } else if animateType == .fade {
////            toVC.view.alpha = 0
////            UIView.animate(withDuration: duration, animations: {
////                toVC.view.alpha = 1
////            }) { (isFinish) in
////                let isComplete = !transitionContext.transitionWasCancelled
////                transitionContext.completeTransition(isComplete)
////            }
////        }
////    }
////    
////    private func animateDismissTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        guard let fromVC = transitionContext.viewController(forKey: .from),
////            let toVC = transitionContext.viewController(forKey: .to)
////            else { return }
////        
////        let containerView = transitionContext.containerView
////        let duration = self.transitionDuration(using: transitionContext)
////        
////        var toView: UIView?
////        var fromView: UIView?
////        
////        if transitionContext.responds(to: #selector(value(forKey:))) {
////            toView = transitionContext.view(forKey: .to)
////            fromView = transitionContext.view(forKey: .from)
////        } else {
////            toView = toVC.view
////            fromView = fromVC.view
////        }
////        
////        guard toView != nil, fromView != nil else {
////            return
////        }
////        
////        containerView.insertSubview(toView!, belowSubview: fromView!)
////        
////        let width = UIScreen.main.bounds.size.width
////        let height = UIScreen.main.bounds.size.height
////        
////        if animateType == .none {
////            fromVC.view.frame = CGRect(x: width, y: 0, width: width, height: height)
////            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////        } else if animateType == .vertical {
////            UIView.animate(withDuration: duration, animations: {
////                fromVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
////            }) { (isFinish) in
////                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            }
////        } else if animateType == .horizontal {
////            UIView.animate(withDuration: duration, animations: {
////                fromView?.frame = CGRect(x: width, y: 0, width: width, height: height)
////            }) { (isFinish) in
////                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            }
////        } else if animateType == .fade {
////            fromVC.view.alpha = 1
////            UIView.animate(withDuration: duration, animations: {
////                fromVC.view.alpha = 0
////            }) { (isFinish) in
////                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
////            }
////        }
////    }
////    
////    // MARK: 针对弹框
////    private func animatePresentViewTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        guard let _ = transitionContext.viewController(forKey: .from),
////            let toVC = transitionContext.viewController(forKey: .to)
////            else { return }
////
////        let containerView = transitionContext.containerView
////        containerView.addSubview(toVC.view)
////        let duration = self .transitionDuration(using: transitionContext)
////        let maskBtnOriginalAlpha = self.maskView?.alpha
////
////        maskView?.alpha = 0.0
////        // 通知view更新布局(使autolayout值生效)
////        toVC.view.layoutIfNeeded()
////        self.contentView?.origin = CGPoint(x: 0, y: containerView.height)
////        UIView.animate(withDuration: duration, animations: {
////            self.maskView?.alpha = maskBtnOriginalAlpha ?? 1
////            self.contentView?.origin = CGPoint(x: 0, y: (containerView.height - self.contentView!.height))
////        }) { (isFinish) in
////            let isComplete = !transitionContext.transitionWasCancelled
////            transitionContext.completeTransition(isComplete)
////        }
////    }
////
////    private func animateDismissViewTransition(using transitionContext: UIViewControllerContextTransitioning) {
////        guard let fromVC = transitionContext.viewController(forKey: .from),
////            let _ = transitionContext.viewController(forKey: .to)
////            else { return }
////
////        let containerView = transitionContext.containerView
////        let duration = self.transitionDuration(using: transitionContext)
////
////        containerView.addSubview(fromVC.view)
////        UIView.animate(withDuration: duration, animations: {
////            self.maskView?.alpha = 0.0
////            self.contentView?.origin = CGPoint(x: 0, y: containerView.height + self.contentView!.height)
////        }) { (isFinish) in
////            let isComplete = !transitionContext.transitionWasCancelled
////            transitionContext.completeTransition(isComplete)
////        }
////    }
//}
//
//// Present
//extension HTransitionAnimator {
//    // 自定义动画实现方法
//    //弹出动画
//    private func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
//        //获得要显示的view
//        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
//        transitionContext.containerView.addSubview(presentedView)
//        
//        //蒙层颜色
//        self.presentationVC?.shadowColor = self.shadowColor
//        
//        //动画时间
//        let duration = self.transitionDuration(using: transitionContext)
//        
//        if self.presentType == .drop {
//            presentedView.alpha = 0.0
//            presentedView.frame = CGRect(x: 0, y: -presentedView.height, width: presentedView.width, height: presentedView.height)
//            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
//                presentedView.alpha = 1.0
//                presentedView.frame = presentedView.bounds
//            } completion: { finished in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//            }
//        } else if self.presentType == .alert {
//            presentedView.alpha = 0.0
//            presentedView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 50, options: .curveEaseInOut) {
//                presentedView.alpha = 1.0
//                presentedView.transform = .identity
//            } completion: { finished in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//            }
//        } else if self.presentType == .sheet {
//            presentedView.alpha = 0.0
//            presentedView.frame = CGRect(x: 0, y: presentedView.width, width: presentedView.width, height: presentedView.height)
//            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
//                presentedView.alpha = 1.0
//                presentedView.frame = presentedView.bounds
//            } completion: { finished in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//            }
//        }
//    }
//    // 弹框消失
//    private func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
//        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
//        //动画时间
//        let duration = self.transitionDuration(using: transitionContext)
//        
//        if self.presentType == .drop {
//            UIView.animate(withDuration: duration) {
//                presentedView.transform = CGAffineTransform(translationX: 0, y: -presentedView.height)
//            } completion: { finished in
//                if finished {
//                    presentedView.removeFromSuperview()
//                    transitionContext.completeTransition(true)
//                }
//            }
//        } else if self.presentType == .alert {
//            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
//                presentedView.removeFromSuperview()
//                transitionContext.completeTransition(true)
//            } completion: { finished in
//                
//            }
//        } else if self.presentType == .sheet {
//            UIView.animate(withDuration: duration) {
//                presentedView.transform = CGAffineTransform(translationX: 0, y: presentedView.height)
//            } completion: { finished in
//                if finished {
//                    presentedView.removeFromSuperview()
//                    transitionContext.completeTransition(true)
//                }
//            }
//        }
//    }
//}
//
////Push
//extension HTransitionAnimator {
//    // 自定义动画实现方法
//    //弹出动画，开关门动画
//    func animationForPushView(_ transitionContext: UIViewControllerContextTransitioning) {
//        //取出转场前后视图控制器上的视图view
//        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
//        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
//        let containerView = transitionContext.containerView
//        //左侧动画视图
//        let leftView: UIView = UIView(frame: CGRect(x: -toView.width / 2, y: 0, width: toView.width / 2, height: toView.height))
//        leftView.clipsToBounds = true
//        leftView.addSubview(toView)
//        //右侧动画视图
//        //使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
//        guard let rightToView = toView.snapshotView(afterScreenUpdates: true) else { return }
//        rightToView.frame = CGRect(x: -toView.width / 2, y: 0, width: toView.width, height: toView.height)
//        let rightView: UIView = UIView(frame: CGRect(x: toView.width, y: 0, width: toView.width / 2, height: toView.height))
//        rightView.clipsToBounds = true
//        rightView.addSubview(rightToView)
//        
//        //加入动画视图
//        containerView.addSubview(fromView)
//        containerView.addSubview(leftView)
//        containerView.addSubview(rightView)
//        
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionFlipFromRight) {
//            leftView.frame = CGRect(x: 0, y: 0, width: toView.width / 2, height: toView.height)
//            rightView.frame = CGRect(x: toView.width / 2, y: 0, width: toView.width / 2, height: toView.height)
//        } completion: { finished in
//            //由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
//            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
//            if (transitionContext.transitionWasCancelled) {
//                //手势取消
//            }else {
//                //手势完成
//                containerView.addSubview(toView)
//            }
//            leftView.removeFromSuperview()
//            rightView.removeFromSuperview()
//            toView.isHidden = false
//        }
//    }
//
//    // 弹框消失
//    func animationForPopView(_ transitionContext: UIViewControllerContextTransitioning) {
//        //取出转场前后视图控制器上的视图view
//        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
//        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
//        let containerView = transitionContext.containerView
//
//        //左侧动画视图
//        guard let leftFromView = fromView.snapshotView(afterScreenUpdates: false) else { return }
//        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: fromView.width / 2, height: fromView.height))
//        leftView.clipsToBounds = true
//        leftView.addSubview(leftFromView)
//        //右侧动画视图
//        guard let rightFromView = fromView.snapshotView(afterScreenUpdates: false) else { return }
//        rightFromView.frame = CGRect(x: -fromView.width / 2, y: 0, width: fromView.width, height: fromView.height)
//        let rightView = UIView(frame: CGRect(x: fromView.width / 2, y: 0, width: fromView.width / 2, height: fromView.height))
//        rightView.clipsToBounds = true
//        rightView.addSubview(rightFromView)
//
//        containerView.addSubview(toView)
//        containerView.addSubview(leftView)
//        containerView.addSubview(rightView)
//
//        fromView.isHidden = true
//        
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .transitionFlipFromRight) {
//            leftView.frame = CGRect(x: -fromView.width / 2, y: 0, width: fromView.width / 2, height: fromView.height)
//            rightView.frame = CGRect(x: fromView.width, y: 0, width: fromView.width / 2, height: fromView.height)
//        } completion: { finished in
//            fromView.isHidden = false
//            leftView.removeFromSuperview()
//            rightView.removeFromSuperview()
//            transitionContext.completeTransition(true)
//        }
//    }
//}
