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
    static func showAlert(withTitle title: String?, message: String?, style: UIAlertController.Style, cancelButtonTitle: String?, otherButtonTitles: Array<String>?, completion: ((_ buttonIndex: Int) -> Void)?) -> UIAlertController? {
        guard #available(iOS 8.0, *) else { return nil }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let cancelTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                completion?(-1)
            }
            alertController.addAction(cancelAction)
        }
        
        if let otherTitles = otherButtonTitles, !otherTitles.isEmpty {
            for (index, title) in otherTitles.enumerated() {
                let action = UIAlertAction(title: title, style: .default) { _ in
                    completion?(index)
                }
                alertController.addAction(action)
            }
        }
        
        if let rootController = UIApplication.shared.getKeyWindow?.rootViewController,
           rootController.isKind(of: UIViewController.self) {
            rootController.present(alertController, animated: true, completion: nil)
        }
        
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

extension HPullController {
    
    @discardableResult
    static func showWalletAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HPullController {
        let cancelAction = HSheetAction(title: "取消".localized()) { index in
            completion(index)
        }
        let alertController = HPullController(title: nil, cancelAction: cancelAction)
        // 转给Freechat钱包
        let videoAction = HSheetAction(title: "转给Freechat钱包".localized()) { index in
            completion(index)
        }
        alertController.addAction(videoAction)
        // 转给Web 3钱包
        let audioAction = HSheetAction(title: "转给Web 3钱包".localized()) { index in
            completion(index)
        }
        alertController.addAction(audioAction)
        return alertController
    }
    
    @discardableResult
    static func showVideoAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HPullController {
        let cancelAction = HSheetAction(title: "取消".localized()) { index in
            completion(index)
        }
        let alertController = HPullController(title: nil, cancelAction: cancelAction)
        // 视频通话
        let videoAction = HSheetAction(title: "视频通话".localized(), image: "Icon-video-phone") { index in
            completion(index)
        }
        alertController.addAction(videoAction)
        // 语音通话
        let audioAction = HSheetAction(title: "语音通话".localized(), image: "Icon-audio-phone") { index in
            completion(index)
        }
        alertController.addAction(audioAction)
        return alertController
    }
    
}

extension HSheetController {
    
    @discardableResult
    static func showWalletAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HSheetController {
        let cancelAction = HSheetAction(title: "取消".localized()) { index in
            completion(index)
        }
        let alertController = HSheetController(title: nil, cancelAction: cancelAction)
        // 转给Freechat钱包
        let videoAction = HSheetAction(title: "转给Freechat钱包".localized()) { index in
            completion(index)
        }
        alertController.addAction(videoAction)
        // 转给Web 3钱包
        let audioAction = HSheetAction(title: "转给Web 3钱包".localized()) { index in
            completion(index)
        }
        alertController.addAction(audioAction)
        return alertController
    }
    
    @discardableResult
    static func showVideoAlert(completion: @escaping (_ actionStyle: Int) -> Void) -> HSheetController {
        let cancelAction = HSheetAction(title: "取消".localized()) { index in
            completion(index)
        }
        let alertController = HSheetController(title: nil, cancelAction: cancelAction)
        // 视频通话
        let videoAction = HSheetAction(title: "视频通话".localized(), image: "Icon-video-phone") { index in
            completion(index)
        }
        alertController.addAction(videoAction)
        // 语音通话
        let audioAction = HSheetAction(title: "语音通话".localized(), image: "Icon-audio-phone") { index in
            completion(index)
        }
        alertController.addAction(audioAction)
        return alertController
    }
    
}
