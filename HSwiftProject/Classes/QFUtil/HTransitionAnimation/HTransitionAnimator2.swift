//
//  HTransitionAnimator2.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/18.
//  Copyright © 2024 wind. All rights reserved.
//

//import UIKit
//
//enum AnimateType {
//    case none       //无动画
//    case vertical   //竖向
//    case horizontal //横向
//    case fade       //渐变
//}
//
//class XTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
////    
////}
////
////class HPresentAnimation: HTransitionAnimation, UIViewControllerTransitioningDelegate {
//
////    //转场视图尺寸大小
////    @objc var contentSize: CGSize = CGSize.zero
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
////            presentedView.alpha = 0.0
////            presentedView.frame = CGRect(x: 0, y: -self.contentSize.height, width: self.contentSize.width, height: self.contentSize.height)
////            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
////                presentedView.alpha = 1.0
////                presentedView.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
////            } completion: { finished in
////                if finished {
////                    transitionContext.completeTransition(true)
////                }
////            }
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
////            presentedView.alpha = 0.0
////            let screenHeight = UIScreen.main.bounds.height
////            presentedView.frame = CGRect(x: 0, y: screenHeight, width: self.contentSize.width, height: self.contentSize.height)
////            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
////                presentedView.alpha = 1.0
////                presentedView.frame = CGRect(x: 0, y: screenHeight - self.contentSize.height, width: self.contentSize.width, height: self.contentSize.height)
////            } completion: { finished in
////                if finished {
////                    transitionContext.completeTransition(true)
////                }
////            }
//            presentedView.alpha = 0.0
////            let screenHeight = UIScreen.main.bounds.height
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
////            UIView.animate(withDuration: duration) {
////                presentedView.transform = CGAffineTransform(translationX: 0, y: -self.contentSize.height)
////            } completion: { finished in
////                if finished {
////                    presentedView.removeFromSuperview()
////                    transitionContext.completeTransition(true)
////                }
////            }
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
////            UIView.animate(withDuration: duration) {
////                presentedView.transform = CGAffineTransform(translationX: 0, y: self.contentSize.height)
////            } completion: { finished in
////                if finished {
////                    presentedView.removeFromSuperview()
////                    transitionContext.completeTransition(true)
////                }
////            }
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
//}
//
////extension HPresentAnimation {
////    // UIViewControllerTransitioningDelegate
////    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
////        let presentationVC = HPresentationController(presentedViewController: presented, presenting: presenting)
////        presentationVC.presentType = self.presentType
//////        presentationVC.contentSize = self.contentSize
////        presentationVC.isShadowDismiss = self.isShadowDismiss
////        presentationVC.shadowColor = self.shadowColor
////        self.presentationVC = presentationVC
////        return presentationVC
////    }
////}
//
//class HPresentationController: UIPresentationController {
//    //蒙层
////    lazy var contentCoverView: UIView = {
////        let contentCoverView = UIView(frame: self.containerView?.bounds ?? CGRect.zero)
////        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
////        contentCoverView.addGestureRecognizer(tap)
////        return contentCoverView
////    }()
//    
//    //蒙层颜色
//    var shadowColor: UIColor = UIColor(white: 0.1, alpha: 0.2) {
//        didSet {
////            self.contentCoverView.backgroundColor = shadowColor
//            self.containerView?.backgroundColor = shadowColor
//        }
//    }
//    
//    //弹出框类型
//    @objc var presentType: HTransitionStyle = .alert
//    
////    //内容层大小
////    @objc var contentSize: CGSize = CGSize.zero
//    
//    ///点击阴影是否关闭页面
//    @objc var isShadowDismiss: Bool = false
//
//    // 重写UIPresentationController的方法
//    //重写构造方法
//    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
//        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom自定义
//        presentedViewController.modalPresentationStyle = .custom
//    }
//
//    // 呈现过渡即将开始的时候被调用的
//    // 可以在此方法创建和设置自定义动画所需的view
//    override func presentationTransitionWillBegin() {
//        //将蒙版插入最下面
////        self.containerView?.insertSubview(self.contentCoverView, at: 0)
//        // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
//        let transitionCoordinator = self.presentingViewController.transitionCoordinator
//       // 动画期间，背景View的动画方式
////        self.contentCoverView.alpha = 0.0
//        self.containerView?.alpha = 0.0
//        transitionCoordinator?.animateAlongsideTransition(in: nil, animation: { context in
////            self.contentCoverView.alpha = 1.0
//            self.containerView?.alpha = 1.0
//        }, completion: nil)
//    }
//
//    // 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
//    override func presentationTransitionDidEnd(_ completed: Bool) {
//        //NSLog(@"过渡结束")
//    }
//
//    // 消失过渡即将开始的时候被调用的
//    override func dismissalTransitionWillBegin() {
////        self.contentCoverView.alpha = 0.0
//        self.containerView?.alpha = 0.0
//    }
//
//    // 消失过渡完成之后调用，此时应该将视图移除
//    override func dismissalTransitionDidEnd(_ completed: Bool) {
//        if completed {
//            self.presentedView?.removeFromSuperview()
////            //去掉蒙版
////            self.contentCoverView.removeFromSuperview()
//        }
//    }
//
//    //设置要显示的view的frame(布局）
////    override func containerViewWillLayoutSubviews() {
////        super.containerViewWillLayoutSubviews()
////        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
////        self.contentCoverView.frame = self.containerView?.bounds ?? CGRect.zero
////    }
//
////    override var frameOfPresentedViewInContainerView: CGRect {
////        var makeRect = CGRect.zero
////        if let containerView = self.containerView {
////            if self.presentType == .drop {
////                if self.contentSize.equalTo(CGSize.zero) {
////                    self.contentSize = containerView.size
////                }
////                if self.contentSize.width == 0, self.contentSize.height > 0 {
////                    self.contentSize = CGSize(width: containerView.bounds.width, height: self.contentSize.height)
////                }
////                makeRect = CGRect(x: containerView.bounds.size.width - self.contentSize.width,
////                                        y: 0,
////                                        width: self.contentSize.width,
////                                        height: self.contentSize.height)
////
////            } else if self.presentType == .alert {
////                makeRect = CGRect(x: containerView.center.x - self.contentSize.width * 0.5,
////                                    y: containerView.center.y - self.contentSize.height * 0.5,
////                                    width: self.contentSize.width,
////                                    height: self.contentSize.height)
////
////            } else if self.presentType == .sheet {
////                if self.contentSize.equalTo(CGSize.zero) {
////                    self.contentSize = containerView.size
////                }
////                if self.contentSize.width == 0, self.contentSize.height > 0 {
////                    self.contentSize = CGSize(width: containerView.bounds.width, height: self.contentSize.height)
////                }
////                makeRect = CGRect(x: containerView.bounds.size.width - self.contentSize.width,
////                                        y: containerView.bounds.size.height - self.contentSize.height,
////                                        width: self.contentSize.width,
////                                        height: self.contentSize.height)
////            }
////        }
////        return makeRect
////    }
////    override var frameOfPresentedViewInContainerView: CGRect {
////        var makeRect = CGRect.zero
////        if let containerView = self.containerView, let presentedView = self.presentedView {
////            if self.presentType == .drop {
//////                if self.contentSize.equalTo(CGSize.zero) {
//////                    self.contentSize = containerView.size
//////                }
//////                if self.contentSize.width == 0, self.contentSize.height > 0 {
//////                    self.contentSize = CGSize(width: containerView.bounds.width, height: self.contentSize.height)
//////                }
////                makeRect = CGRect(x: containerView.bounds.size.width - presentedView.width,
////                                        y: 0,
////                                        width: presentedView.width,
////                                        height: presentedView.height)
////
////            } else if self.presentType == .alert {
//////                makeRect = CGRect(x: containerView.center.x - self.contentSize.width * 0.5,
//////                                    y: containerView.center.y - self.contentSize.height * 0.5,
//////                                    width: self.contentSize.width,
//////                                    height: self.contentSize.height)
////                makeRect = CGRect(x: containerView.center.x - presentedView.width * 0.5,
////                                    y: 100,
////                                    width: presentedView.width,
////                                    height: 300)
////
////            } else if self.presentType == .sheet {
//////                if self.contentSize.equalTo(CGSize.zero) {
//////                    self.contentSize = containerView.size
//////                }
//////                if self.contentSize.width == 0, self.contentSize.height > 0 {
//////                    self.contentSize = CGSize(width: containerView.bounds.width, height: self.contentSize.height)
//////                }
//////                makeRect = CGRect(x: containerView.bounds.size.width - self.contentSize.width,
//////                                        y: containerView.bounds.size.height - self.contentSize.height,
//////                                        width: self.contentSize.width,
//////                                        height: self.contentSize.height)
////                makeRect = CGRect(x: containerView.bounds.size.width - presentedView.width,
////                                        y: containerView.bounds.size.height - presentedView.height,
////                                        width: presentedView.width,
////                                        height: presentedView.height)
////            }
////        }
////        return makeRect
//////        return CGRect.zero
////    }
//
//    override var shouldPresentInFullscreen: Bool {
//        return false
//    }
//
//    override var shouldRemovePresentersView: Bool {
//        return false
//    }
//
////    @objc
////    private func dismissAction() {
////        if self.isShadowDismiss {
////            self.presentedViewController.dismiss(animated: true, completion: nil)
////        }
////    }
//
//}
//
////// MARK: UIViewControllerTransitioningDelegate
////extension FCBaseAlertVC: UIViewControllerTransitioningDelegate {
////    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////        return XTransitionAnimator(transitionType: .present, animateType: .fade, duration: 0.3)
////        return HPresentAnimation()
////    }
////    
////    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//////        return XTransitionAnimator(transitionType: .dismiss, animateType: .fade, duration: 0.3)
////        return HPresentAnimation()
////    }
////    
////    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
////        super.init(nibName: nil, bundle: nil)
////        self.modalPresentationStyle = .custom
////        self.transitioningDelegate = self
////    }
////    
////    required init?(coder: NSCoder) {
////        super.init(coder: coder)
////        self.modalPresentationStyle = .custom
////        self.transitioningDelegate = self
////    }
////    
//////    override func viewDidLoad() {
//////        super.viewDidLoad()
//////        self.view.backgroundColor = UIColor.alertBg.withAlphaComponent(0.6)
//////        
//////        // 监听登录失败或主动退出登录
//////        NotificationCenter.default.rx
//////            .notification(Notification.Name.login)
//////            .take(until: rx.deallocated)
//////            .subscribe(onNext: { [weak self] notifi in
//////                self?.loginCompleted?()
//////            }).disposed(by: disposeBag)
//////    }
////}
//
////func presentController(_ viewController: UIViewController, modalStyle: UIModalPresentationStyle = .custom, completion: HTransitionCompletion?) {
////    let animation = HPresentAnimation()
////    animation.presentType = viewController.presentType
//////        animation.contentSize = viewController.containerSize
////    animation.transitionDuration = viewController.animationDuration
////    animation.shadowColor = viewController.shadowColor
////    animation.isShadowDismiss = viewController.isShadowDismiss
////    animation.transitionCompletion = completion
////    self.presentAnimation = animation
////    viewController.modalPresentationStyle = modalStyle //设置目标vc的动画为自定义
////    viewController.transitioningDelegate = animation //设置动画管理代理类
////    self.present(viewController, animated: true, completion: nil)
////}
