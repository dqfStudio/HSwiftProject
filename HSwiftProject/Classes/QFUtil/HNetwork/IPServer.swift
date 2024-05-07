//
//  IPServer.swift
//  HSwiftProject
//
//  Created by owner on 2024/5/7.
//  Copyright © 2024 wind. All rights reserved.
//

import UIKit

let kCanSwitchIP = true //是否可切换环境(用户测试)
var kDefaultIpIsTest: Bool = true //当前服务器环境
var kHttpCryptor: Bool = true

/*
 正式 "imapi.freechat.world"
 预发布 "impre.freechqat.world"
 */
let kHostIP = "imapi.freechat.world"
//let kTestIp = "imtest.freechat.world" //"18.138.81.21"//"54.251.11.130"//
let kTestIp = "imtest.fc.plus" //"18.138.81.21"//"54.251.11.130"//

class IPServer: NSObject {
    // MARK: - IP
    // IM
    private(set) var ipImBussiness = "https://\(kHostIP)/demo"
    private(set) var ipImSdkAPI = "https://\(kHostIP)/api"
    private(set) var ipImSdkWS = "wss://\(kHostIP)/msg-gateway"
    // func ip
    private(set) var ipIm10008 = "https://\(kHostIP)/freechat-api"
    // blindbox
    private(set) var ipBlindbox = "https://blindbox.freechat.world"
    // 质押
    private(set) var ipPledges = "https://pledge.freechat.world"
    // share
    private(set) var ipShare = "https://share.freechat.world/share"
    // wallet
    private(set) var ipWallet = "https://blockchaindata.freechat.world"
    // 小程序
    private(set) var ipApplet = "https://app.freechat.world/#/miniapp"
    // app
    private(set) var ipApp = "https://app.freechat.world"
    // FC钱包
    private(set) var ipVFCC = "https://vfcc.freechat.world"
    // ETH server
    private(set) var ipEtherscanTX = "https://etherscan.io/tx"
    // group link
    private(set) var ipGroupLink = "https://share.freechat.world/groupshare"
    // media base url
    var mediaBaseURL: String {
//        return "https://oss.freechat.world"
        return "https://oss.fc.plus"
//        if self.isCN() {
//            return "https://oss-cn.freechat.world"
////            return "https://d1e084oasoo524.cloudfront.net"
//        } else {
//            return "https://oss.freechat.world"
//        }
    }
    
    // MARK: - param
    // 浏览器指纹
    var fingerprint: String?
    // 易盾指纹
    var ydunFinger: String?
    // 设备信息
    private var deviceInfoString: String?
    // 指定区域
    private lazy var region: String = {
        let idf = Locale.current.identifier
        return idf.components(separatedBy: "_").last ?? idf
    }()
    
    // MARK: - Func
    static var shared = IPServer()
    
    override init() {
        super.init()
        guard kCanSwitchIP else {
            kDefaultIpIsTest = false
            return
        }
        
        if kDefaultIpIsTest {
            let imHost = kTestIp//self.isCN() ? "imtest-cn.freechat.world" : kTestIp
            self.ipImBussiness = UserDefaults.standard.string(forKey: kIPSaveIMBussinessSever) ?? "https://\(imHost)/demo" //10004
            self.ipImSdkAPI = UserDefaults.standard.string(forKey: kIPSaveIMSdkAPI) ?? "https://\(imHost)/api/" //10002
            self.ipImSdkWS = UserDefaults.standard.string(forKey: kIPSaveIMSdkWS) ?? "wss://\(imHost)/msg-gateway/" //10001
            self.ipIm10008 = UserDefaults.standard.string(forKey: kIPSaveIM10008) ?? "https://\(imHost)/freechat-api" //10008
            self.ipBlindbox = UserDefaults.standard.string(forKey: kIPSaveBlindbox) ?? "https://blindbox-test.freechat.world"
            self.ipShare = UserDefaults.standard.string(forKey: kIPSaveShare) ?? "https://test.freechat.world/share"
//            self.ipWallet = UserDefaults.standard.string(forKey: kIPSaveWallet) ?? "https://blockchaindata-test.freechat.world"
            self.ipWallet = UserDefaults.standard.string(forKey: kIPSaveWallet) ?? "https://blockchaindata-test.fc.plus"
            self.ipPledges = UserDefaults.standard.string(forKey: kIPSaveStake) ?? "https://pledges-test.freechat.world"
            self.ipApplet = UserDefaults.standard.string(forKey: kIPSaveApplet) ?? "https://app-test.freechat.world/#/miniapp"
            self.ipApp = UserDefaults.standard.string(forKey: kIPSaveApp) ?? "https://app-test.freechat.world"
//            self.ipVFCC = UserDefaults.standard.string(forKey: kIPSaveVFCC) ?? "https://vfcc-test.freechat.world"
            self.ipVFCC = UserDefaults.standard.string(forKey: kIPSaveVFCC) ?? "https://vfcc-test.fc.plus"
            self.ipEtherscanTX = "https://sepolia.etherscan.io/tx"
            self.ipGroupLink = "https://test.freechat.world/groupshare"
        } else {
            let imHost = kHostIP//self.isCN() ? "imapi-cn.freechat.world" : "imapi.freechat.world"
            self.ipImBussiness = UserDefaults.standard.string(forKey: kIPSaveIMBussinessSever) ?? "https://\(imHost)/demo"
            self.ipImSdkAPI = UserDefaults.standard.string(forKey: kIPSaveIMSdkAPI) ?? "https://\(imHost)/api"
            self.ipImSdkWS = UserDefaults.standard.string(forKey: kIPSaveIMSdkWS) ?? "wss://\(imHost)/msg-gateway"
            self.ipIm10008 = UserDefaults.standard.string(forKey: kIPSaveIM10008) ?? "https://\(imHost)/freechat-api"
            self.ipBlindbox = UserDefaults.standard.string(forKey: kIPSaveBlindbox) ?? "https://blindbox.freechat.world"
            self.ipShare = UserDefaults.standard.string(forKey: kIPSaveShare) ?? "https://share.freechat.world/share"
            self.ipWallet = UserDefaults.standard.string(forKey: kIPSaveWallet) ?? "https://blockchaindata.freechat.world"
            self.ipPledges = UserDefaults.standard.string(forKey: kIPSaveStake) ?? "https://pledges.freechat.world"
            self.ipApplet = UserDefaults.standard.string(forKey: kIPSaveApplet) ?? "https://app.freechat.world/#/miniapp"
            self.ipApp = UserDefaults.standard.string(forKey: kIPSaveApp) ?? "https://app.freechat.world"
            self.ipVFCC = UserDefaults.standard.string(forKey: kIPSaveVFCC) ?? "https://vfcc.freechat.world"
            self.ipEtherscanTX = "https://etherscan.io/tx"
            self.ipGroupLink = "https://share.freechat.world/groupshare"
        }
    }
    
    func saveIP(imBussiness: String, //im ip
                imSdkAPI: String,
                imSdkWS: String,
                im10008: String, //func ip
                blindbox: String, //blindbox ip
                stake: String, //质押 IP
                share: String, //share ip
                wallet: String, //钱包
                applet: String, //小程序
//                app: String, //app share
                vFCC: String) { //FC钱包
        if kCanSwitchIP {
            self.ipImBussiness = imBussiness
            self.ipImSdkAPI = imSdkAPI
            self.ipImSdkWS = imSdkWS
            self.ipIm10008 = im10008
            self.ipBlindbox = blindbox
            self.ipPledges = stake
            self.ipShare = share
            self.ipWallet = wallet
            self.ipApplet = applet
//            self.ipApp = app
            self.ipVFCC = vFCC
            UserDefaults.standard.set(imBussiness, forKey: kIPSaveIMBussinessSever)
            UserDefaults.standard.set(imSdkAPI, forKey: kIPSaveIMSdkAPI)
            UserDefaults.standard.set(imSdkWS, forKey: kIPSaveIMSdkWS)
            UserDefaults.standard.set(im10008, forKey: kIPSaveIM10008)
            UserDefaults.standard.set(blindbox, forKey: kIPSaveBlindbox)
            UserDefaults.standard.set(stake, forKey: kIPSaveStake)
            UserDefaults.standard.set(share, forKey: kIPSaveShare)
            UserDefaults.standard.set(wallet, forKey: kIPSaveWallet)
            UserDefaults.standard.set(applet, forKey: kIPSaveApplet)
//            UserDefaults.standard.set(ipApp, forKey: kIPSaveApp)
            UserDefaults.standard.set(vFCC, forKey: kIPSaveVFCC)
        }
    }
    
    /// 集合设备信息
    func getDeviceInfo() -> String {
//        if let device = deviceInfoString, !device.isEmpty {
//            return device
//        }
//        let deviceInfo: [String: String] = ["deviceId": Utility.deviceId(),
//                                            "x-app-platform": "iOS",
//                                            "x-app-version": (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0",
//                                            "x-os-version": UIDevice.current.systemVersion,
//                                            "deviceType": RiskCtrlRequest.deviceType() ?? "",
//                                            "ip": RiskCtrlRequest.getIFAddresses().first ?? "",
//                                            "resolution": "\(UIScreen.main.bounds.size.width * UIScreen.main.scale)x\(UIScreen.main.bounds.size.height * UIScreen.main.scale)", //分辨率
//                                            "screensize": "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)",
//                                            "regionTag": self.region
//                                            ]
//        deviceInfoString = deviceInfo.JSONStringFromJSONObject()
//        return deviceInfoString ?? ""
        return ""
    }
    
    private func isCN() -> Bool {
        let id = Locale.current.identifier
        if id.lowercased().hasSuffix("_cn") {
            return true
        }
        return false
//        let networkInfo = CTTelephonyNetworkInfo()
//        let carrierDic = networkInfo.serviceSubscriberCellularProviders
//        if let carrier = carrierDic?.filter({ $0.value.carrierName != nil }).first?.value {
//            if carrier.isoCountryCode?.lowercased() == "cn" {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            let id = Locale.current.identifier
//            if id.lowercased().hasSuffix("_cn") {
//                return true
//            }
//            return false
//        }
    }
}

extension String {
    func mediaHostReplece() -> String {
        let searchString = "https://freechatoss.s3.ap-southeast-1.amazonaws.com"
        let searchString2 = "https://freechatoss.s3-accelerate.amazonaws.com"
        var newVideoUlr = self.replacingOccurrences(of: searchString, with: IPServer.shared.mediaBaseURL)
        newVideoUlr = newVideoUlr.replacingOccurrences(of: searchString2, with: IPServer.shared.mediaBaseURL)
        return newVideoUlr
    }
}

let kIPSaveIMBussinessSever = "fc.ip.im.bussinessSever"//IM
let kIPSaveIMSdkAPI = "fc.ip.im.sdkAPI"//IM
let kIPSaveIMSdkWS = "fc.ip.im.sdkWS"//IM
let kIPSaveIM10008 = "fc.ip.im.10008"//Func IP
let kIPSaveWallet = "fc.ip.wallet"//Wallet
let kIPSaveBlindbox = "fc.ip.blindbox"//Blindbox
let kIPSaveStake = "fc.ip.stake"//质押
let kIPSaveShare = "fc.ip.share"//Share
let kIPSaveApplet = "fc.ip.applet"//小程序
let kIPSaveApp = "fc.ip.app"//小程序
let kIPSaveVFCC = "fc.ip.vFCC"//积分
