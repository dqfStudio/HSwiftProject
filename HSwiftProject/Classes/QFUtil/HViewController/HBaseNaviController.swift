//
//  HBaseNaviController.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/5.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

class HBaseNaviController: UINavigationController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    
    /// 返回手势黑名单（弱引用，避免 pop 后仍持有页面）
    private let popGestureBlackList = NSHashTable<UIViewController>.weakObjects()

    required override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Factory
    
    /// 创建全屏模态导航控制器
    class func fullScreenModalNavi(rootVC: UIViewController) -> Self {
        let navi = self.init(rootViewController: rootVC)
        navi.modalPresentationStyle = .fullScreen
        return navi
    }

    // MARK: - Public Methods
    
    /// 添加到返回手势黑名单
    func addFullScreenPopBlackListItem(_ viewController: UIViewController) {
        popGestureBlackList.add(viewController)
    }

    /// 从返回手势黑名单移除
    func removeFromFullScreenPopBlackList(_ viewController: UIViewController) {
        popGestureBlackList.remove(viewController)
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        setupPopGesture()
    }
    
    // MARK: - Gesture Handling
    
    /// 使用系统交互式返回，并接管 delegate，避免根页面误滑、黑名单失效。
    /// 原先自定义 edge pan 在 `.changed` 里直接 naviBack，滑动过程会多次 pop，且导航控制器自己调 naviBack 会 dismiss 整栈。
    private func setupPopGesture() {
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === interactivePopGestureRecognizer else { return true }
        guard viewControllers.count > 1, transitionCoordinator == nil else { return false }
        guard let top = topViewController else { return false }
        return !popGestureBlackList.contains(top)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === interactivePopGestureRecognizer else { return false }
        return otherGestureRecognizer is UIPanGestureRecognizer
    }

    // MARK: - Navigation Stack
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
            viewController.appearType = .push
            topViewController?.vcWillDisappear(.push)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        let popVC = super.popViewController(animated: animated)
        notifyPop(popVC)
        return popVC
    }
    
    @discardableResult
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let popped = super.popToViewController(viewController, animated: animated)
        popped?.forEach { notifyPop($0) }
        return popped
    }
    
    @discardableResult
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let popped = super.popToRootViewController(animated: animated)
        popped?.forEach { notifyPop($0) }
        return popped
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        let previous = self.viewControllers
        if let oldTop = previous.last,
           oldTop !== viewControllers.last,
           viewControllers.contains(where: { $0 === oldTop }) {
            oldTop.vcWillDisappear(.push)
        }
        for (index, vc) in viewControllers.enumerated() where index > 0 && vc.appearType == .undefine {
            vc.appearType = .push
        }
        super.setViewControllers(viewControllers, animated: animated)
        let remaining = Set(viewControllers.map { ObjectIdentifier($0) })
        previous.filter { !remaining.contains(ObjectIdentifier($0)) }.forEach { notifyPop($0) }
    }
    
    /// 交互手势取消时不触发 pop 清理。`animate(alongsideTransition:)` 返回 false 时必须立刻回调，否则 block 永不释放。
    private func notifyPop(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.invokeAfterTransition(on: transitionCoordinator) {
            viewController.notifyVCWillDisappear(.pop)
        }
    }

    // MARK: - Status Bar / Home Indicator
    
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        topViewController
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        topViewController
    }
}

// MARK: - Orientation Handling
extension HBaseNaviController {
    override var shouldAutorotate: Bool {
        topViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}
