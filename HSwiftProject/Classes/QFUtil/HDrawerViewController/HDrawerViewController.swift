//
//  HDrawerViewController.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

// 获取当前应用程序的关键窗口
private var KEY_WINDOW = UIApplication.shared.keyWindow

// 参考宽度
private let kRefereWidth: CGFloat = 375.0

// 适配宽度
private func AdaptW(_ floatValue: CGFloat) -> CGFloat {
    return floatValue * UIScreen.main.bounds.size.width / kRefereWidth
}

// 截图原始左边距
let kScreenshotImageOriginalLeft: CGFloat = -150.0

// 默认可见菜单宽度
let kDefaultVisibleMenuWidth: CGFloat = 300.0

// 代理协议
@objc protocol HDrawerViewControllerDelegate: AnyObject {
    @objc
    optional func menuDidAppear()
    @objc
    optional func menuDidDisappear()
}

// 抽屉控制器
class HDrawerViewController: HViewController, UIGestureRecognizerDelegate {
    
    // 拖拽手势
    private lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(paningGestureReceive(_:)))
        pan.delegate = self
        return pan
    }()
    
    // 主视图控制器中的起始触摸点
    private var startTouchPointInMainVC: CGPoint = .zero
    
    // 是否正在移动
    private var isMoving: Bool = false
    
    // 黑色遮罩视图
    private lazy var blackMaskView: UIView = {
        let blackMaskView = UIView(frame: view.bounds)
        blackMaskView.backgroundColor = .black
        return blackMaskView
    }()
    
    // 右侧黑色遮罩视图
    private lazy var rightBlackMaskView: UIControl = {
        let rightBlackMaskView = UIControl(frame: mainViewController?.view.bounds ?? .zero)
        rightBlackMaskView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        rightBlackMaskView.addTarget(self, action: #selector(rightBlackMaskViewAction), for: .touchUpInside)
        return rightBlackMaskView
    }()
    
    // 代理对象
    private lazy var delegates: NSHashTable<AnyObject> = {
        return NSHashTable.weakObjects()
    }()
    
    // 主视图控制器
    var mainViewController: UIViewController? {
        didSet {
            if let oldMainViewController = oldValue {
                oldMainViewController.removeFromParent()
                oldMainViewController.view.removeFromSuperview()
            }
            if let newMainViewController = mainViewController {
                self.addChild(newMainViewController)
                newMainViewController.view.frame = self.view.bounds
                self.view.insertSubview(newMainViewController.view, aboveSubview: blackMaskView)
                // 添加或删除手势
                canDragMenu = true
            }
        }
    }
    
    // 菜单视图控制器
    var menuViewController: UIViewController? {
        didSet {
            if let oldMenuViewController = oldValue {
                oldMenuViewController.removeFromParent()
                oldMenuViewController.view.removeFromSuperview()
            }
            if let newMenuViewController = menuViewController {
                self.addChild(newMenuViewController)
                newMenuViewController.view.frame = self.view.bounds
                self.view.insertSubview(newMenuViewController.view, belowSubview: blackMaskView)
            }
        }
    }
    
    // 可见菜单宽度
    private var visibleMenuWidth: CGFloat = 0.0
    
    /// 默认为 YES。
    var canDragMenu: Bool = true {
        didSet {
            if canDragMenu {
                mainViewController?.view.addGestureRecognizer(panGesture)
            } else {
                mainViewController?.view.removeGestureRecognizer(panGesture)
            }
        }
    }
    
    init(mainViewController: UIViewController, menuViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewController = mainViewController
        self.menuViewController = menuViewController
        self.visibleMenuWidth = AdaptW(kDefaultVisibleMenuWidth)
        self.mainViewController?.view.addGestureRecognizer(self.panGesture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override var prefersNavigationBarHidden: Bool {
        return true
    }
    
    // 配置UI
    private func configUI() {
        if let menuViewController = menuViewController,
           let mainViewController = mainViewController {
            addChild(menuViewController)
            addChild(mainViewController)
            menuViewController.view.frame = view.bounds
            mainViewController.view.frame = view.bounds
            view.addSubview(menuViewController.view)
            view.addSubview(mainViewController.view)
            view.insertSubview(blackMaskView, belowSubview: mainViewController.view)
            blackMaskView.frame = view.bounds
        }
    }
    
    deinit {
        if let menuViewController = menuViewController,
           let mainViewController = mainViewController {
            mainViewController.removeFromParent()
            menuViewController.removeFromParent()
            mainViewController.view.removeFromSuperview()
            menuViewController.view.removeFromSuperview()
        }
    }
    
    /**
     移动视图
     
     - Parameter x: x坐标
     */
    private func moveViewWithX(_ x: CGFloat) {
        guard let menuViewController = menuViewController, let mainViewController = mainViewController else { return }
        var x = min(x, visibleMenuWidth)
        x = max(x, 0)
        var frame = mainViewController.view.frame
        frame.origin.x = x
        mainViewController.view.frame = frame
        let alpha = (1.0 - x / visibleMenuWidth) / 2.0
        blackMaskView.alpha = alpha
        let aa = abs(kScreenshotImageOriginalLeft) / visibleMenuWidth
        let y = x * aa
        let rect = menuViewController.view.frame
        menuViewController.view.frame = CGRect(x: kScreenshotImageOriginalLeft + y, y: 0, width: rect.width, height: rect.height)
    }
    
    /// 显示菜单页面
    func presentMenuViewController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewWithX(self.visibleMenuWidth)
        }) { (finished) in
            self.sendMenuDidAppearNotification()
        }
    }
    
    /// 隐藏菜单页面
    func dismissMenuViewController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewWithX(0)
        }) { (finished) in
            self.sendMenuDidDisappearNotification()
        }
    }
    
    /**
     绑定代理
     
     - Parameter delegate: 代理
     */
    func bind(_ delegate: HDrawerViewControllerDelegate?) {
        guard let delegate = delegate else { return }
        if !delegates.contains(delegate) {
            delegates.add(delegate)
        }
    }
    
    /**
     解绑代理
     
     - Parameter delegate: 代理
     */
    func unbind(_ delegate: HDrawerViewControllerDelegate?) {
        guard let delegate = delegate else { return }
        if delegates.contains(delegate) {
            delegates.remove(delegate)
        }
    }
    
    /**
     发送菜单出现通知
     */
    private func sendMenuDidAppearNotification() {
        delegates.allObjects.compactMap { $0 as? HDrawerViewControllerDelegate }.forEach { $0.menuDidAppear?() }
        if let mainViewController = mainViewController, !mainViewController.view.subviews.contains(rightBlackMaskView) {
            mainViewController.view.addSubview(rightBlackMaskView)
            mainViewController.view.bringSubviewToFront(rightBlackMaskView)
        }
    }
    
    /**
     发送菜单消失通知
     */
    private func sendMenuDidDisappearNotification() {
        delegates.allObjects.compactMap { $0 as? HDrawerViewControllerDelegate }.forEach { $0.menuDidDisappear?() }
        mainViewController?.view.subviews.filter { $0 == rightBlackMaskView }.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Gesture Recognizer Methods
    @objc
    private func paningGestureReceive(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            panGestureRecognizerBegan(sender)
        } else if sender.state == .changed {
            panGestureRecognizerChanged(sender)
        } else if sender.state == .ended {
            panGestureRecognizerEnded(sender)
        } else if sender.state == .cancelled {
            panGestureRecognizerCancelled(sender)
        }
    }
    
    private func panGestureRecognizerBegan(_ sender: UIPanGestureRecognizer) {
        if let mainViewController = mainViewController {
            isMoving = true
            startTouchPointInMainVC = sender.location(in: mainViewController.view)
        }
    }
    
    private func panGestureRecognizerChanged(_ sender: UIPanGestureRecognizer) {
        let touchPointInWindow = sender.location(in: KEY_WINDOW)
        if isMoving {
            moveViewWithX(touchPointInWindow.x - startTouchPointInMainVC.x)
        }
    }
    
    private func panGestureRecognizerEnded(_ sender: UIPanGestureRecognizer) {
        let touchPointInWindow = sender.location(in: KEY_WINDOW)
        if touchPointInWindow.x - startTouchPointInMainVC.x > visibleMenuWidth / 2.0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.moveViewWithX(self.visibleMenuWidth)
            }, completion: { finished in
                self.isMoving = false
                self.sendMenuDidAppearNotification()
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.moveViewWithX(0)
            }, completion: { finished in
                self.isMoving = false
                self.sendMenuDidDisappearNotification()
            })
        }
    }
    
    private func panGestureRecognizerCancelled(_ sender: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewWithX(0)
        }, completion: { finished in
            self.isMoving = false
            self.sendMenuDidDisappearNotification()
        })
    }
    
    @objc
    private func tapGestureReceive(_ sender: UITapGestureRecognizer) {
        self.dismissMenuViewController()
    }
    
    @objc
    private func rightBlackMaskViewAction() {
        self.dismissMenuViewController()
    }
    
}
