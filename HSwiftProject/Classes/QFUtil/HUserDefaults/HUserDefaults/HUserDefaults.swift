//
//  HUserDefaults.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/20.
//  Copyright © 2019 wind. All rights reserved.
//

import Foundation

// MARK: - Usage Guide
//
// HUserDefaults 提供两个存储域：
//
//   1. HUserDefaults.defaults  →  HDefaultsCore（全局应用设置，与登录用户无关）
//   2. HUserDefaults.user      →  HUserCore（当前用户私有设置，随用户切换自动隔离）
//
// ─────────────────────────────────────────────────────────────
// 【第一步】在对应的 Extern 文件中声明字段（无需手写 key 字符串）
// ─────────────────────────────────────────────────────────────
//
//   // HDefaultsCore+Extern.swift  ← 全局字段
//   extension HDefaultsCore {
//       @NSManaged var isAPPFirstLaunch: Bool
//       @NSManaged var isUserLogin: Bool
//       @NSManaged var appTheme: String       // 新增：直接加，无需任何其他操作
//   }
//
//   // HUserCore+Extern.swift  ← 用户私有字段
//   extension HUserCore {
//       @NSManaged var userId: String
//       @NSManaged var token: String          // 新增：直接加
//       @NSManaged var nickname: String
//   }
//
// ─────────────────────────────────────────────────────────────
// 【第二步】读写数据
// ─────────────────────────────────────────────────────────────
//
//   // 读取全局设置
//   let isLogin = HUserDefaults.defaults.isUserLogin
//   let theme   = HUserDefaults.defaults.appTheme
//
//   // 写入全局设置
//   HUserDefaults.defaults.isUserLogin = true
//   HUserDefaults.defaults.appTheme = "dark"
//
//   // 读取当前用户数据
//   let uid      = HUserDefaults.user.userId
//   let nickname = HUserDefaults.user.nickname
//
//   // 写入当前用户数据
//   HUserDefaults.user.token    = "abc123"
//   HUserDefaults.user.nickname = "张三"
//
// ─────────────────────────────────────────────────────────────
// 【第三步】用户切换
// ─────────────────────────────────────────────────────────────
//
//   // 登录：传入 userId，之后 HUserDefaults.user 自动切换到该用户的存储域
//   HUserDefaults.setUserCoreKey("user_123")
//
//   // 退出：清除当前用户域并重置登录状态
//   HUserDefaults.clearUserCoreKey()
//
// ─────────────────────────────────────────────────────────────
// 【第四步】自定义模型（Codable）
// ─────────────────────────────────────────────────────────────
//
//   // 1. 模型遵循 Codable
//   struct UserProfile: Codable {
//       var name: String
//       var level: Int
//   }
//
//   // 2. 在 Extern 文件中用计算属性封装（无需 @NSManaged，直接用 codable 扩展）
//   extension HUserCore {
//       var profile: UserProfile? {
//           get { codable(forKey: "profile") }
//           set { setCodable(newValue, forKey: "profile") }
//       }
//   }
//
//   // 3. 读写方式与普通字段完全一致
//   HUserDefaults.user.profile = UserProfile(name: "张三", level: 5)
//   let name = HUserDefaults.user.profile?.name
//   HUserDefaults.user.profile = nil               // 删除
//
// ─────────────────────────────────────────────────────────────
// 【支持的字段类型】
// ─────────────────────────────────────────────────────────────
//
//   Bool / Int / Float / Double          → 基础值类型
//   String / String? / Data / Data?      → 对象类型（@"..." encoding）
//   Any / Any? / Array / Dictionary      → 容器类型
//   任意 Codable 模型                    → 通过计算属性 + codable<T> 扩展存取
//

// User Defaults Key
private var kUserKey = "ud_user_id"
private var kDefaultsKey = "ud_defaults_id"

class HUserDefaults: NSObject {

    // MARK: - Standard Defaults（全局应用设置）
    static let defaults: HDefaultsCore = HDefaultsCore()

    // MARK: - User Defaults（用户维度隔离存储）
    private static var _user: HUserCore?
    /// Protects lazy init of _user from concurrent access.
    private static let userLock = NSLock()

    static var user: HUserCore {
        userLock.lock(); defer { userLock.unlock() }
        if _user == nil {
            _user = HUserCore(userSuiteName: userCoreKey)
        }
        return _user!
    }

    // MARK: - User Core Key
    private static var userCoreKey: String {
        return HUserDefaults.defaults.string(forKey: kDefaultsKey) ?? kUserKey
    }

    /// 用户登录时调用，传入用于隔离存储的唯一标识（如 userId）。
    /// - Parameter key: 用作 UserDefaults suiteName 的字符串，建议使用 userId。
    static func setUserCoreKey(_ key: String) {
        clearUserCoreKey()
        HUserDefaults.defaults.isUserLogin = true
        HUserDefaults.defaults.set(key, forKey: kDefaultsKey)
        // synchronize() is no longer needed on iOS 12+; the system handles persistence automatically.
    }

    /// 用户退出时调用，清除用户域数据并重置登录状态。
    static func clearUserCoreKey() {
        HUserDefaults.defaults.isUserLogin = false
        HUserDefaults.defaults.removeObject(forKey: kDefaultsKey)
        // synchronize() is no longer needed on iOS 12+; the system handles persistence automatically.
        userLock.lock()
        _user = nil
        userLock.unlock()
    }
}
