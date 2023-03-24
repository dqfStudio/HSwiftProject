//
//  HLocalNotification.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import UserNotifications

@objc protocol HLocalNotificationDelegate: NSObjectProtocol {
    /**
     app处于前台时收到推送数据
     
     @param userInfo 推送数据
     */
    @objc
    func didReceiveLocalNotificationOnApplicationActive(_ userInfo: [AnyHashable: Any])
    
    /**
     app处于后台时收到推送，点击推送后会调用该代理
     
     @param userInfo 推送数据
     */
    @objc
    func didReceiveLocalNotificationOnApplicationBackground(_ userInfo: [AnyHashable: Any])
}

class HLocalNotification: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    static let shareInstance: HLocalNotification = {
        return HLocalNotification()
    }()
    
    /**
     HLocalNotification推送数据回调代理
     */
    weak var delegate: HLocalNotificationDelegate?
    
    /**
     当app处于前台时是否弹出推送框，默认弹出（此方法只对iOS10以后的系统有效，因为iOS10之前的app处于前台时，app是不能弹出推送弹框的）
     */
    var showNotificationWhenApplicationActice = true
    
    /**
     注册本地推送，获取授权
     */
    func registerLocalNotification() {
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
    }
    
    /**
     iOS8-iOS10发送本地推送
     
     @param badge 角标
     @param sound 推送声音（nil代表系统默认声音，可填写自定义推送声音名称）
     @param title 推送标题
     @param message 推送内容
     @param params 推送额外附带数据，会在推送数据回调代理中获取到
     @param fireDate 触发时间（nil代表立即触发）
     @param repeatInterval 重复时间间隔，0代表不重复
     @param identifier 通知标志符，可用来更新和删除本地通知
     */
    func pushLocalNotification(withBadge badge: Int, sound: String?, title: String, message: String, params: [AnyHashable: Any], fireDate: Date?, repeatInterval: Int, identifier: String) {
        let notification = UILocalNotification()
        if #available(iOS 8.2, *) {
            notification.alertTitle = title
        }
        notification.alertBody = message
        if let sound = sound {
            notification.soundName = sound
        } else {
            notification.soundName = UILocalNotificationDefaultSoundName
        }
        var dic = params
        if identifier.count > 0 {
            dic["HNotification_identifier"] = identifier
        }
        notification.userInfo = dic
        notification.applicationIconBadgeNumber = badge
        notification.repeatInterval = NSCalendar.Unit(rawValue: UInt(repeatInterval))
        if let fireDate = fireDate {
            notification.fireDate = fireDate
            UIApplication.shared.scheduleLocalNotification(notification)
        } else {
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }

    /**
     iOS10之后发送本地推送
     
     @param badge 角标
     @param sound 推送声音（nil代表系统默认声音，可填写自定义推送声音名称）
     @param title 推送标题
     @param message 推送内容
     @param params 推送额外附带数据，会在推送数据回调代理中获取到
     @param trigger 推送触发器
     @param identifier 通知标志符，可用来更新和删除本地通知
     */
    @available(iOS 10.0, *)
    func pushLocalNotification(withBadge badge: Int, sound: String?, title: String, message: String, params: [AnyHashable: Any], trigger: UNNotificationTrigger?, identifier: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        if let sound = sound {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: sound))
        } else {
            content.sound = UNNotificationSound.default
        }
        content.userInfo = params
        content.badge = NSNumber(value: badge)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            
        }
    }
    
    /**
     iOS8-iOS10更新本地推送(相同identifier的推送会替换)
     
     @param badge 角标
     @param sound 推送声音（nil代表系统默认声音，可填写自定义推送声音名称）
     @param title 推送标题
     @param message 推送内容
     @param params 推送额外附带数据，会在推送数据回调代理中获取到
     @param fireDate 触发时间（nil代表立即触发）
     @param repeatInterval 重复时间间隔，0代表不重复
     @param identifier 通知标志符，可用来更新和删除本地通知
     */
    func updateLocalNotification(withBadge badge: Int, sound: String, title: String, message: String, params: [AnyHashable: Any], fireDate: Date?, repeatInterval: Int, identifier: String) {
        let localNotifications = UIApplication.shared.scheduledLocalNotifications
        for notification in localNotifications! {
            if let info = notification.userInfo {
                if let currentIdentifier = info["HNotification_identifier"] as? String, currentIdentifier == identifier {
                    UIApplication.shared.cancelLocalNotification(notification)
                    break
                }
            }
        }
        pushLocalNotification(withBadge: badge, sound: sound, title: title, message: message, params: params, fireDate: fireDate, repeatInterval: repeatInterval, identifier: identifier)
    }

    /**
     iOS10之后更新本地推送(相同identifier的推送会替换)
     
     @param badge 角标
     @param sound 推送声音（nil代表系统默认声音，可填写自定义推送声音名称）
     @param title 推送标题
     @param message 推送内容
     @param params 推送额外附带数据，会在推送数据回调代理中获取到
     @param trigger 推送触发器
     @param identifier 通知标志符，可用来更新和删除本地通知
     */
    @available(iOS 10.0, *)
    func updateLocalNotification(withBadge badge: Int, sound: String, title: String, message: String, params: [AnyHashable: Any], trigger: UNNotificationTrigger?, identifier: String) {
        pushLocalNotification(withBadge: badge, sound: sound, title: title, message: message, params: params, trigger: trigger, identifier: identifier)
    }
    
    /**
     取消指定标志符的本地推送
     
     @param identifier 通知标志符
     */
    func cancelLocalNotification(withIdentifier identifier: String) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        } else {
            let localNotifications = UIApplication.shared.scheduledLocalNotifications
            for notification in localNotifications! {
                if let info = notification.userInfo {
                    if let currentIdentifier = info["HNotification_identifier"] as? String, currentIdentifier == identifier {
                        UIApplication.shared.cancelLocalNotification(notification)
                        break
                    }
                }
            }
        }
    }
    
    /**
     取消所有本地推送
     */
    func cancelAllLocalNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    /**
     设置app角标数量

     @param badge 角标数量
     */
    func setApplicationIconBadgeNumber(badge: Int) {
        let badge = badge < 0 ? 0 : badge
        UIApplication.shared.applicationIconBadgeNumber = badge
    }
    
    /**
     去除app角标
     */
    func clearApplicationIconBadge() {
        setApplicationIconBadgeNumber(badge: 0)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    @available(iOS 10.0, *)
    // 当应用程序处于活动状态时，显示通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if showNotificationWhenApplicationActice {
            completionHandler([.badge, .sound, .alert])
        } else {
            let userInfo = notification.request.content.userInfo
            if let delegate = delegate, delegate.responds(to: #selector(HLocalNotificationDelegate.didReceiveLocalNotificationOnApplicationActive(_:))) {
                delegate.didReceiveLocalNotificationOnApplicationActive(userInfo)
            }
            completionHandler([])
        }
    }

    @available(iOS 10.0, *)
    // 当用户点击通知时，处理通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .active {
            if let delegate = delegate, delegate.responds(to: #selector(HLocalNotificationDelegate.didReceiveLocalNotificationOnApplicationActive(_:))) {
                delegate.didReceiveLocalNotificationOnApplicationActive(userInfo)
            }
        } else {
            if let delegate = delegate, delegate.responds(to: #selector(HLocalNotificationDelegate.didReceiveLocalNotificationOnApplicationBackground(_:))) {
                delegate.didReceiveLocalNotificationOnApplicationBackground(userInfo)
            }
        }
        completionHandler()
    }

    // 当应用程序接收到本地通知时，处理通知
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let userInfo = notification.userInfo
        if UIApplication.shared.applicationState == .active {
            if let delegate = delegate, delegate.responds(to: #selector(HLocalNotificationDelegate.didReceiveLocalNotificationOnApplicationActive(_:))) {
                delegate.didReceiveLocalNotificationOnApplicationActive(userInfo!)
            }
        } else {
            if let delegate = delegate, delegate.responds(to: #selector(HLocalNotificationDelegate.didReceiveLocalNotificationOnApplicationBackground(_:))) {
                delegate.didReceiveLocalNotificationOnApplicationBackground(userInfo!)
            }
        }
    }
}
