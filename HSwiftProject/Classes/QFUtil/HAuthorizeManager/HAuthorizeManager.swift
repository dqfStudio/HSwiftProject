//
//  HAuthorizeManager.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreLocation
import Contacts

enum AuthorizationType: Int {
    case camera //相机
    case audio //麦克风
    case location //位置
    case photoLibrary //相册
    case contacts //通讯录
}

enum AuthorizationStatus {
    case authorized
    case denied
}

typealias AuthorizationCompletionBlock = (AuthorizationStatus) -> Void

private var KCHECK_AUTH_CAMERA = "请在iPhone的“设置”-“隐私”-“相机”功能中，找到“应用名称”打开相机访问权限"
private var KCHECK_AUTH_PHOTOLIB = "请在iPhone的“设置”-“隐私”-“照片”功能中，找到“应用名称”打开相册访问权限"
private var KCHECK_AUTH_MICROPHONE = "请在iPhone的“设置”-“隐私”-“麦克风”功能中，找到“应用名称”打开麦克风访问权限"
private var KCHECK_AUTH_CONTACT = "请在iPhone的“设置”-“隐私”-“通讯录”功能中，找到“应用名称”打开通讯录访问权限"
private var KCHECK_AUTH_LOCATION = "请在iPhone的“设置”-“隐私”-“位置”功能中，找到“应用名称”打开位置访问权限"

class HAuthorizeManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager
    
    var authorizationCompletionBlock: AuthorizationCompletionBlock?
    
    static var sharemanager: HAuthorizeManager = {
        return HAuthorizeManager()
    }()
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        super.init()
        locationManager.delegate = self
    }
    
    static func authorizeAll() {
        //定位权限
        _ = HAuthorizeManager.sharemanager
        //相机权限
        AVCaptureDevice.requestAccess(for: .video) { granted in }
        //麦克风权限
        AVCaptureDevice.requestAccess(for: .audio) { granted in }
        //相册权限
        PHPhotoLibrary.requestAuthorization { status in }
        //通讯录
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts) { granted, error in }
    }
    
    //获取权限的状态
    static func getAutorizationStatus(with authorizationType: AuthorizationType, completion: @escaping AuthorizationCompletionBlock) {
        switch authorizationType {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        case .audio:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        case .location:
            let status = CLLocationManager.authorizationStatus()
            if status == .notDetermined {
                sharemanager.authorizationCompletionBlock = completion
            } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                completion(.authorized)
            } else {
                completion(.denied)
            }
        case .photoLibrary:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        case .contacts:
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completion(.authorized)
                } else {
                    completion(.denied)
                }
            }
        }
    }
    
    //没有权限的提示
    static func showAlert(with authorizationType: AuthorizationType) {
        var title: String?
        var message: String?
        let confirmTitle = "设置"
        let cancelTitle = "取消"
        let gosetting = {
            if #available(iOS 10.0, *) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        switch authorizationType {
        case .photoLibrary:
            title = "没有相册权限"
            message = KCHECK_AUTH_PHOTOLIB
        case .camera:
            title = "没有相机权限"
            message = KCHECK_AUTH_CAMERA
        case .audio:
            title = "没有麦克风权限"
            message = KCHECK_AUTH_MICROPHONE
        case .contacts:
            title = "没有通讯录权限"
            message = KCHECK_AUTH_CONTACT
        case .location:
            title = "没有位置权限"
            message = KCHECK_AUTH_LOCATION
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: confirmTitle, style: .default) { (action) in
            gosetting()
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                if let completionBlock = self.authorizationCompletionBlock {
                    completionBlock(.authorized)
                }
            } else {
                if let completionBlock = self.authorizationCompletionBlock {
                    completionBlock(.denied)
                }
            }
            self.authorizationCompletionBlock = nil
            self.locationManager.delegate = self
        }
    }
    
}
