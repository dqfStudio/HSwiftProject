//
//  HViewController3.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/17.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HViewController3: UIViewController {

    // Generally, call the init method or the initWithNibName method to instantiate a UIViewController, regardless of which method is called, it is calling initWithNibName
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.pvc_initialize()
    }

    // Initialized using storeBoard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.pvc_initialize()
    }

    private func pvc_initialize() {
        // modalPresentationStyle sets the default style to UIModalPresentationFullScreen
        self.modalPresentationStyle = .fullScreen
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setNeedsNavigationBarAppearanceUpdate()
        self.view.isExclusiveTouch = true
        //Disable dark mode
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if #available(iOS 11.0, *) {
            if let scrollView = self.view as? UIScrollView {
                scrollView.contentInsetAdjustmentBehavior = .never
            }
            self.view.subviews.forEach { view in
                if let scrollView = view as? UIScrollView {
                    scrollView.contentInsetAdjustmentBehavior = .never
                }
            }
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            //tupleView default tag 1213141516
            if let tupleView = self.view.viewWithTag(KTupleDefaultTag) as? HTupleView {
                tupleView.releaseTupleBlock()
            }
        }
    }

    var topBarHeight: CGFloat {
        let statusBar = self.prefersStatusBarHidden ? 0 : UIScreen.statusBarHeight
        let naviBar = self.prefersNavigationBarHidden ? 0 : UIScreen.naviBarHeight
        return statusBar + naviBar
    }

    override var title: String? {
        didSet {
            guard self.isViewLoaded else { return }
            self.navigationItem.titleItem.text = title
        }
    }

    // Navigation bar
    var navigationBar: UINavigationBar? {
        return self.navigationController?.navigationBar
    }
    
    // Navigation item
    override var navigationItem: UINavigationItem {
        let naviItem = super.navigationItem
        naviItem.leftItem.pressedBlock = {
            self.leftNaviItemPressed()
        }
        naviItem.rightItem.pressedBlock = {
            self.rightNaviItemPressed()
        }
        return naviItem
    }

    // This function is called when the left item is pressed
    func leftNaviItemPressed() {
        self.back()
    }

    // This function is called when the right item is pressed
    func rightNaviItemPressed() {

    }

    /// Return event processing
    func back() {
        if let navi = self.navigationController {
            if navi.isKind(of: HNavigationController.self), self.isKind(of: HViewController.self) {
                switch (self.appearType) {
                case .undefine, .present:
                    // dismiss with present animation
                    self.dismiss(animated: true, completion: nil)
                    return
                case .push:
                    // pop view controller with push animation
                    navi.popViewController(animated: true)
                    return
                default:
                    break
                }
            } else {
                let viewcontrollers = navi.viewControllers
                let topViewController = navi.topViewController
                if viewcontrollers.count > 1 && topViewController == self {
                    // pop view controller with push animation
                    navi.popViewController(animated: true)
                    return
                }
            }
        }
        // dismiss with present animation
        self.dismiss(animated: true, completion: nil)
    }

    /// Navigation bar status control
    func setNeedsNavigationBarAppearanceUpdate() {
        self.navigationBar?.isHidden = self.prefersNavigationBarHidden
        self.navigationBar?.backgroundColor = self.preferredNavigationBarColor
        self.navigationItem.leftItem.image = UIImage(named: "arrow_left")
    }

    // Auto adjust status bar style
    var autoAdjustStatusBarStyle: Bool {
        return true
    }

    // Hide navigation line bar
    var prefersNavigationLineBarHidden: Bool {
        return true
    }

    // Show navigation bar
    var prefersNavigationBarHidden: Bool {
        return false
    }

    // Set navigation bar color to white
    var preferredNavigationBarColor: UIColor {
        return UIColor.white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Dynamically set the status bar style based on the color of the navigation bar
        let isLighterColor = self.preferredNavigationBarColor.isLighterColor
        if self.autoAdjustStatusBarStyle, isLighterColor {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
        return .lightContent
    }

    // This function overrides the default behavior of the status bar to hide it when the device is in landscape mode
    override var prefersStatusBarHidden: Bool {
        return UIApplication.statusBarOrientation()?.isLandscape ?? false
    }

    // Controls the application's preferred home indicator auto-hiding when this view controller is shown.
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}

///// Landscape and portrait
//extension HViewController {
//    /// Rotation support
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//        //return [.portrait, .landscapeLeft, .landscapeRight]
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .portrait
//    }
//}
//
//extension UIViewController {
//    func transitionChildViewControllerWithIndex(_ index: Int) {
//        guard index >= 0 && index < children.count else { return }
//
//        for i in 0..<children.count {
//            let vc = children[i]
//            if vc.view.superview != nil && index != i {
//                vc.view.removeFromSuperview()
//            }
//        }
//
//        let vc = children[index]
//        if vc.view.superview == nil {
//            view.addSubview(vc.view)
//        }
//    }
//
//    func pushChildViewController(_ viewController: UIViewController) {
//        if children.isEmpty {
//            view.addSubview(viewController.view)
//            addChild(viewController)
//        } else if let lastVC = children.last {
//            transition(from: lastVC, to: viewController, duration: 0.25, options: .curveEaseInOut, animations: nil, completion: nil)
//        }
//    }
//
//    func popChildViewController() {
//        if children.count == 1 {
//            let vc = children.last!
//            vc.view.removeFromSuperview()
//            vc.removeFromParent()
//        } else if children.count >= 2 {
//            let vc1 = children[children.count - 1]
//            let vc2 = children[children.count - 2]
//            transition(from: vc1, to: vc2, duration: 0.25, options: .curveEaseInOut, animations: nil) { finished in
//                if finished {
//                    vc1.view.removeFromSuperview()
//                    vc1.removeFromParent()
//                }
//            }
//        }
//    }
//
//    func addChildViewController(_ viewController: UIViewController) {
//        addChild(viewController)
//        view.addSubview(viewController.view)
//        viewController.didMove(toParent: self)
//    }
//
//    func removeChildViewController(_ viewController: UIViewController) {
//        viewController.willMove(toParent: nil)
//        viewController.view.removeFromSuperview()
//        viewController.removeFromParent()
//    }
//}
//
