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
    
    private var _inputField: HTextField!
    var inputField: HTextField {
        if _inputField == nil {
            let frame = CGRectMake(0, UIScreen.height, UIScreen.width, 40);
            _inputField = HTextField.init(frame: frame)
            _inputField.backgroundColor = UIColor.white
            _inputField.placeholderFont = UIFont.systemFont(ofSize: 14)
            _inputField.placeholder = "请输入内容..."
            
            _inputField.leftWidth = 10;
            _inputField.leftLabel.text = ""
            
            // 去掉键盘上的toolBar
            _inputField.inputAccessoryView = UIView.init(frame: CGRectZero)
            _inputField.reloadInputViews()
            
            _inputField.rightWidth = 60
            _inputField.rightLabel.text = "完成"
            _inputField.rightLabel.textAlignment = .center
            _inputField.rightLabel.font = UIFont.systemFont(ofSize: 17)
            
            _inputField.rightLabel.addSingleTapGestureWithBlock { sender in
                let gesture = sender as! UIGestureRecognizer
                let _ = gesture.view?.superview?.resignFirstResponder()
            }
        }
        return _inputField!
    }
    
    private func inputFieldFiniishedAction(_ sender: UILabel) {
        let _ = sender.superview?.resignFirstResponder()
    }
    
    private var _liveStatus: HLiveStatus = .loading
    var liveStatus: HLiveStatus {
        get {
            return _liveStatus
        }
        set {
            if (_liveStatus != newValue) {
                _liveStatus = newValue
                self.tupleView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white;
        self.topExtendedLayout = false
        self.tupleView.isPagingEnabled = true
        self.tupleView.delegate = self
        
        //添加键盘
        self.addKeyboardObserver()
        self.hideKeyboardWhenTapBackground()
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboardNotifyAction), name: NSNotification.Name.init(KShowKeyboardNotify), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tupleView.contentSize = CGSizeMake(0, self.tupleView.height*3)
        self.tupleView.contentOffset = CGPointMake(0, self.tupleView.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 监测当前设备是否处于录屏状态
        let sc = UIScreen.main
        if #available(iOS 11.0, *) {
            if (sc.isCaptured) {
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
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(KShowKeyboardNotify), object: nil)
            //通知释放跟直播相关的tupleView
            NotificationCenter.default.post(name: NSNotification.Name.init(KLiveRoomReleaseTupleKey), object: nil)
        }
    }

    // 录屏
    @objc private func recordingScreen() {
        self.dismiss(animated: true, completion: nil)
        UIAlertController.showAlertWithTitle("安全提醒", message: "请不要录屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
        //UIAlertView.init(title: "安全提醒", message: "请不要录屏分享给他人以保障账户安全。", delegate: nil, cancelButtonTitle: "我知道了").show()
    }

    // 截屏
    @objc private func screenshot() {
        //UIAlertController.showAlertWithTitle("安全提醒", message: "请不要截屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
        UIAlertView.init(title: "安全提醒", message: "请不要截屏分享给他人以保障账户安全。", delegate: nil, cancelButtonTitle: "我知道了").show()
    }

    @objc func showKeyboardNotifyAction() {
        UIApplication.getKeyWindow?.addSubview(self.inputField)
        self.inputField.becomeFirstResponder()
    }

    override var prefersNavigationBarHidden: Bool {
        return true
    }

    override func keyboardWillShowWithRect(_ keyboardRect: CGRect, animationDuration duration: CGFloat) -> Void {
        UIView.animate(withDuration: 0.3) {
            let frame = CGRectMake(0, keyboardRect.origin.y-40, UIScreen.width, 40)
            self.inputField.frame = frame
        }
    }

    override func keyboardWillHideWithRect(_ keyboardRect: CGRect, animationDuration duration: CGFloat) -> Void {
        UIView.animate(withDuration: 0.3) {
            let frame = CGRectMake(0, UIScreen.height, UIScreen.width, 40)
            self.inputField.frame = frame
        } completion: { finished in
            //释放textField
            self.inputField.removeFromSuperview()
            self.inputField.text = ""
            self._inputField = nil
        }
    }

    func tupleScrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY >= 2*self.view.height) {//向上滚动
            scrollView.setContentOffset(CGPointMake(0, self.view.height), animated: false)
            self.tupleScrollViewDidScrollToTop(scrollView)
        }else if (offsetY <= 0) {//向下滚动
            scrollView.setContentOffset(CGPointMake(0, self.view.height), animated: false)
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
        
        switch (indexPath.row) {
            case 0:
                let _ = itemBlock(nil, HUserLiveBgCell.self, nil, true)
                break;
            case 2:
                let _ = itemBlock(nil, HUserLiveBgCell.self, nil, true)
                break;
            case 1:
                if (self.liveStatus == .loading) {
                    let cell = itemBlock(nil, HUserLiveBgCell.self, nil, true) as! HUserLiveBgCell
                    // 禁止滚动
                    self.tupleView.isScrollEnabled = false;
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
                }else if (self.liveStatus == .liveing) {
                    let _ = itemBlock(nil, HUserLiveCell.self, nil, true)
                }
                break;

            default:
                break;
        }

    }

    //向上滚动
    func tupleScrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        // 更改直播状态
        self.liveStatus = .loading;
    }
    //向下滚动
    func tupleScrollViewDidScrollToBottom(_ scrollView: UIScrollView) {
        // 更改直播状态
        self.liveStatus = .loading
    }
    //可反复加载内容的直播功能
    func reloadLiveBroadcast(_ completion: (() -> Void)?) {
        let deadline = DispatchTime.now() + 3
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            if (completion != nil) {
                completion!()
            }
        }
    }

}
