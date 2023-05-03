//
//  UIView+HAlert.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/15.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var hWaitingViewKey = "hWaitingViewKey"
private var hResultViewKey = "hResultViewKey"

extension UIView {
   
    private var hWaitingView: HWaitingView {
        get {
            var waitingView = self.getAssociatedValueForKey(&hWaitingViewKey) as? HWaitingView
            if waitingView == nil {
                waitingView = HWaitingView(frame: self.bounds)
                waitingView!.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
                self.hWaitingView = waitingView!
                self.addSubview(waitingView!)
            }
            return waitingView!
        }
        set {
            if newValue != self.hWaitingView {
                self.setAssociateValue(newValue, key: &hWaitingViewKey)
            }
        }
    }
    
    private var hResultView: HResultView {
        get {
            var resultView = self.getAssociatedValueForKey(&hResultViewKey) as? HResultView
            if resultView == nil {
                resultView = HResultView(frame: self.bounds)
                resultView!.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
                self.hResultView = resultView!
                self.addSubview(resultView!)
            }
            return resultView!
        }
        set {
            if newValue != self.hResultView {
                self.setAssociateValue(newValue, key: &hResultViewKey)
            }
        }
    }
    
    //加载等待界面
    func showWaiting(_ make: (_ make: HWaitingTransition) -> Void) {
        self.removeResult()
        if self.hWaitingView.superview == nil {
            let waitingMake = HWaitingTransition()
            make(waitingMake)
            self.hWaitingView.make = waitingMake
            self.addSubview(self.hWaitingView)
        }
        self.bringSubviewToFront(self.hWaitingView)
    }
    
    //请求结果展示界面
    func showResult(_ make: (_ make: HResultTransition) -> Void) {
        self.removeWaiting()
        if self.hResultView.superview == nil {
            let resultMake = HResultTransition()
            make(resultMake)
            self.hResultView.make = resultMake
            self.addSubview(self.hResultView)
        }
        self.bringSubviewToFront(self.hResultView)
    }
    
    
    //移除对应提示
    func removeWaiting() {
        self.hWaitingView.removeFromSuperview()
    }
    
    func removeResult() {
        self.hResultView.removeFromSuperview()
    }
    
}

//extension HProgressHUD {
//    static func showToast(_ make: (_ make: HToastTransition) -> Void) {
//        let toastMake = HToastTransition()
//        make(toastMake)
//        let hud = HProgressHUD.showHUDAddedTo(toastMake.inView!, animated: true)
//        hud.mode = .modeText
//        hud.labelText = toastMake.desc
//        hud.margin = 10
//        hud.removeFromSuperViewOnHide = true
//        hud.hide(true, afterDelay: toastMake.delay)
//    }
//}
