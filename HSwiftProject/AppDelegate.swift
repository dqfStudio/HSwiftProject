//
//  AppDelegate.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/14.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

//extension UIImage : NSSwiftyLoadProtocol {
//    public static func swiftyLoad() {
//        print("UIButton--->swiftyLoad")
//
////        static let share: HPrinterManager = {
////            let instance = HPrinterManager()
////            return instance
////        }()
//    }
//}

//extension UIImage : SelfAware {
//    @objc static func awake() {
//
//    }
//}

//extension UIImage : SelfAware {
//    static func awake() {
//
//    }
//}

//extension NSObject : SelfAware {
//    @objc static func awake() {
//
//    }
//}
//
//protocol SelfAware: class {
//    static func awake()
//    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector)
//}
//
//extension SelfAware {
//
//    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
//        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
//        guard (originalMethod != nil && swizzledMethod != nil) else {
//            return
//        }
//        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
//            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
//        } else {
//            method_exchangeImplementations(originalMethod!, swizzledMethod!)
//        }
//    }
//}
//
//class NothingToSeeHere {
//    static func harmlessFunction() {
//        let typeCount = Int(objc_getClassList(nil, 0))
//        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
//        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
//        objc_getClassList(autoreleasingTypes, Int32(typeCount))
//        for index in 0 ..< typeCount {
//            (types[index] as? SelfAware.Type)?.awake()
//        }
//        types.deallocate()
//    }
//}
//extension UIApplication {
//    private static let runOnce: Void = {
//        NothingToSeeHere.harmlessFunction()
//    }()
//    override open var next: UIResponder? {
//        UIApplication.runOnce
//        return super.next
//    }
//}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        HMenuViewController.swizzle()
        
//        window.backgroundColor = UIColor.white
//        window.rootViewController = UINavigationController.init(rootViewController: HMenuViewController.init())
//        window.makeKeyAndVisible()

        //UIApplication.setStatusBarStyleWithColor(UIColor.white)
        
        //添加通知
        /*
        HLocalNotification.shareInstance.delegate = self
        HRemoteNotification.shareInstance.delegate = self
        HLocalNotification.shareInstance.showNotificationWhenApplicationActice = false
        HRemoteNotification.shareInstance.showNotificationWhenApplicationActice = false
        HRemoteNotification.shareInstance.registerRemoteNotification()
         */
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

