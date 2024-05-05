//
//  HBaseController.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/22.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HBaseController: UIViewController {
    
    var orientation: UIDeviceOrientation = .unknown
        
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
        self.modalPresentationStyle = self.preferredPresentationStyle
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
        // Call this method to update the status bar status. It is best to correspond with viewWillDisappear
        self.setNeedsStatusBarAppearanceUpdate()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == .pop || type == .dismiss {
            //tupleView default tag 1213141516
            if let tupleView = self.view.viewWithTag(kTupleDefaultTag) as? HTupleView {
                tupleView.releaseTupleBlock()
            }
            //tableView default tag 1615141312
            if let tableView = self.view.viewWithTag(kTableDefaultTag) as? HTableView {
                tableView.releaseTableBlock()
            }
        }
    }

    var topBarHeight: CGFloat {
        let statusBar = self.prefersStatusBarHidden ? 0 : UIScreen.statusBarHeight
        let naviBar = self.prefersNavigationBarHidden ? 0 : UIScreen.naviBarHeight
        return statusBar + naviBar
    }

    // This function is called when the left item is pressed
    func leftNaviItemPressed() {
        self.naviBack()
    }

    // This function is called when the right item is pressed
    func rightNaviItemPressed() {
        
    }
    
    /// Navigation bar status control
    func setNeedsNavigationBarAppearanceUpdate() { }
    
    // Set modalPresentationStyle
    var preferredPresentationStyle: UIModalPresentationStyle {
        return .fullScreen
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

    // Set navigation line bar color to light gray
    var preferredNavigationLineBarColor: UIColor {
        //return UIColor(hex: 0xe5e5e5)
        return UIColor.clear
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

/// Landscape and portrait
extension HBaseController {
    /// Rotation support
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        //return [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        let orientation = UIScreen.current.orientation
//        if orientation == .landscapeLeft || orientation == .landscapeRight {
//            switch orientation {
//            case .landscapeLeft:
//                return UIInterfaceOrientation.landscapeLeft
//            case .landscapeRight:
//                return UIInterfaceOrientation.landscapeRight
//            default:
//                return UIInterfaceOrientation.landscapeRight
//            }
//        }
//        return UIInterfaceOrientation.landscapeRight
//    }
    
}

extension UIViewController {
    func transitionChildViewControllerWithIndex(_ index: Int) {
        guard index >= 0 && index < children.count else { return }
        
        for i in 0..<children.count {
            let vc = children[i]
            if vc.view.superview != nil && index != i {
                vc.view.removeFromSuperview()
            }
        }
        
        let vc = children[index]
        if vc.view.superview == nil {
            view.addSubview(vc.view)
        }
    }
    
    func pushChildViewController(_ viewController: UIViewController) {
        if children.isEmpty {
            view.addSubview(viewController.view)
            addChild(viewController)
        } else if let lastVC = children.last {
            transition(from: lastVC, to: viewController, duration: 0.25, options: .curveEaseInOut, animations: nil, completion: nil)
        }
    }
    
    func popChildViewController() {
        if children.count == 1 {
            let vc = children.last!
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        } else if children.count >= 2 {
            let vc1 = children[children.count - 1]
            let vc2 = children[children.count - 2]
            transition(from: vc1, to: vc2, duration: 0.25, options: .curveEaseInOut, animations: nil) { finished in
                if finished {
                    vc1.view.removeFromSuperview()
                    vc1.removeFromParent()
                }
            }
        }
    }
    
    func addChildViewController(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func removeChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
