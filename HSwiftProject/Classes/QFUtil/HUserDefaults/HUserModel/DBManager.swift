//
//  DBManager.swift
//  HSwiftProject
//
//  Created by owner on 2024/11/9.
//  Copyright © 2024 wind. All rights reserved.
//

import GRDB

/// 数据库表名
struct TableName {
    static let addressbook = "FCWalletAddrBookItem_"
    static let TransNomalRecord = "TransNomalRecord_"
    static let TransERC20Record = "TransERC20Record_"
    static let systemContacts = "SystemContacts_" //系统通讯录
    static let messageTranslate = "MessageTranslate_1"
    
    //im table
    static let chatMessageLogs = "chat_message_logs"
    static let kGroupInfoListKey = "group_Info_list"
    static let kGroupMembers = "group_members_"
    static let kUserInfo = "user_info"
    
    //audio path
    static let audioCathcPath = "freechat_audio_catch_path"
}

class DBManager: NSObject {
    /// 数据库路径
    private static var dbPath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/freechat.db")
    
    /// 配置数据库
    private static var configuration: Configuration = {
        var config = Configuration()
        // 设置超时
        config.busyMode = Database.BusyMode.timeout(5.0)
        // 试图访问锁着的数据
//        config.busyMode = Database.BusyMode.immediateError
        return config
    }()
    
    // MARK: - 创建数据库
    /// 用户多线程事务处理
    static var dbQueue: DatabaseQueue = {
        // 创建数据库
        let db = try! DatabaseQueue(path: DBManager.dbPath, configuration: DBManager.configuration)
        db.releaseMemory()
        // 设备版本
        return db
    }()
}

// MARK: - IM DB
class UserDBManager {
    /// 数据库路径
    static func dbPath() -> String? {
//        guard !IMController.shared.uid.isEmpty else { return nil }
//        let dbName = "FCC_\(IMController.shared.uid).db"
        let dbName = "FCC_张三.db"
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/\(dbName)")
    }
    
    /// 配置数据库
    private static var configuration: Configuration = {
        var config = Configuration()
        // 设置超时
        config.busyMode = Database.BusyMode.timeout(5.0)
        // 试图访问锁着的数据
//        config.busyMode = Database.BusyMode.immediateError
        return config
    }()
    
    // MARK: - 创建数据库
    /// 用户多线程事务处理
    static var dbQueue: DatabaseQueue?
    static func getDBQueue() -> DatabaseQueue? {
        if let dbQueue = dbQueue {
            return dbQueue
        } else {
            guard let dbPath = UserDBManager.dbPath() else { return nil }
            // 创建数据库
            let db = try! DatabaseQueue(path: dbPath, configuration: UserDBManager.configuration)
            db.releaseMemory()
            dbQueue = db
            return db
        }
    }
}
