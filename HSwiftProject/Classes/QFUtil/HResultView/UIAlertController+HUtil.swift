//
//  UIAlertController+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var alert_action_key = "alert_action_key"

extension UIAlertController {
    
    @discardableResult
    static func showAlertWithTitle(_ title: String?, message: String?, style: UIAlertController.Style, cancelButtonTitle: String?, otherButtonTitles: Array<String>?, completion: ((_ buttonIndex: Int) -> Void)?) -> UIAlertController? {

        if (UIDevice.current.systemVersion.floatValue >= 8.0) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            if (cancelButtonTitle != nil) {
                let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel) { action in
                    if (completion != nil) {
                        completion!(0)
                    }
                }
                alertController.addAction(cancelAction)
            }
            
            if (otherButtonTitles != nil && otherButtonTitles!.count > 0) {
                for i in 0..<otherButtonTitles!.count {
                    let action = UIAlertAction(title: otherButtonTitles![i], style: UIAlertAction.Style.default) { action in
                        if (completion != nil) {
                            let index = objc_getAssociatedObject(action, &alert_action_key) as! NSNumber
                            completion!(index.intValue)
                        }
                    }
                    objc_setAssociatedObject(action, &alert_action_key, NSNumber(value: i + 1), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    alertController.addAction(action)
                }
            }
            
            let rootController = UIApplication.shared.keyWindow?.rootViewController
            DispatchQueue.main.async {
                if ((rootController?.isKind(of: UIViewController.self)) != nil) {
                    rootController?.present(alertController, animated: true, completion: nil)
                }
            }
            return alertController
        }
        
        return nil
    }

    @discardableResult
    static func showAlertWithMessage(_ message: String, cancel: (() -> Void)?) -> UIAlertController? {
        let alertController = UIAlertController(title: "温馨提醒", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { action in
            if (cancel != nil) {
                cancel!()
            }
        }
        alertController.addAction(cancel)
        UIApplication.shared.getKeyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        return alertController
    }
}


//extension HAlertController {
//
//    @discardableResult
//    static func showAlert(withTitle title: String?, message: String?, cancelTitle: String?, confirmTitle: String?, completion: ((_ actionStyle: HAlertActionStyle) -> Void)?) -> HAlertController? {
//        let alertController = HAlertController(title: title, message: message, preferredStyle: .alert)
//        // 取消按钮
//        if let cancelTitle = cancelTitle {
//            let cancelAction = HAlertAction(title: cancelTitle, style: .cancel) { actionStyle in
//                if let completion = completion {
//                    completion(actionStyle)
//                }
//            }
//            alertController.addAction(cancelAction)
//        }
//        // 确认按钮
//        if let confirmTitle = confirmTitle {
//            let confirmAction = HAlertAction(title: confirmTitle, style: .confirm) { actionStyle in
//                if let completion = completion {
//                    completion(actionStyle)
//                }
//            }
//            alertController.addAction(confirmAction)
//        }
//        // 显示alert
//        DispatchQueue.main.async {
//            guard let rootController = UIApplication.shared.keyWindow?.rootViewController,
//                    rootController.isKind(of: UIViewController.self) else { return }
//            rootController.presentController(alertController, completion: nil)
//        }
//        return alertController
//    }
//
//}


extension HSheetController {
    
    @discardableResult
    static func showAlert(withTitle title: String?, completion: @escaping (_ actionStyle: Int) -> Void) -> HSheetController? {
        let cancelAction = HSheetAction(title: "取消", image: nil) { index in
            completion(index)
        }
        let alertController = HSheetController(title: title, cancelAction: cancelAction)
        // 视频按钮
        let videoAction = HSheetAction(title: "视频", image: nil) { index in
            completion(index)
        }
        alertController.addAction(videoAction)
        // 音频按钮
        let audioAction = HSheetAction(title: "音频", image: nil) { index in
            completion(index)
        }
        alertController.addAction(audioAction)
        // 显示alert
        DispatchQueue.main.async {
            guard let rootController = UIApplication.shared.keyWindow?.rootViewController,
                    rootController.isKind(of: UIViewController.self) else { return }
            rootController.presentController(alertController, completion: nil)
        }
        return alertController
    }

    
}
