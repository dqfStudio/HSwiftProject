//
//  HUserInfoMngr.swift
//  HSwiftProject
//
//  Created by owner on 2024/11/9.
//  Copyright © 2024 wind. All rights reserved.
//

import GRDB

class HUserInfoMngr: NSObject {

    func getUserInfo(_ userID: String,
                     success: @escaping (_ userInfo: HUserInfo) -> Void,
                     failure: @escaping (_ error: HNetworkError) -> Void) {
        guard let userInfo = HUserInfo.query(userID: userID) else {
            self.updateUserInfo(userID, success: success, failure: failure)
            return
        }
        success(userInfo)
    }
    
    func updateUserInfo(_ userID: String,
                        success: @escaping (_ userInfo: HUserInfo) -> Void,
                        failure: @escaping (_ error: HNetworkError) -> Void) {
        HUserLoginRequest.loadData(userID: userID) { userInfo in
            if let userInfo = userInfo {
                HUserInfo.update(item: userInfo)
                success(userInfo)
            }else {
                let error = NSError(domain: "", code: 1, userInfo: nil)
                failure(HNetworkError.requestError(with: error))
            }
        } failure: { error in
            failure(error)
        }
    }
}

struct HUserInfo: Codable, Equatable {
    var userID: String = "" //用户ID
    var dayActive: Int?
    var weekActive: Int?
    var monthActive: Int?
    
//    public static func == (lhs: HUserInfo, rhs: HUserInfo) -> Bool {
//        lhs.userID == rhs.userID
//    }
    
    // db
    private enum Columns: String, CodingKey, ColumnExpression {
        case userID
        case dayActive
        case weekActive
        case monthActive
    }
}

// MARK: - GRDB
extension HUserInfo: MutablePersistableRecord, FetchableRecord {
    // 获取数据库对象
    private static var dbQueue: DatabaseQueue? {
        return UserDBManager.getDBQueue()
    }
    // 数据库表名称
    private static func tableName() -> String {
        return TableName.kUserInfo
    }
    
    // MARK: - 创建
    /// 创建数据库
    private static func createTable() {
        try! self.dbQueue?.inDatabase { (db) -> Void in
            //判断是否存在数据库
            if try db.tableExists(self.tableName()) { return }
            //创建数据库表
            do {
                try db.create(table: self.tableName(),
                              temporary: false,
                              ifNotExists: true,
                              body: { t in
                    t.column(Columns.userID.rawValue, Database.ColumnType.text).primaryKey()//配置为主键
                    t.column(Columns.dayActive.rawValue, Database.ColumnType.integer)
                    t.column(Columns.weekActive.rawValue, Database.ColumnType.integer)
                    t.column(Columns.monthActive.rawValue, Database.ColumnType.integer)
                })
            } catch {
                NSLog(error)
            }
        }
    }
    
    // MARK: - 插入
    /// 插入单个数据
    static func insert(item: HUserInfo) {
        guard !item.userID.isEmpty else { return }
        guard let dbQ = self.dbQueue else { return }
        // 判断是否存在
        guard HUserInfo.query(userID: item.userID) == nil else {
            self.update(item: item)// 更新
            return
        }
        // 创建表
        self.createTable()
        // 事务
        try? dbQ.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                try db.execute(
                    sql: "INSERT INTO '\(self.tableName())' (userID, dayActive, weekActive, monthActive) VALUES (?, ?, ?, ?)",
                    arguments: [item.userID, item.dayActive, item.weekActive, item.monthActive])
                return Database.TransactionCompletion.commit
            } catch {
                NSLog(error)
                return Database.TransactionCompletion.rollback
            }
        }
    }
    
    // MARK: - 查询
    /// 查询一条记录
    /// - Parameter userID: id
    /// - Returns: 单条数据
    static func query(userID: String?) -> HUserInfo? {
        guard let userID = userID else { return nil }
        // 返回查询结果
        return self.dbQueue?.unsafeRead({ (db) -> HUserInfo? in
            do {
                let table = Table<HUserInfo>(self.tableName())
                return try table.filter(Column("userID") == userID).fetchOne(db)
            } catch {
                NSLog(error)
            }
            return nil
        })
        
    }
    
    // MARK: - 更新
    /// 更新
    static func update(item: HUserInfo) {
        guard !item.userID.isEmpty else { return }
        guard let dbQ = self.dbQueue else { return }
        // 事务 更新场景
        try? dbQ.inTransaction { (db) -> Database.TransactionCompletion in
            do {
                let table = Table(self.tableName())
                try table.filter(Column("userID") == item.userID)
                    .updateAll(db,
                               Column("dayActive").set(to: item.dayActive),
                               Column("weekActive").set(to: item.weekActive),
                               Column("monthActive").set(to: item.monthActive))
                return Database.TransactionCompletion.commit
            } catch {
                print(error)
                return Database.TransactionCompletion.rollback
            }
        }
    }
    static func update(userID: String, dayActive: Int?) {
        guard let dayActive = dayActive else { return }
        guard var item = HUserInfo.query(userID: userID) else { return }
        item.dayActive = dayActive
        self.update(item: item)
    }
    
    // MARK: - 删除
    /// 根据用户ID删除对应表中的item
    static func delete(userID: String) {
        guard let dbQ = self.dbQueue else { return }
        // 查询
        guard let _ = self.query(userID: userID) else { return }
        try? dbQ.write { db in
            do {
                try db.execute(sql: "DELETE FROM \(self.tableName()) WHERE userID = '\(userID)'")
            } catch {
                print(error)
            }
        }
    }
    
    /// 新增字段
    /// type: INTEGER  BLOB
    static func addColumn(key: String, dataType: String) {
        guard let dbQ = self.dbQueue else { return }
        try? dbQ.write { db in
            do {
                if try db.tableExists(self.tableName()) {
                    try db.execute(sql: "ALTER TABLE \(self.tableName()) ADD COLUMN \(key) \(dataType)")
                }
            } catch {
                print(error)
            }
        }
    }
}
