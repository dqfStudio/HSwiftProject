//
//  HUserInfoMngr.swift
//  HSwiftProject
//
//  Created by owner on 2024/11/9.
//  Copyright © 2024 wind. All rights reserved.
//

import GRDB

// MARK: - HUserInfoMngr

class HUserInfoMngr: NSObject {

    /// Returns cached user info from DB if available; otherwise fetches from network and caches it.
    func getUserInfo(_ userID: String,
                     success: @escaping (_ userInfo: HUserInfo) -> Void,
                     failure: @escaping (_ error: HNetworkError) -> Void) {
        if let userInfo = HUserInfo.query(userID: userID) {
            success(userInfo)
        } else {
            updateUserInfo(userID, success: success, failure: failure)
        }
    }

    /// Fetches user info from the network and upserts it into the local DB.
    func updateUserInfo(_ userID: String,
                        success: @escaping (_ userInfo: HUserInfo) -> Void,
                        failure: @escaping (_ error: HNetworkError) -> Void) {
        HUserLoginRequest.loadData(userID: userID) { userInfo in
            if let userInfo = userInfo {
                HUserInfo.upsert(item: userInfo)
                success(userInfo)
            } else {
                let error = NSError(domain: "HUserInfoMngr", code: 1, userInfo: nil)
                failure(HNetworkError.requestError(with: error))
            }
        } failure: { error in
            failure(error)
        }
    }
}

// MARK: - HUserInfo Model

struct HUserInfo: Codable, Equatable {
    var userID: String = ""
    var dayActive: Int?
    var weekActive: Int?
    var monthActive: Int?

    // GRDB column expressions — must match the CREATE TABLE column names exactly.
    private enum Columns: String, CodingKey, ColumnExpression {
        case userID
        case dayActive
        case weekActive
        case monthActive
    }
}

// MARK: - GRDB Persistence

extension HUserInfo: MutablePersistableRecord, FetchableRecord {

    // MARK: - DB Access

    /// Returns the shared DatabaseQueue for the current user.
    /// Replace "currentUserId" with your real userId source, e.g. HUserDefaults.user.userId
    private static var dbQueue: DatabaseQueue? {
        let userId = HUserDefaults.user.userId
        return UserDBManager.getDBQueue(userId: userId)
    }

    private static let tableName = TableName.userInfo

    // MARK: - Create Table

    /// Creates the table if it does not already exist.
    /// Safe to call multiple times — guarded by ifNotExists.
    private static func createTableIfNeeded() {
        guard let dbQ = dbQueue else { return }
        do {
            try dbQ.write { db in
                guard try !db.tableExists(tableName) else { return }
                try db.create(table: tableName, ifNotExists: true) { t in
                    t.column(Columns.userID.rawValue, .text).primaryKey()
                    t.column(Columns.dayActive.rawValue, .integer)
                    t.column(Columns.weekActive.rawValue, .integer)
                    t.column(Columns.monthActive.rawValue, .integer)
                }
            }
        } catch {
            print("[HUserInfo] ❌ createTable failed: \(error)")
        }
    }

    // MARK: - Upsert (replaces separate insert + update logic)

    /// Inserts or updates a record atomically using INSERT OR REPLACE.
    /// Eliminates the TOCTOU race condition of the old query-then-insert pattern.
    static func upsert(item: HUserInfo) {
        guard !item.userID.isEmpty else { return }
        guard let dbQ = dbQueue else { return }
        createTableIfNeeded()
        do {
            try dbQ.write { db in
                // INSERT OR REPLACE: if userID already exists the old row is deleted
                // and a new one is inserted atomically — no race condition.
                try db.execute(
                    sql: """
                         INSERT OR REPLACE INTO \(tableName)
                         (userID, dayActive, weekActive, monthActive)
                         VALUES (?, ?, ?, ?)
                         """,
                    arguments: [item.userID, item.dayActive, item.weekActive, item.monthActive]
                )
            }
        } catch {
            print("[HUserInfo] ❌ upsert failed: \(error)")
        }
    }

    // Kept for API compatibility — delegates to upsert.
    static func insert(item: HUserInfo) { upsert(item: item) }
    static func update(item: HUserInfo) { upsert(item: item) }

    // MARK: - Query

    /// Fetches a single record by userID.
    /// Uses `read` (thread-safe) instead of `unsafeRead`.
    static func query(userID: String?) -> HUserInfo? {
        guard let userID = userID, !userID.isEmpty else { return nil }
        guard let dbQ = dbQueue else { return nil }
        do {
            return try dbQ.read { db in
                let table = Table<HUserInfo>(tableName)
                return try table.filter(Column(Columns.userID.rawValue) == userID).fetchOne(db)
            }
        } catch {
            print("[HUserInfo] ❌ query failed: \(error)")
            return nil
        }
    }

    // MARK: - Update single field

    static func update(userID: String, dayActive: Int?) {
        guard let dayActive = dayActive else { return }
        guard var item = query(userID: userID) else { return }
        item.dayActive = dayActive
        upsert(item: item)
    }

    // MARK: - Delete

    /// Deletes the record for the given userID using a parameterised query (no SQL injection).
    static func delete(userID: String) {
        guard !userID.isEmpty else { return }
        guard let dbQ = dbQueue else { return }
        do {
            try dbQ.write { db in
                // ✅ Parameterised — userID is never interpolated into the SQL string.
                try db.execute(
                    sql: "DELETE FROM \(tableName) WHERE userID = ?",
                    arguments: [userID]
                )
            }
        } catch {
            print("[HUserInfo] ❌ delete failed: \(error)")
        }
    }

    // MARK: - Schema Migration

    /// Adds a new column to the table if it does not already exist.
    /// - Parameters:
    ///   - key: Column name. Must be a known safe identifier — do NOT pass user-controlled input.
    ///   - dataType: SQLite type keyword, e.g. "INTEGER", "TEXT", "BLOB".
    static func addColumn(key: String, dataType: String) {
        guard let dbQ = dbQueue else { return }
        // Note: SQLite does not support parameterised DDL statements,
        // so key and dataType are interpolated. Only call this with
        // compile-time constants — never with user-supplied strings.
        do {
            try dbQ.write { db in
                guard try db.tableExists(tableName) else { return }
                // Check column existence to avoid duplicate-column error.
                let columns = try db.columns(in: tableName).map { $0.name }
                guard !columns.contains(key) else { return }
                try db.execute(sql: "ALTER TABLE \(tableName) ADD COLUMN \(key) \(dataType)")
            }
        } catch {
            print("[HUserInfo] ❌ addColumn('\(key)') failed: \(error)")
        }
    }
}
