//
//  AppDelegate+NotifyService.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/24.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension AppDelegate: HLocalNotificationDelegate, HRemoteNotificationDelegate {

    func pushLocalNotification(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            HLocalNotification.shareInstance.pushLocalNotification(withBadge: 2, sound: "notification.caf", title: "测试1", message: "1111111111", params: ["tag": "H11111111"], trigger: trigger, identifier: "test")
        } else {
            let date = Date(timeIntervalSinceNow: 5)
            HLocalNotification.shareInstance.pushLocalNotification(withBadge: 2, sound: "notification.caf", title: "测试1", message: "1111111111", params: ["tag": "H11111111"], fireDate: date, repeatInterval: 0, identifier: "test")
        }
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        HLocalNotification.shareInstance.delegate = self
//        HRemoteNotification.shareInstance.delegate = self
//        HLocalNotification.shareInstance.showNotificationWhenApplicationActice = false
//        HRemoteNotification.shareInstance.showNotificationWhenApplicationActice = false
//        HRemoteNotification.shareInstance.registerRemoteNotification()
//        return self.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        HLocalNotification.shareInstance.application(application, didReceive: notification)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HRemoteNotification.shareInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        HRemoteNotification.shareInstance.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }

    // HLocalNotificationDelegate
    func didReceiveLocalNotificationOnApplicationBackground(_ userInfo: [AnyHashable : Any]) {
        print("localNotification_ApplicationBackgroundWithUserInfo:\(userInfo.description)")
    }

    func didReceiveLocalNotificationOnApplicationActive(_ userInfo: [AnyHashable : Any]) {
        print("localNotification_ApplicationActiveWithUserInfo:\(userInfo.description)")
    }

    // HRemoteNotificationDelegate
    func didRegisterForRemoteNotifications(withToken token: Data, tokenString: String) {
        print("remoteNotification_deviceTokenString:\(tokenString)")
    }

    func didReceiveRemoteNotificationOnApplicationActive(withUserInfo userInfo: [AnyHashable : Any]) {
        print("remoteNotification_ApplicationActiveWithUserInfo:\(userInfo.description)")
    }

    func didReceiveRemoteNotificationOnApplicationBackground(withUserInfo userInfo: [AnyHashable : Any]) {
        print("remoteNotification_ApplicationBackgroundWithUserInfo:\(userInfo.description)")
    }

}
