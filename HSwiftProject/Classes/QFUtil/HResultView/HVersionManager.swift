//
//  HVersionManager.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import Foundation

private var kHistoryVersionsKey = "HistoryVersionsKey"

class HVersionManager: NSObject {
    
    //单例
    static var shared: HVersionManager = {
        return HVersionManager()
    }()
    
    private var versionFirstLaunchKey = ""
    private var versionLaunchTimesKey = ""
    
    private override init() {
        super.init()
        self.versionFirstLaunchKey = "\(self.currentVersion)_date"
        self.versionLaunchTimesKey = "\(self.currentVersion)_times"
    }
    
    //保存当前版本号，不会重复保存
    func saveVersion() {
        guard var historys = self.historyVersion else {
            UserDefaults.standard.set([self.currentVersion], forKey: kHistoryVersionsKey)
            UserDefaults.standard.synchronize()
            return
        }
        if !historys.contains(self.currentVersion) {
            historys.append(self.currentVersion)
            UserDefaults.standard.set(historys, forKey: kHistoryVersionsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    //用户升级之前的版本号，新用户则返回nil
    var lastVersion: String? {
        guard let versionArray = self.historyVersion, !versionArray.isEmpty else {
            return nil
        }
        if versionArray.contains(self.currentVersion), versionArray.count > 1 {
            let index = versionArray.count - 2
            return versionArray[index]
        } else {
            return versionArray.last
        }
    }
    
    //当前版本号，没有build号，如5.0.3
    var currentVersion: String {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return version
    }
    
    //当前版本号，有build号，比如：5.0.3.008
    var detailVersion: String {
        guard let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return ""
        }
        return "\(self.currentVersion).\(bundleVersion)"
    }
    
    //判断当前版本是否是第一次启动，主要用于播放引导页
    var isNewVersionFirstLaunch: Bool {
        return UserDefaults.standard.object(forKey: self.versionFirstLaunchKey) == nil
    }
    
    //是否是新用户，YES表示新用户，NO表示升级用户
    var isNewUser: Bool {
        return self.lastVersion == nil
    }
    
    //增加当前版本的启动次数
    func increaseLaunchTimes() {
        var launchTimes = UserDefaults.standard.integer(forKey: self.versionLaunchTimesKey)
        launchTimes += 1
        UserDefaults.standard.set(launchTimes, forKey: self.versionLaunchTimesKey)
        UserDefaults.standard.synchronize()
    }
    
    //第一次启动之后，调用这个方法，会更改记录，如果没调用这个方法，那么下次还会认为当前版本是第一次启动
    func afterVersionFirstLaunch() {
        UserDefaults.standard.set(Date(), forKey: self.versionFirstLaunchKey)
        UserDefaults.standard.synchronize()
    }
    
    private func arrayForVersion(_ version: String) -> [String] {
        return version.components(separatedBy: ".")
    }
    
    private var historyVersion: [String]? {
        return UserDefaults.standard.object(forKey: kHistoryVersionsKey) as? [String]
    }
    
}

//版本号：A.B.C，A是大版本，B是中版本，C是小版本，
enum HVersionCompareResult: Int {
    case diffBigVersion = 1 //不是同一个大版本
    case diffMiddleVersion = 2 //不是同一个中版本
    case diffSmallVersion = 3 //不是同一个小版本
    case identicalSameVersion = 4 //两个版本号完全相同
    case unknownResult = 5
}

extension HVersionManager {
    
    /*
     *当前版本 op version参数，如果参数为空，那么当前版本永远高于nil，version格式：x.x.x，不按照格式的，不能保证结果正确
     */
    
    //当前版本 < version
    func lessThan(_ version: String) -> Bool {
        let output = self.compare(withVersion: version)
        return output == -1
    }
    
    //当前版本 <= version
    func lessOrEqual(_ version: String) -> Bool {
        let output = self.compare(withVersion: version)
        return output != 1
    }
    
    //当前版本 > version
    func higherThan(_ version: String) -> Bool {
        let output = self.compare(withVersion: version)
        return output == 1
    }
    
    //当前版本 >= version
    func higherOrEqual(_ version: String) -> Bool {
        let output = self.compare(withVersion: version)
        return output != -1
    }
    
    //当前版本 == version
    func equalToVersion(_ version: String) -> Bool {
        let output = self.compare(withVersion: version)
        return output == 0
    }
    
    //第一次启动时，进行版本比较，根据比较结果展示不同的引导图
    var firstLaunchVersionCompareResult: HVersionCompareResult {
        return self.versionCompareResult(self.lastVersion)
    }
    
    private func versionCompareResult(_ version: String?) -> HVersionCompareResult {
        guard let version = version else {
            return .unknownResult
        }
        let diffindex = self.differentIndex(withVersion: version)
        var result: HVersionCompareResult = .unknownResult
        switch diffindex {
        case 0:
            result = .diffBigVersion
        case 1:
            result = .diffMiddleVersion
        case 2:
            result = .diffSmallVersion
        case 3:
            result = .identicalSameVersion
        default:
            result = .unknownResult
        }
        return result
    }
    
    private func differentIndex(withVersion version: String) -> Int {
        var diffIndex = 0
        if version.count > 0 {
            var currentVersions = self.arrayForVersion(self.currentVersion)
            var paramerVersions = self.arrayForVersion(version)
            
            var minCount = min(currentVersions.count, paramerVersions.count)
            for _ in minCount..<paramerVersions.count {
                paramerVersions.append("0")
            }
            for _ in minCount..<currentVersions.count {
                currentVersions.append("0")
            }
            minCount = currentVersions.count
            for index in 0..<minCount {
                let currentV = Int(currentVersions[index])!
                let parameterV = Int(paramerVersions[index])!
                if currentV != parameterV {
                    diffIndex = index
                    break
                }
            }
        }
        return diffIndex
    }
    
    private func compare(withVersion version: String) -> Int {
        //1 当前version > 参数version
        //0  当前version = 参数version
        //-1  当前version < 参数version
        var output = 1
        if version.count > 0 {
            let currentVersions = self.arrayForVersion(self.currentVersion)
            let paramerVersions = self.arrayForVersion(version)
            let minCount = min(currentVersions.count, paramerVersions.count)
            //有版本比较，就设置为YES，如果循环结束，还为NO，说明两个版本前部分一样
            var flag = false
            for index in 0..<minCount {
                let currentV = Int(currentVersions[index])!
                let parameterV = Int(paramerVersions[index])!
                if currentV != parameterV {
                    if currentV > parameterV {
                        output = 1
                    } else if currentV < parameterV {
                        output = -1
                    }
                    flag = true
                    break
                }
            }
            if !flag {
                if minCount < paramerVersions.count {
                    output = -1
                } else if minCount < currentVersions.count {
                    output = 1
                } else {
                    output = 0
                }
            }
        }
        return output
    }
}
