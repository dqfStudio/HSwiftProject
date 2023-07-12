//
//  HUserLiveVC.swift
//  HSwiftProject
//
//  Created by Wind on 17/11/2021.
//  Copyright © 2021 wind. All rights reserved.
//

import UIKit

enum HLiveStatus: Int {
    case loading = 0
    case liveing = 1
}

class HUserLiveVC : HTupleController {
    
    lazy var inputField: HTextField = {
        let frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 40)
        let inputField = HTextField(frame: frame)
        inputField.backgroundColor = .white
        inputField.placeholderFont = .systemFont(ofSize: 14.0)
        inputField.placeholder = "请输入内容..."
        
        inputField.leftWidth = 10
        inputField.leftLabel.text = ""
        
        // 去掉键盘上的toolBar
        inputField.inputAccessoryView = UIView()
        inputField.reloadInputViews()
        
        inputField.rightWidth = 60
        inputField.rightLabel.text = "完成"
        inputField.rightLabel.textAlignment = .center
        inputField.rightLabel.font = .systemFont(ofSize: 17.0)
        
        inputField.rightLabel.addSingleTapGesture(withBlock: { sender in
            // Force hide keyboard
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        })
        return inputField
    }()
    
    var liveStatus: HLiveStatus = .loading {
        didSet {
            if liveStatus != oldValue {
                self.tupleView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topExtendedLayout = false
        self.tupleView.isPagingEnabled = true
        self.tupleView.delegate = self
        
        //添加键盘
        self.addKeyboardObserver()
        self.hideKeyboardWhenTapBackground()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboardNotifyAction), name: NSNotification.Name(KShowKeyboardNotify), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tupleView.contentSize = CGSize(width: 0, height: self.tupleView.height * 3)
        self.tupleView.contentOffset = CGPoint(x: 0, y: self.tupleView.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 监测当前设备是否处于录屏状态
        let sc = UIScreen.main
        if #available(iOS 11.0, *) {
            if sc.isCaptured {
                self.recordingScreen()
            }
        }
        if #available(iOS 11.0, *) {
            // 检测到当前设备录屏状态发生变化
            NotificationCenter.default.addObserver(self, selector: #selector(recordingScreen), name: UIScreen.capturedDidChangeNotification, object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 截屏检测
        NotificationCenter.default.addObserver(self, selector: #selector(screenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }

    override func vcWillDisappear(_ type: HVCDisappearType) {
        if type == HVCDisappearType.pop || type == HVCDisappearType.dismiss {
            self.tupleView.releaseTupleBlock()
            //释放相关内容
            HLRDManager.defaults.clear()
            self.removeKeyboardObserver()
            if #available(iOS 11.0, *) {
                NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
            }
            NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(KShowKeyboardNotify), object: nil)
            //通知释放跟直播相关的tupleView
            NotificationCenter.default.post(name: NSNotification.Name(KLiveRoomReleaseTupleKey), object: nil)
        }
    }

    // 录屏
    @objc
    private func recordingScreen() {
        self.dismiss(animated: true, completion: nil)
        UIAlertController.showAlert(withTitle: "安全提醒", message: "请不要录屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
        //UIAlertView(title: "安全提醒", message: "请不要录屏分享给他人以保障账户安全。", delegate: nil, cancelButtonTitle: "我知道了").show()
    }

    // 截屏
    @objc
    private func screenshot() {
        //UIAlertController.showAlert(withTitle: "安全提醒", message: "请不要截屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
        UIAlertView(title: "安全提醒", message: "请不要截屏分享给他人以保障账户安全。", delegate: nil, cancelButtonTitle: "我知道了").show()
    }

    @objc
    func showKeyboardNotifyAction() {
        UIApplication.getKeyWindow?.addSubview(self.inputField)
        self.inputField.becomeFirstResponder()
    }

    override var prefersNavigationBarHidden: Bool {
        return true
    }

    override func keyboardWillShowWithRect(_ keyboardRect: CGRect, animationDuration duration: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            let frame = CGRect(x: 0, y: keyboardRect.origin.y - 40, width: UIScreen.width, height: 40)
            self.inputField.frame = frame
        }
    }

    override func keyboardWillHideWithRect(_ keyboardRect: CGRect, animationDuration duration: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            let frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 40)
            self.inputField.frame = frame
        } completion: { finished in
            //释放textField
            self.inputField.removeFromSuperview()
            self.inputField.text = ""
        }
    }

    func tupleScrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 2 * self.view.height {//向上滚动
            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.height), animated: false)
            self.tupleScrollViewDidScrollToTop(scrollView)
        }else if offsetY <= 0 {//向下滚动
            scrollView.setContentOffset(CGPoint(x: 0, y: self.view.height), animated: false)
            self.tupleScrollViewDidScrollToBottom(scrollView)
        }
    }

    func numberOfItemsInSection(_ section: Any) -> Any {
        return 3
    }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> Any {
        return self.tupleView.size
    }

    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        
        let itemBlock = itemBlock as! HTupleItem
        
        switch indexPath.row {
        case 0:
            _ = itemBlock(nil, HUserLiveBgCell.self, nil, true)
            break
        case 2:
            _ = itemBlock(nil, HUserLiveBgCell.self, nil, true)
            break
        case 1:
            if self.liveStatus == .loading {
                let cell = itemBlock(nil, HUserLiveBgCell.self, nil, true) as! HUserLiveBgCell
                // 禁止滚动
                self.tupleView.isScrollEnabled = false
                // 开始旋转
                cell.activityIndicator.startAnimating()
                //可反复加载内容的直播功能
                self.reloadLiveBroadcast {
                    DispatchQueue.main.async {
                        // 解除禁止滚动
                        self.tupleView.isScrollEnabled = true
                        // 停止旋转
                        cell.activityIndicator.stopAnimating()
                        // 更改直播状态
                        self.liveStatus = .liveing
                    }
                }
            }else if self.liveStatus == .liveing {
                _ = itemBlock(nil, HUserLiveCell.self, nil, true)
            }
            break

        default:
            break
        }

    }

    //向上滚动
    func tupleScrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        // 更改直播状态
        self.liveStatus = .loading
    }
    //向下滚动
    func tupleScrollViewDidScrollToBottom(_ scrollView: UIScrollView) {
        // 更改直播状态
        self.liveStatus = .loading
    }
    //可反复加载内容的直播功能
    func reloadLiveBroadcast(_ completion: (() -> Void)?) {
        let deadline = DispatchTime.now() + 3.0
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            completion?()
        }
    }
}
