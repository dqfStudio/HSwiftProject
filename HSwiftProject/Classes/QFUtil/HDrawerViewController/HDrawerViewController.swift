//
//  HDrawerViewController.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var KEY_WINDOW = UIApplication.shared.keyWindow

private let kRefereWidth: CGFloat = 375.0

private func AdaptW(_ floatValue: CGFloat) -> CGFloat {
    return floatValue * UIScreen.main.bounds.size.width / kRefereWidth
}

let kScreenshotImageOriginalLeft: CGFloat = -150.0
let kDefaultVisibleMenuWidth: CGFloat = 300.0

protocol HDrawerViewControllerDelegate: AnyObject {
    func menuDidAppear()
    func menuDidDisappear()
}

class HDrawerViewController: HViewController, UIGestureRecognizerDelegate {
    
    private lazy var pan: UIPanGestureRecognizer = {
        let _pan = UIPanGestureRecognizer(target: self, action: #selector(paningGestureReceive(_:)))
        _pan.delegate = self
        return _pan
    }()
    
    private var startTouchPointInMainVC: CGPoint!
    private var moving: Bool!
    
    private lazy var blackMaskView: UIView = {
        let _blackMaskView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        _blackMaskView.backgroundColor = .black
        return _blackMaskView
    }()
    
    private lazy var rightblackMaskView: UIControl = {
        let _rightblackMaskView = UIControl(frame: CGRect(x: 0, y: 0, width: mainViewController.view.bounds.width, height: mainViewController.view.bounds.height))
        _rightblackMaskView.backgroundColor = .clear
        _rightblackMaskView.addTarget(self, action: #selector(rightblackMaskViewAction), for: .touchUpInside)
        return _rightblackMaskView
    }()
    
    private lazy var delegates: NSHashTable<AnyObject> = {
        return NSHashTable.weakObjects()
    }()
    
    private var _mainViewController: UIViewController?
    var mainViewController: UIViewController {
        get {
            return _mainViewController!
        }
        set {
            if let oldMainViewController = _mainViewController {
                oldMainViewController.removeFromParent()
                oldMainViewController.view.removeFromSuperview()
            }
            _mainViewController = newValue
            
            if let newMainViewController = _mainViewController {
                self.addChild(newMainViewController)
                newMainViewController.view.frame = self.view.bounds
                self.view.insertSubview(newMainViewController.view, aboveSubview: blackMaskView)
                // Add or remove gesture.
                canDragMenu = _canDragMenu
            }
        }
    }
    
    private var _menuViewController: UIViewController?
    var menuViewController: UIViewController {
        get {
            return _menuViewController!
        }
        set {
            if let oldMenuViewController = _menuViewController {
                oldMenuViewController.removeFromParent()
                oldMenuViewController.view.removeFromSuperview()
            }
            _menuViewController = newValue
            
            if let newMenuViewController = _menuViewController {
                self.addChild(newMenuViewController)
                newMenuViewController.view.frame = self.view.bounds
                self.view.insertSubview(newMenuViewController.view, belowSubview: blackMaskView)
            }
        }
    }
    
    var visibleMenuWidth: CGFloat!
    ///< Default is YES.
    private var _canDragMenu: Bool = true
    var canDragMenu: Bool {
        get {
            return _canDragMenu
        }
        set {
            _canDragMenu = newValue
            if _canDragMenu {
                mainViewController.view.addGestureRecognizer(pan)
            } else {
                mainViewController.view.removeGestureRecognizer(pan)
            }
        }
    }
    
    init(mainViewController: UIViewController, menuViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.mainViewController = mainViewController
        self.menuViewController = menuViewController
        self.visibleMenuWidth = AdaptW(kDefaultVisibleMenuWidth)
        self.mainViewController.view.addGestureRecognizer(self.pan)
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
    
    private func configUI() {
        addChild(menuViewController)
        addChild(mainViewController)
        menuViewController.view.frame = view.bounds
        mainViewController.view.frame = view.bounds
        view.addSubview(menuViewController.view)
        view.addSubview(mainViewController.view)
        view.insertSubview(blackMaskView, belowSubview: mainViewController.view)
        blackMaskView.frame = view.bounds
    }
    
    deinit {
        mainViewController.removeFromParent()
        menuViewController.removeFromParent()
        mainViewController.view.removeFromSuperview()
        menuViewController.view.removeFromSuperview()
    }
    
    private func moveViewWithX(_ x: CGFloat) {
        var x = x
        x = min(x, visibleMenuWidth)
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
    
    ///< Show menu page.
    func presentMenuViewController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewWithX(self.visibleMenuWidth)
        }) { (finished) in
            self.sendMenuDidAppearNotification()
        }
    }
    
    ///< Hide menu page.
    func dismissMenuViewController() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewWithX(0)
        }) { (finished) in
            self.sendMenuDidDisappearNotification()
        }
    }
    
    func bind(_ delegate: HDrawerViewControllerDelegate?) {
        if delegate == nil {
            return
        }
        if !delegates.contains(delegate) {
            delegates.add(delegate)
        }
    }

    
    func unbind(_ delegate: HDrawerViewControllerDelegate?) {
        if delegate == nil {
            return
        }
        if delegates.contains(delegate) {
            delegates.remove(delegate)
        }
    }
    
    private func sendMenuDidAppearNotification() {
        for delegate in delegates.allObjects {
            if let delegate = delegate as? HDrawerViewControllerDelegate {
                delegate.menuDidAppear()
            }
        }
        if !mainViewController.view.subviews.contains(rightblackMaskView) {
            mainViewController.view.addSubview(rightblackMaskView)
            mainViewController.view.bringSubviewToFront(rightblackMaskView)
        }
    }
    
    private func sendMenuDidDisappearNotification() {
        for delegate in delegates.allObjects {
            if let delegate = delegate as? HDrawerViewControllerDelegate {
                delegate.menuDidDisappear()
            }
        }
        if mainViewController.view.subviews.contains(rightblackMaskView) {
            rightblackMaskView.removeFromSuperview()
        }
    }
    
    // MARK: - Gesture Recognizer Methods
    @objc
    private func paningGestureReceive(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            _panGestureRecognizerBegan(sender)
        } else if sender.state == .changed {
            _panGestureRecognizerChanged(sender)
        } else if sender.state == .ended {
            _panGestureRecognizerEnded(sender)
        } else if sender.state == .cancelled {
            _panGestureRecognizerCancelled(sender)
        }
    }

    private func _panGestureRecognizerBegan(_ sender: UIPanGestureRecognizer) {
        moving = true
        startTouchPointInMainVC = sender.location(in: mainViewController.view)
    }

    private func _panGestureRecognizerChanged(_ sender: UIPanGestureRecognizer) {
        let touchPointInWindow = sender.location(in: KEY_WINDOW)
        if moving {
            moveViewWithX(touchPointInWindow.x - startTouchPointInMainVC.x)
        }
    }

    private func _panGestureRecognizerEnded(_ sender: UIPanGestureRecognizer) {
        let touchPointInWindow = sender.location(in: KEY_WINDOW)
        if touchPointInWindow.x - startTouchPointInMainVC.x > visibleMenuWidth / 2.0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.moveViewWithX(self.visibleMenuWidth)
            }, completion: { finished in
                self.moving = false
                self.sendMenuDidAppearNotification()
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.moveViewWithX(0)
            }, completion: { finished in
                self.moving = false
                self.sendMenuDidDisappearNotification()
            })
        }
    }

    private func _panGestureRecognizerCancelled(_ sender: UIPanGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewWithX(0)
        }, completion: { finished in
            self.moving = false
            self.sendMenuDidDisappearNotification()
        })
    }

    @objc
    func tapGestureReceive(_ sender: UITapGestureRecognizer) {
        dismissMenuViewController()
    }
    
    @objc
    func rightblackMaskViewAction() {
        self.dismissMenuViewController()
    }
    
}

