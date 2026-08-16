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
        setNeedsStatusBarAppearanceUpdate()
        setupScrollViewInsets()
        updateSystemNavigationBarVisibility(animated: animated, isAppearing: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNeedsStatusBarAppearanceUpdate()
        updateSystemNavigationBarVisibility(animated: animated, isAppearing: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isBeingDismissed else { return }
        if let navi = navigationController, navi.topViewController === self {
            navi.viewControllers.forEach { $0.notifyVCWillDisappear(.dismiss) }
        } else if navigationController == nil {
            notifyVCWillDisappear(.dismiss)
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.appearType = .present
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        let targets = disappearTargetsForDismiss()
        super.dismiss(animated: flag) {
            completion?()
            targets.forEach { $0.notifyVCWillDisappear(.dismiss) }
        }
    }
    
    /// 只通知真正被关掉的页面。presenter 调 dismiss 时不能把自身当消失页清理。
    private func disappearTargetsForDismiss() -> [UIViewController] {
        if let presented = presentedViewController {
            if let nav = presented as? UINavigationController {
                return nav.viewControllers
            }
            if let nav = presented.navigationController {
                return nav.viewControllers
            }
            return [presented]
        }
        if presentingViewController != nil {
            if let nav = navigationController {
                return nav.viewControllers
            }
            return [self]
        }
        return []
    }
    
    private func updateSystemNavigationBarVisibility(animated: Bool, isAppearing: Bool) {
        guard managesSystemNavigationBar else { return }
        if isAppearing {
            navigationController?.setNavigationBarHidden(prefersSystemNavigationBarHidden, animated: animated)
            return
        }
        guard let toVC = transitionCoordinator?.viewController(forKey: .to) else { return }
        if let toBase = toVC as? HBaseController, toBase.managesSystemNavigationBar {
            navigationController?.setNavigationBarHidden(toBase.prefersSystemNavigationBarHidden, animated: animated)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        guard type == .pop || type == .dismiss else { return }
        releaseTaggedCollView(in: view)
    }
    
    // MARK: - UI Setup
    
    private func setupBaseUI() {
        view.backgroundColor = .white
        view.isExclusiveTouch = true
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        setNeedsNavigationBarAppearanceUpdate()
    }
    
    private func setupScrollViewInsets() {
        configureScrollViews(in: view)
    }
    
    private func configureScrollViews(in root: UIView) {
        if let scrollView = root as? UIScrollView {
            scrollView.contentInsetAdjustmentBehavior = .never
            if #available(iOS 15.0, *), let tableView = scrollView as? UITableView {
                tableView.sectionHeaderTopPadding = 0
            }
        }
        for subview in root.subviews {
            if subview is UITableViewCell || subview is UICollectionViewCell {
                continue
            }
            configureScrollViews(in: subview)
        }
    }
    
    private func releaseTaggedCollView(in root: UIView) {
        if let collView = root as? HCollView, collView.tag == kCollDefaultTag {
            collView.releaseCollBlock()
        }
        root.subviews.forEach { releaseTaggedCollView(in: $0) }
    }
    
    // MARK: - Navigation Bar
    
    /// Navigation bar status control
    func setNeedsNavigationBarAppearanceUpdate() { }
    
    /// 是否由本页接管系统导航栏显隐。Alert 等非导航页应保持 false。
    var managesSystemNavigationBar: Bool {
        false
    }
    
    /// 是否隐藏系统导航栏。自定义导航栏页面应返回 true。
    var prefersSystemNavigationBarHidden: Bool {
        false
    }
    
    // MARK: - Preferences
    
    /// Set modalPresentationStyle
    var preferredPresentationStyle: UIModalPresentationStyle {
        .fullScreen
    }

    /// Auto adjust status bar style
    var autoAdjustStatusBarStyle: Bool {
        true
    }

    /// Hide navigation line bar
    var prefersNavigationLineBarHidden: Bool {
        true
    }
    
    /// Hide navigation left item
    var prefersNavigationLeftItemHidden: Bool {
        false
    }

    /// Show navigation bar
    var prefersNavigationBarHidden: Bool {
        false
    }

    /// Set navigation bar color to white
    var preferredNavigationBarColor: UIColor {
        .white
    }

    /// Set navigation line bar color to light gray
    var preferredNavigationLineBarColor: UIColor {
        UIColor(hex: 0xe5e5e5)
    }

    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let isLighterColor = preferredNavigationBarColor.isLighterColor
        if autoAdjustStatusBarStyle, isLighterColor {
            if #available(iOS 13.0, *) {
                return .darkContent
            }
            return .default
        }
        return .lightContent
    }

    /// Hide status bar when device is in landscape mode
    override var prefersStatusBarHidden: Bool {
        UIApplication.statusBarOrientation()?.isLandscape ?? false
    }

    /// Auto hide home indicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }

}

// MARK: - Navigation Appearance

extension HBaseController {
    
    /// 导航栏标题色与背景色
    func navigationBarColors(for style: HNaviShowStyle) -> (titleColor: UIColor, backgroundColor: UIColor) {
        switch style {
        case .grey:
            return (.black, UIColor(hex: "#F8F9FE"))
        case .clearBgWhiteBackArrow:
            return (.white, .clear)
        case .clearBgBlackBackArrow:
            return (.black, .clear)
        case .normal:
            return (.black, .white)
        }
    }
    
    /// 导航栏标题属性
    func navigationTitleAttributes(with color: UIColor) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 1
        return [
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    /// 将风格应用到 UINavigationBar，并返回对应颜色
    @discardableResult
    func applyNavigationBarAppearance(_ navigationBar: UINavigationBar, style: HNaviShowStyle) -> (titleColor: UIColor, backgroundColor: UIColor) {
        let colors = navigationBarColors(for: style)
        let attributes = navigationTitleAttributes(with: colors.titleColor)
        let isClear = colors.backgroundColor == .clear
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            if isClear {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithOpaqueBackground()
            }
            appearance.titleTextAttributes = attributes
            appearance.backgroundColor = colors.backgroundColor
            appearance.shadowColor = .clear
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        } else {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        
        navigationBar.titleTextAttributes = attributes
        navigationBar.backgroundColor = colors.backgroundColor
        navigationBar.isTranslucent = isClear
        return colors
    }
    
    /// 按风格配置返回按钮图标与点击（已有 pressed 时不覆盖）
    func configureBackItem(_ item: HNavigationItem, style: HNaviShowStyle) {
        let titleColor = navigationBarColors(for: style).titleColor
        let named = UIImage(named: "hvc_back_icon")
        switch style {
        case .clearBgWhiteBackArrow, .clearBgBlackBackArrow:
            item.image = named?.withRenderingMode(.alwaysTemplate)
            item.tintColor = titleColor
        default:
            item.image = named
        }
        item.textColor = titleColor
        if item.pressed == nil {
            item.pressed = { [weak self] in
                self?.naviBack()
            }
        }
    }
}

// MARK: - Orientation
extension HBaseController {
    /// Rotation support
    override var shouldAutorotate: Bool {
        false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        .portrait
    }
}

// MARK: - Child View Controller Management
extension UIViewController {
    
    /// 切换到指定索引的子视图控制器（仅切换可见性，不改变父子关系）
    func transitionToChildViewController(at index: Int) {
        guard children.indices.contains(index) else {
            assertionFailure("Invalid child view controller index: \(index)")
            return
        }
        
        let targetVC = children[index]
        for (idx, vc) in children.enumerated() where idx != index && vc.view.superview != nil {
            vc.view.removeFromSuperview()
        }
        
        if targetVC.view.superview == nil {
            embedChildView(targetVC.view)
        }
    }
    
    /// 推入新的子视图控制器（保留栈，可供 pop）
    func pushChildViewController(_ viewController: UIViewController) {
        guard viewController.parent == nil else { return }
        
        if let lastVC = children.last {
            addChild(viewController)
            viewController.view.frame = view.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            transition(from: lastVC, to: viewController, duration: 0.25, options: .transitionCrossDissolve, animations: nil) { [weak self] finished in
                guard let self = self else { return }
                if finished {
                    viewController.didMove(toParent: self)
                } else {
                    viewController.willMove(toParent: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }
            }
        } else {
            addChildViewController(viewController)
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
        previousVC.view.frame = view.bounds
        previousVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        currentVC.willMove(toParent: nil)
        transition(from: currentVC, to: previousVC, duration: 0.25, options: .transitionCrossDissolve, animations: nil) { finished in
            guard finished else {
                currentVC.didMove(toParent: currentVC.parent)
                return
            }
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
    }
    
    /// 添加子视图控制器
    func addChildViewController(_ viewController: UIViewController) {
        guard viewController.parent !== self else { return }
        addChild(viewController)
        embedChildView(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    /// 移除子视图控制器
    func removeChildViewController(_ viewController: UIViewController) {
        guard viewController.parent === self else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    fileprivate func embedChildView(_ childView: UIView) {
        childView.frame = view.bounds
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(childView)
    }
}
