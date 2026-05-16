//
//  HBaseController.swift
//  HSwiftProject
//
//  Created by owner on 2024/4/22.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

/// 导航栏风格
enum HNaviShowStyle: Int {
    /// 默认
    case normal = 0
    /// 灰色
    case grey
    /// 透明背景白色返回
    case clearBgWhiteBackArrow
    /// 透明背景黑色返回
    case clearBgBlackBackArrow
}

class HBaseController: UIViewController {
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        modalPresentationStyle = preferredPresentationStyle
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        becomeFirstResponder()
        setNeedsStatusBarAppearanceUpdate()
        setupScrollViewInsets()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        guard type == .pop || type == .dismiss else { return }
        
        // Release collection view blocks
        if let collView = view.viewWithTag(kCollDefaultTag) as? HCollView {
            collView.releaseCollBlock()
        }
        
//        // Release flow view blocks
//        if let flowView = view.viewWithTag(kFlowDefaultTag) as? HFlowView {
//            flowView.releaseFlowBlock()
//        }
    }
    
    // MARK: - UI Setup
    
    private func setupBaseUI() {
        view.backgroundColor = .white
        view.isExclusiveTouch = true
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        
        // Disable dark mode
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        // Remove section header top padding for iOS 15+
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        setNeedsNavigationBarAppearanceUpdate()
    }
    
    private func setupScrollViewInsets() {
        if #available(iOS 11.0, *) {
            // Set contentInsetAdjustmentBehavior for scroll views
            func configureScrollView(_ scrollView: UIScrollView) {
                scrollView.contentInsetAdjustmentBehavior = .never
            }
            
            if let scrollView = view as? UIScrollView {
                configureScrollView(scrollView)
            }
            
            view.subviews.forEach { subview in
                if let scrollView = subview as? UIScrollView {
                    configureScrollView(scrollView)
                }
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    // MARK: - Navigation Bar
    
    /// Navigation bar status control
    func setNeedsNavigationBarAppearanceUpdate() { }
    
    // MARK: - Preferences
    
    /// Set modalPresentationStyle
    var preferredPresentationStyle: UIModalPresentationStyle {
        return .fullScreen
    }

    /// Auto adjust status bar style
    var autoAdjustStatusBarStyle: Bool {
        return true
    }

    /// Hide navigation line bar
    var prefersNavigationLineBarHidden: Bool {
        return true
    }
    
    /// Hide navigation left item
    var prefersNavigationLeftItemHidden: Bool {
        return false
    }

    /// Show navigation bar
    var prefersNavigationBarHidden: Bool {
        return false
    }

    /// Set navigation bar color to white
    var preferredNavigationBarColor: UIColor {
        return .white
    }

    /// Set navigation line bar color to light gray
    var preferredNavigationLineBarColor: UIColor {
        return UIColor(hex: 0xe5e5e5)
    }

    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Dynamically set the status bar style based on the color of the navigation bar
        let isLighterColor = preferredNavigationBarColor.isLighterColor
        if autoAdjustStatusBarStyle, isLighterColor {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
        return .lightContent
    }

    /// Hide status bar when device is in landscape mode
    override var prefersStatusBarHidden: Bool {
        return UIApplication.statusBarOrientation()?.isLandscape ?? false
    }

    /// Auto hide home indicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

}

// MARK: - Orientation
extension HBaseController {
    /// Rotation support
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Child View Controller Management
extension UIViewController {
    /// 切换到指定索引的子视图控制器
    func transitionToChildViewController(at index: Int) {
        guard index >= 0, index < children.count else {
            assertionFailure("Invalid child view controller index: \(index)")
            return
        }
        
        children.forEach { vc in
            if vc.view.superview != nil, children.firstIndex(of: vc) != index {
                vc.view.removeFromSuperview()
            }
        }
        
        let targetVC = children[index]
        if targetVC.view.superview == nil {
            view.addSubview(targetVC.view)
        }
    }
    
    /// 推入新的子视图控制器
    func pushChildViewController(_ viewController: UIViewController) {
        if children.isEmpty {
            addChild(viewController)
            view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
        } else if let lastVC = children.last {
            transition(from: lastVC, to: viewController, duration: 0.25, options: .curveEaseInOut, animations: nil) { _ in
                viewController.didMove(toParent: self)
                lastVC.removeFromParent()
            }
        }
    }
    
    /// 弹出当前子视图控制器
    func popChildViewController() {
        guard children.count >= 2 else {
            children.last.map { removeChildViewController($0) }
            return
        }
        
        let currentVC = children[children.count - 1]
        let previousVC = children[children.count - 2]
        
        transition(from: currentVC, to: previousVC, duration: 0.25, options: .curveEaseInOut, animations: nil) { _ in
            currentVC.removeFromParent()
            currentVC.view.removeFromSuperview()
        }
    }
    
    /// 添加子视图控制器
    func addChildViewController(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    /// 移除子视图控制器
    func removeChildViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
