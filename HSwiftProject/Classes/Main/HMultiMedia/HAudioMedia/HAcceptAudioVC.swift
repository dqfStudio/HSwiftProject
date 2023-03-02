//
//  HAcceptAudioVC.swift
//  HSwiftProject
//
//  Created by owner on 2023/2/25.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HAcceptAudioVC: HTupleController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tupleView.delegate = self
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
        UIAlertController.showAlertWithTitle("安全提醒", message: "请不要录屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
    }

    // 截屏
    @objc
    private func screenshot() {
        //UIAlertController.showAlertWithTitle("安全提醒", message: "请不要截屏分享给他人以保障账户安全。", style: .alert, cancelButtonTitle: "我知道了", otherButtonTitles: nil, completion: nil)
        UIAlertView(title: "安全提醒", message: "请不要截屏分享给他人以保障账户安全。", delegate: nil, cancelButtonTitle: "我知道了").show()
    }
    
    override var prefersNavigationBarHidden: Bool {
        return true
    }
}
