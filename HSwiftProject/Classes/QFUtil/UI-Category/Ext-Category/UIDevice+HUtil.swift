//
//  UIDevice+HUtil.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// 判断设备是否为iphoneX系列
    static var isIPhoneX: Bool = {
        var iPhoneXSeries: Bool = false
        if UIDevice.current.userInterfaceIdiom == .phone {
            if #available(iOS 11.0, *) {
                let mainWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
                if mainWindow.safeAreaInsets.top > 20.0 {
                    iPhoneXSeries = true
                }
                if !iPhoneXSeries && UIApplication.shared.statusBarFrame.size.height >= 44 {
                    iPhoneXSeries = true
                }
            }
        }
        return iPhoneXSeries
    }()
    
    static var statusBarHeight: CGFloat {
        var height: CGFloat = 0.0
        if UIApplication.statusBarOrientation()?.isPortrait ?? true {
            height = UIDevice.isIPhoneX ? 44.0 : 20.0
        }
        return height
    }

    static var naviBarHeight: CGFloat {
        return 44.0
    }
        
    static var topBarHeight: CGFloat {
        return UIDevice.statusBarHeight+UIDevice.naviBarHeight
    }
        
    static var bottomBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 34.0 : 0.0
    }
    
    /// 判断设备是否为iPad/iPad mini.
    static var isPad: Bool = {
        var pad: Bool = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            pad = true
        }
        return pad
    }()

    /// 判断设备是否为模拟器
    static var isSimulator: Bool = {
    #if TARGET_OS_SIMULATOR
        return true
    #else
        return false
    #endif
    }()
    
    /// 判断设备是否能打电话
    static var canMakePhoneCalls: Bool = {
        return UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    }()

    /// 设备型号名称，例如："iPhone 5s" "iPad mini 2"
    static var machineModelName: String = {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)

        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {

            case "iPod1,1":                                           return "iPod Touch 1"
            case "iPod2,1":                                           return "iPod Touch 2"
            case "iPod3,1":                                           return "iPod Touch 3"
            case "iPod4,1":                                           return "iPod Touch 4"
            case "iPod5,1":                                           return "iPod Touch (5 Gen)"
            case "iPod7,1":                                           return "iPod Touch 6"

            case "iPhone3,1", "iPhone3,2", "iPhone3,3":               return "iPhone 4"
            case "iPhone4,1":                                         return "iPhone 4s"
            case "iPhone5,1":                                         return "iPhone 5"
            case "iPhone5,2":                                         return "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3":                                         return "iPhone 5c (GSM)"
            case "iPhone5,4":                                         return "iPhone 5c (GSM+CDMA)"
            case "iPhone6,1":                                         return "iPhone 5s (GSM)"
            case "iPhone6,2":                                         return "iPhone 5s (GSM+CDMA)"
            case "iPhone7,2":                                         return "iPhone 6"
            case "iPhone7,1":                                         return "iPhone 6 Plus"
            case "iPhone8,1":                                         return "iPhone 6s"
            case "iPhone8,2":                                         return "iPhone 6s Plus"
            case "iPhone8,4":                                         return "iPhone SE"
            case "iPhone9,1":                                         return "国行、日版、港行iPhone 7"
            case "iPhone9,2":                                         return "港行、国行iPhone 7 Plus"
            case "iPhone9,3":                                         return "美版、台版iPhone 7"
            case "iPhone9,4":                                         return "美版、台版iPhone 7 Plus"
            case "iPhone10,1","iPhone10,4":                           return "iPhone 8"
            case "iPhone10,2","iPhone10,5":                           return "iPhone 8 Plus"
            case "iPhone10,3","iPhone10,6":                           return "iPhone X"

            case "iPad1,1":                                           return "iPad"
            case "iPad1,2":                                           return "iPad 3G"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":          return "iPad 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":                     return "iPad Mini"
            case "iPad3,1", "iPad3,2", "iPad3,3":                     return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":                     return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":                     return "iPad Air"
            case "iPad4,4", "iPad4,5", "iPad4,6":                     return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                     return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                                return "iPad Mini 4"
            case "iPad5,3", "iPad5,4":                                return "iPad Air 2"
            case "iPad6,3", "iPad6,4":                                return "iPad Pro 9.7"
            case "iPad6,7", "iPad6,8":                                return "iPad Pro 12.9"
            
            case "AppleTV2,1":                                        return "Apple TV 2"
            case "AppleTV3,1","AppleTV3,2":                           return "Apple TV 3"
            case "AppleTV5,3":                                        return "Apple TV 4"
            
            case "i386", "x86_64":                                    return "Simulator"

            default:  return identifier
            
        }
    }()
    
    /// 总的存储空间
    static var diskSpace: Int64 {
        do {
           let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
           var space: Int64 = attrs[.systemSize] as? Int64 ?? -1
           if space < 0 { space = -1 }
           return space
        }catch { }
        return -1
    }
    
    /// 空余存储空间
    static var diskSpaceFree: Int64 {
        do {
           let attrs = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
           var space: Int64 = attrs[.systemFreeSize] as? Int64 ?? -1
           if space < 0 { space = -1 }
           return space
        }catch { }
        return -1
    }
    
    /// 已使用的存储空间
    static var diskSpaceUsed: Int64 {
        let total: Int64 = UIDevice.diskSpace
        let free: Int64 = UIDevice.diskSpaceFree
        
        if total < 0 || free < 0 { return -1 }
        
        var used: Int64 = total - free
        if used < 0 { used = -1 }
        
        return used
    }
    
    /// 获取ip地址 @"10.2.2.222"
    static var ipAddresses: String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }

}
