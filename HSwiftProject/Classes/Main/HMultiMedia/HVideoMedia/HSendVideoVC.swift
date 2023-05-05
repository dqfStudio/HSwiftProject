//
//  HSendVideoVC.swift
//  HSwiftProject
//
//  Created by Wind on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

enum HSendVideoStatus: Int {
    case sendVideoStatus1 = 0
    case sendVideoStatus2 = 1
    case sendVideoStatus3 = 2
    case sendVideoStatus4 = 3
    case sendVideoStatus5 = 4
    case sendVideoStatus6 = 5
}

var KSendVideoHeight1: CGFloat = 55.0
var KSendVideoHeight2: CGFloat = 65.0

class HSendVideoVC: HViewController, HTupleViewDelegate {
    private var _tupleView: HTupleView?
    var tupleView: HTupleView {
        if _tupleView == nil {
            _tupleView = HTupleView.tupleFrame({ () -> CGRect in
                return UIScreen.bound
            }, exclusiveSections: { () -> NSArray in
                return []
            })
        }
        return _tupleView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tupleView.delegate = self
        self.tupleView.backgroundColor = UIColor(hex: "#634848")
        self.view.addSubview(self.tupleView)
        
        self.tupleView.tupleState = 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 监测当前设备是否处于录屏状态
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
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
            if #available(iOS 11.0, *) {
                NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
            }
            NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        }
    }
    
    // 录屏
    @objc
    private func recordingScreen() {
        self.dismiss(animated: true)
        UIAlertController.showAlert(withTitle: "安全提醒", message: "请不要录屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
    }

    // 截屏
    @objc
    private func screenshot() {
        //UIAlertController.showAlert(withTitle: "安全提醒", message: "请不要截屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
        UIAlertView(title: "安全提醒", message: "请不要截屏分享给他人以保障账户安全。", delegate: nil, cancelButtonTitle: "我知道了").show()
    }
    
    override var prefersNavigationBarHidden: Bool {
        return true
    }
}
