//
//  HRemoteNotification.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import UserNotifications

@objc protocol HRemoteNotificationDelegate: NSObjectProtocol {
    /**
     远程推送获取deviceToken
     
     @param token NSData类型deviceToken
     @param tokenString NSString类型deviceToken
     */
    @objc
    func didRegisterForRemoteNotificationsWithDeviceToken(_ token: Data, tokenString: String)
    
    /**
     app处于前台时收到推送数据
     
     @param userInfo 推送数据
     */
    @objc
    func didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(_ userInfo: [AnyHashable : Any])
    
    /**
     app处于后台时收到推送，点击推送后会调用该代理
     
     @param userInfo 推送数据
     */
    @objc
    func didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo(_ userInfo: [AnyHashable : Any])
}

class HRemoteNotification: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    static let shareInstance: HRemoteNotification = {
        return HRemoteNotification()
    }()
    
    /**
     HRemoteNotification推送数据回调代理
     */
    weak var delegate: HRemoteNotificationDelegate?
    
    /**
     当app处于前台时是否弹出推送框，默认弹出（此方法只对iOS10以后的系统有效，因为iOS10之前的app处于前台时，app是不能弹出推送弹框的）
     */
    var showNotificationWhenApplicationActice = true
    
    /**
     注册远程推送，获取授权
     */
    func registerRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                if error == nil {
                    print("request authorization succeeded!")
                }
            }
            center.delegate = self
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /**
     设置app角标数量
     
     @param badge 角标数量
     */
    func setApplicationIconBadgeNumber(_ badge: Int) {
        var badge = badge
        if badge < 0 {
            badge = 0
        }
        UIApplication.shared.applicationIconBadgeNumber = badge
    }
    
    /**
     去除app角标
     */
    func clearApplicationIconBadge() {
        setApplicationIconBadgeNumber(0)
    }
    
    // 处理前台推送
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if showNotificationWhenApplicationActice {
            completionHandler([.badge, .sound, .alert])
        } else {
            let userInfo = notification.request.content.userInfo
            if let delegate = delegate, delegate.responds(to: #selector(HRemoteNotificationDelegate.didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(_:))) {
                delegate.didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(userInfo)
            }
            completionHandler([])
        }
    }
    
    // 处理后台推送
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .active {
            if let delegate = delegate, delegate.responds(to: #selector(HRemoteNotificationDelegate.didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(_:))) {
                delegate.didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(userInfo)
            }
        } else {
            if let delegate = delegate, delegate.responds(to: #selector(HRemoteNotificationDelegate.didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo(_:))) {
                delegate.didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo(userInfo)
            }
        }
        completionHandler()
    }
    
    // 处理静默推送
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if UIApplication.shared.applicationState == .active {
            if let delegate = delegate, delegate.responds(to: #selector(HRemoteNotificationDelegate.didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(_:))) {
                delegate.didReceiveRemoteNotificationOnApplicationActiveWithUserInfo(userInfo)
            }
        } else {
            if let delegate = delegate, delegate.responds(to: #selector(HRemoteNotificationDelegate.didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo(_:))) {
                delegate.didReceiveRemoteNotificationOnApplicationBackgroundWithUserInfo(userInfo)
            }
        }
        completionHandler(.noData)
    }
    
    // 注册推送
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if let delegate = delegate, delegate.responds(to: #selector(HRemoteNotificationDelegate.didRegisterForRemoteNotificationsWithDeviceToken(_:tokenString:))) {
            delegate.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken, tokenString: deviceString)
        }
    }

}
