//
//  DBManager.swift
//  HSwiftProject
//
//  Created by owner on 2024/11/9.
//  Copyright © 2024 wind. All rights reserved.
//

import GRDB

// MARK: - TableName

/// All database table name constants in one place.
/// Suffix tables that are per-user with the userId so different accounts
/// never share rows (e.g. "FCWalletAddrBookItem_u_123").
struct TableName {
    static let addressbook        = "FCWalletAddrBookItem_"
    static let transNormalRecord  = "TransNomalRecord_"
    static let transERC20Record   = "TransERC20Record_"
    static let systemContacts     = "SystemContacts_"
    static let messageTranslate   = "MessageTranslate_1"

    // IM tables
    static let chatMessageLogs    = "chat_message_logs"
    static let groupInfoList      = "group_Info_list"
    static let groupMembers       = "group_members_"
    static let userInfo           = "user_info"

    // Audio cache
    static let audioCachePath = "freechat_audio_catch_path"
}

// MARK: - DBConfiguration (shared)

/// Shared GRDB Configuration used by all database queues in this app.
/// Centralised here so busyMode / prepareDatabase hooks stay consistent.
private func makeDBConfiguration() -> Configuration {
    var config = Configuration()
    // Wait up to 5 s when another write holds the lock before returning an error.
    config.busyMode = .timeout(5.0)
    return config
}

// MARK: - DBManager  (app-wide, user-independent data)

class DBManager: NSObject {

    // MARK: - Path

    /// Resolves the Documents directory at call-time instead of at class-load-time,
    /// and avoids the force-unwrap crash when the sandbox is unavailable.
    private static var dbPath: String? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("freechat.db")
            .path
    }

    // MARK: - Queue

    /// Shared DatabaseQueue for app-wide (non-user-specific) tables.
    /// Returns nil and logs if the database file cannot be opened.
    static let dbQueue: DatabaseQueue? = {
        guard let path = DBManager.dbPath else {
            print("[DBManager] ❌ Could not resolve Documents directory.")
            return nil
        }
        do {
            let queue = try DatabaseQueue(path: path, configuration: makeDBConfiguration())
            queue.releaseMemory()
            return queue
        } catch {
            print("[DBManager] ❌ Failed to open database at \(path): \(error)")
            return nil
        }
    }()
    
}

// MARK: - UserDBManager  (per-user data, isolated by userId)

class UserDBManager {

    // MARK: - Lock

    private static let lock = NSLock()

    // MARK: - Cached queue

    private static var _dbQueue: DatabaseQueue?

    // MARK: - Path

    /// Returns the database path for the currently active user.
    /// The userId must be set (non-empty) before calling this.
    /// Replace the hard-coded fallback with your real userId source, e.g.:
    ///   IMController.shared.uid
    static func dbPath(for userId: String) -> String? {
        guard !userId.isEmpty else { return nil }
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("FCC_\(userId).db")
            .path
    }

    // MARK: - Queue (thread-safe lazy init)

    /// Returns the DatabaseQueue for the current user, creating it on first call.
    /// Thread-safe: protected by NSLock to prevent duplicate queue creation.
    ///
    /// Call `resetDBQueue()` when the user logs out or switches accounts so the
    /// next call opens a fresh database for the new userId.
    static func getDBQueue(userId: String) -> DatabaseQueue? {
        lock.lock(); defer { lock.unlock() }

        if let existing = _dbQueue { return existing }

        guard let path = dbPath(for: userId) else {
            print("[UserDBManager] ❌ Empty userId — cannot resolve database path.")
            return nil
        }
        do {
            let queue = try DatabaseQueue(path: path, configuration: makeDBConfiguration())
            queue.releaseMemory()
            _dbQueue = queue
            return queue
        } catch {
            print("[UserDBManager] ❌ Failed to open user database at \(path): \(error)")
            return nil
        }
    }

    /// Closes the current user's database queue.
    /// Must be called on logout or account switch to prevent data leakage
    /// between accounts.
    static func resetDBQueue() {
        lock.lock(); defer { lock.unlock() }
        _dbQueue = nil
    }
}
