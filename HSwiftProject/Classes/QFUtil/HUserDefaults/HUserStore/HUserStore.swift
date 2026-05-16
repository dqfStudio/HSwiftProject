//
//  HUserStore.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/28.
//  Copyright © 2019 wind. All rights reserved.
//
//  HUserStore is responsible for persisting SENSITIVE user credentials to Keychain.
//  Non-sensitive user data (profile info, preferences) should live in HUserCore (UserDefaults).
//
//  Persistence flow:
//    Login  → isLogin = true  → saveUser()   → Keychain.set(JSON, forKey: userId)
//    Logout → isLogin = false → removeUser() → Keychain.delete + resetFields()
//    Launch → HUserStore.defaults → tries to restore from Keychain, restores isLogin = true if found
//
//  Why Codable instead of NSCoding + Mirror:
//    • Type-safe: compiler catches field renames / deletions at compile time
//    • No KVC: Bool/Int fields survive encode/decode correctly (no decodeObject pitfall)
//    • JSON payload is human-readable during debugging
//    • Eliminates requiringSecureCoding:false risk
//    • isLogin excluded from CodingKeys → restore never triggers didSet side-effects
//
// ─────────────────────────────────────────────────────────────
// Usage Guide
// ─────────────────────────────────────────────────────────────
//
//  【登录】设置用户信息后再设 isLogin = true，触发自动保存
//
//    HUserStore.defaults.userId   = "u_123"
//    HUserStore.defaults.userName = "张三"
//    HUserStore.defaults.password = "secret"
//    HUserStore.defaults.isLogin  = true      // → saveUser() 写入 Keychain
//
//  【读取】
//
//    let uid  = HUserStore.defaults.userId     // Optional<String>
//    let name = HUserStore.defaults.userName
//    let loggedIn = HUserStore.defaults.isLogin
//
//  【退出登录】
//
//    HUserStore.defaults.isLogin = false       // → removeUser() 删除 Keychain + 字段置 nil
//
//  【App 启动自动恢复】
//
//    // HUserStore.defaults 在首次访问时自动尝试从 Keychain 恢复。
//    // 恢复成功时 isLogin 自动置为 true，无需手动判断。
//    if HUserStore.defaults.isLogin {
//        // 用户已登录，直接进入主页
//    }
//
//  【新增持久化字段】
//
//    // 1. 在 Fields 区添加属性
//    var avatar: String?
//    // 2. 在 CodingKeys 里同步添加（否则该字段不会被保存）
//    case avatar

import UIKit

// MARK: - Constants

/// Keychain key that records the currently active userId,
/// so the correct user record can be restored on next launch.
private let kUserIndexKey = "H_USER_DEFAULTS"

// MARK: - HUserStore

class HUserStore: NSObject, Codable {

    // MARK: - Fields

    // NOTE: isLogin is intentionally excluded from Codable (see CodingKeys).
    // It is a runtime-only flag; persisting it would cause removeUser() to fire
    // silently the next time the store is restored from Keychain.

    /// Runtime login flag. Not persisted to Keychain.
    /// Setting to true  → saveUser()   (writes JSON to Keychain)
    /// Setting to false → removeUser() (deletes Keychain entry + resets fields)
    var isLogin: Bool = false {
        didSet {
            guard isLogin != oldValue else { return }
            isLogin ? saveUser() : removeUser()
        }
    }

    /// Unique identifier for this user. Also used as the Keychain storage key.
    var userId: String?

    /// Display name.
    var userName: String?

    /// Sensitive credential — stored in Keychain only, never in UserDefaults.
    var password: String?

    // MARK: - Codable

    // isLogin is intentionally excluded: it is a runtime flag, not a persisted value.
    // Persisting it would trigger didSet (saveUser/removeUser) silently on next restore.
    //
    // ⚠️ When adding a new persisted field, you MUST add it here too.
    //    Fields missing from CodingKeys will be silently ignored during encode/decode.
    private enum CodingKeys: String, CodingKey {
        case userId, userName, password
        // case newField   ← add new persisted fields here
    }

    // MARK: - Singleton

    /// Shared instance. Automatically restored from Keychain on first access.
    /// If a previous session is found, isLogin is set to true automatically.
    static let defaults: HUserStore = {
        let store: HUserStore
        if let restored = HUserStore.restore() {
            store = restored
            // Bypass didSet by using the underlying setter directly via a flag.
            // We must NOT go through isLogin = true here because saveUser() would
            // fire before the notification observer is registered (observer is added below).
            store._isLoginRestored = true
        } else {
            store = HUserStore()
        }
        store.setupNotificationObserver()
        // Now that observer is registered, reflect restored login state safely.
        if store._isLoginRestored {
            store.isLogin = true
        }
        return store
    }()

    // Internal flag used only during singleton init to avoid premature saveUser() call.
    private var _isLoginRestored = false

    // MARK: - Init

    override init() {
        super.init()
    }

    // MARK: - Keychain Persistence

    /// Tries to decode a previously saved HUserStore from Keychain.
    /// Returns nil when no record exists or the JSON is malformed.
    private static func restore() -> HUserStore? {
        guard
            let userId = HKeychainSwift.defaults.get(kUserIndexKey),
            !userId.isEmpty,
            let data = HKeychainSwift.defaults.getData(userId),
            let store = try? JSONDecoder().decode(HUserStore.self, from: data)
        else { return nil }
        return store
    }

    /// Encodes self as JSON and writes it to Keychain under userId.
    /// synchronizable must be set BEFORE the write call so that iCloud
    /// sync is applied at item-creation time (not after).
    @objc
    private func saveUser() {
        guard isLogin, let userId = userId, !userId.isEmpty else { return }
        guard let data = try? JSONEncoder().encode(self) else { return }
        HKeychainSwift.defaults.synchronizable = true   // must precede set()
        HKeychainSwift.defaults.set(data, forKey: userId)
        HKeychainSwift.defaults.set(userId, forKey: kUserIndexKey)
    }

    /// Deletes all Keychain entries for this user and resets fields to nil.
    private func removeUser() {
        HKeychainSwift.defaults.synchronizable = true   // must precede delete()
        HKeychainSwift.defaults.delete(kUserIndexKey)
        if let userId = userId {
            HKeychainSwift.defaults.delete(userId)
        }
        resetFields()
    }

    /// Resets all persisted fields to nil.
    /// Does NOT touch isLogin to avoid recursive didSet triggers.
    private func resetFields() {
        userId   = nil
        userName = nil
        password = nil
    }

    // MARK: - App Lifecycle

    private func setupNotificationObserver() {
        // willTerminate: called when user explicitly quits via app switcher
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveUser),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        // didEnterBackground: iOS may kill the app without willTerminate;
        // saving here ensures data is persisted before suspension.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveUser),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
