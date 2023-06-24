//
//  HFileCache.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

//deal the notification
var HFileCacheClearNotification = "HFileCacheClearNotification"

private var HFileDomain = "HFileCache"
private var HFileInfoFileSuffix = ".hcache.info"
private var HFileExpireTimeKey = FileAttributeKey.modificationDate

class HFileCacheFileInfo: NSObject {
    var filePath: String?
    var lastAccess: UInt64?
    var size: Int64?
}

/**
 *  a simple file cache
 *  it has two kinds of replace strategies
 *  1. expire: once current time greater than the time, the cache itrm will be swap out
 *  2. FIFO: if the cache is full, swap out the earliest one
 *  all the strategies is triger automaticly after app is in backgroud
 */
class HFileCache: NSObject {
    var cacheDir: String = FileManager.cachePath(HFileDomain)
    //max cache size by byte, default is 50M, if set negative value then it has no size limit
    var maxCacheSize: Int = 50 * 1024 * 1024
    //file extention default is nil
    var fileExtension: String?
    var queue: DispatchQueue = DispatchQueue(label: HFileDomain, attributes: .concurrent)
    
    //singleton
    static let sharedCache: HFileCache = {
        return HFileCache()
    }()
    
    override init() {
        super.init()
        self.setup("com.hacess.HFileCache")
    }
    
    /**
     *  init with custom domain
     *  must conform to the pattern 'com.hcache.xxx' to avoid name conflict and help to clear cache
     *  param domain
     *  return
     */
    init(domain: String) {
        super.init()
        self.setup(domain)
    }
    
    /**
     *  init with custom directory path
     *  last path component must comform to the pattern 'com.hcache.xxx'，to avoid name conflict and help to clear cache
     *  @param cacheDir directory path
     *  return
     */
    init(cacheDir: String) {
        super.init()
        let domain = (cacheDir as NSString).lastPathComponent
        self.setup(domain)
    }
    
    private func setup(_ domain: String) {
        self.maxCacheSize = 50 * 1024 * 1024
        self.queue = DispatchQueue(label: domain, attributes: .concurrent)
        self.cacheDir = FileManager.cachePath(domain)
        
        try? FileManager.default.createDirectory(atPath: self.cacheDir, withIntermediateDirectories: true, attributes: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundCleanDisk), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     *  get a file cache path by key
     *
     *  @param key key
     *
     *  @return path
     */
    func cachePath(forKey key: String?) -> String? {
        guard let key = key else {
            return nil
        }
        if var fileName = key.md5() {
            if let fileExtension = self.fileExtension {
                fileName = fileName.appendingFormat(".%@", fileExtension)
            }
            return self.cacheDir.appending("/").appending(fileName)
        }
        return nil
    }

    /**
     *  directly set expire time to a cached file, if exist
     *
     *  @param expire time, once current time greater than the time, the cache file will be deleted, set nil means never expire
     *
     *  param filePath
     */
    func setExpire(_ expire: Date?, forFilePath filePath: String?) {
        guard let expire = expire else {
            return
        }
        self.queue.sync {
            self._setExpire(expire, forFilePath: filePath)
        }
    }
    
    private func _setExpire(_ expire: Date, forFilePath filePath: String?) {
        guard let filePath = filePath else {
            return
        }
        try? FileManager.default.setAttributes([.modificationDate: expire], ofItemAtPath: filePath)
    }
    
    /**
     *  directly set access time to a cache file, if exsit
     *
     *  param //accessDate: last read/write time, if the cache is over size, it will clear data whose access time is earliest
     *
     *  param filePath
     */
    func setAccessDate(_ accessDate: Date?, forFilePath filePath: String) {
        guard let accessDate = accessDate else {
            return
        }
        self.queue.sync {
            self._setAccessDate(accessDate, forFilePath: filePath)
        }
    }
    
    private func _setAccessDate(_ accessDate: Date, forFilePath filePath: String) {
        let dateString = String(format: "%.2f", accessDate.timeIntervalSince1970)
        let accessFilePath = filePath + HFileInfoFileSuffix
        try? FileManager.default.removeItem(atPath: accessFilePath)
        try? dateString.write(toFile: accessFilePath, atomically: true, encoding: .utf8)
    }
    
    private func _getAccessDate(forFilePath filePath: String) -> TimeInterval {
        let accessFilePath = filePath + HFileInfoFileSuffix
        let dateString = try? String(contentsOfFile: accessFilePath, encoding: .utf8)
        if let dateString = dateString {
            return TimeInterval(Double(dateString) ?? 0)
        }
        return 0
    }
    
    /**
     *  save cache data
     *
     *  param data
     *  param key
     */
    func setData(_ data: Data, forKey key: String) {
        setData(data, forKey: key, expire: nil)
    }
    
    /**
     *  save cache data
     *
     *  param data
     *  param key
     *  param expire: expire time, once current time greater than the time, the cache file will be deleted, set nil means never expire
     */
    func setData(_ data: Data, forKey key: String, expire: Date?) {
        if data.isEmpty || key.isEmpty { return }
        queue.async(flags: DispatchWorkItemFlags.barrier) {
            let filePath = self.cachePath(forKey: key) ?? ""
            try? data.write(to: URL(fileURLWithPath: filePath))
            if let expire = expire {
                self._setExpire(expire, forFilePath: filePath)
            } else {
                self._setExpire(Date(timeIntervalSince1970: 0), forFilePath: filePath)
            }
            self._setAccessDate(Date(), forFilePath: filePath)
        }
    }
    
    /**
     *  move file to cache from other place
     *
     *  param data
     *  param key
     *  param expire: expire time, once current time greater than the time, the cache file will be deleted, set nil means never expire
     */
    func moveIntoFileItem(_ itemPath: String, forKey key: String, expire: Date?) {
        if itemPath.isEmpty || key.isEmpty { return }
        queue.async(flags: DispatchWorkItemFlags.barrier) {
            let filePath = self.cachePath(forKey: key) ?? ""
            try? FileManager.default.moveItem(atPath: itemPath, toPath: filePath)
            if let expire = expire {
                self._setExpire(expire, forFilePath: filePath)
            } else {
                self._setExpire(Date(timeIntervalSince1970: 0), forFilePath: filePath)
            }
            self._setAccessDate(Date(), forFilePath: filePath)
        }
    }
    
    /**
     *  get cached data by key
     *
     *  @param key key
     */
    func data(forKey key: String) -> Data? {
        return data(forKey: key, concurrent: true)
    }
    
    /**
     *  get cached data by key
     *
     *  @param key        key
     *  @param concurrent concurrent or SERIAL
     */
    func data(forKey key: String, concurrent: Bool) -> Data? {
        if key.isEmpty { return nil }
        var data: Data?
        if concurrent {
            queue.sync() {
                let filePath = self.cachePath(forKey: key) ?? ""
                data = NSData(contentsOfFile: filePath) as Data?
                if data != nil { self._setAccessDate(NSDate() as Date, forFilePath: filePath) }
            }
        } else {
            queue.sync(flags: .barrier) {
                let filePath = self.cachePath(forKey: key) ?? ""
                data = NSData(contentsOfFile: filePath) as Data?
                if data != nil { self._setAccessDate(NSDate() as Date, forFilePath: filePath) }
            }
        }
        return data
    }

    /**
     *  is cache exsit
     *  @param key key
     *  return
     */
    func cacheExsitForKey(_ key: String) -> Bool {
        return cacheExsitForKey(key, concurrent: true)
    }

    /**
     *  is cache exsit
     *  @param key key
     *  @param concurrent concurrent or SERIAL
     */
    func cacheExsitForKey(_ key: String, concurrent: Bool) -> Bool {
        if key.isEmpty { return false }
        var res = false
        if concurrent {
            queue.sync() {
                var isDir: ObjCBool = false
                res = FileManager.default.fileExists(atPath: self.cachePath(forKey: key) ?? "", isDirectory: &isDir)
            }
        } else {
            queue.sync(flags: .barrier) {
                var isDir: ObjCBool = false
                res = FileManager.default.fileExists(atPath: self.cachePath(forKey: key) ?? "", isDirectory: &isDir)
            }
        }
        return res
    }

    /**
     *  get cache size
     *
     *  @return size
     */
    func getSize() -> Int64 {
        var size: Int64 = 0
        queue.sync() {
            size = self._getSize()
        }
        return size
    }

    private func _getSize() -> Int64 {
        var size: Int64 = 0
        let fileEnumerator = FileManager.default.enumerator(atPath: cacheDir)
        while let fileName = fileEnumerator?.nextObject() as? String {
            let filePath = cacheDir.appending("/").appending(fileName)
            if let attrs = try? FileManager.default.attributesOfItem(atPath: filePath) {
                size += attrs[FileAttributeKey.size] as! Int64
            }
        }
        return size
    }

    @objc
    private func backgroundCleanDisk() {
        let UIApplicationClass: AnyClass? = NSClassFromString("UIApplication")
        if UIApplicationClass == nil || !(UIApplicationClass?.responds(to: #selector(getter: UIApplication.shared)))! {
            return
        }
        let application = UIApplication.shared
        var bgTask = UIBackgroundTaskIdentifier.invalid
        bgTask = application.beginBackgroundTask(withName: nil, expirationHandler: nil)
        clearExpire(finish: {
            application.endBackgroundTask(bgTask)
            bgTask = UIBackgroundTaskIdentifier.invalid
        })
    }

    /**
     *  delete file cache by key
     *
     *  param key
     */
    func removeFile(forKey key: String) {
        queue.sync(flags: .barrier) {
            let filePath = cachePath(forKey: key) ?? ""
            try? FileManager.default.removeItem(atPath: filePath)
            try? FileManager.default.removeItem(atPath: filePath.appending(HFileInfoFileSuffix))
        }
    }

    func handleClearNotification(_ notification: Notification) {
        
    }

    /**
     *  clear
     *
     *  param finish
     */
    func clearExpire(finish: (() -> Void)?) {
        queue.async(flags: DispatchWorkItemFlags.barrier) {
            let now = Date()
            let fileManager = FileManager.default
            let files = try? fileManager.contentsOfDirectory(atPath: self.cacheDir)
            for fileName in files! {
                if fileName.hasSuffix(HFileInfoFileSuffix) {
                    continue
                }
                let filePath = self.cacheDir.appending("/").appending(fileName)
                let attrs = try? fileManager.attributesOfItem(atPath: filePath)
                var shouldDelete = false
                if attrs == nil {
                    shouldDelete = true
                } else {
                    let expire = attrs?[HFileExpireTimeKey] as? Date
                    let created = attrs?[FileAttributeKey.creationDate] as? Date
                    let createdLongLong = Int64(created!.timeIntervalSince1970)
                    let expireLongLong = Int64(expire!.timeIntervalSince1970)
                    let nowLongLong = Int64(now.timeIntervalSince1970)
                    if createdLongLong <= expireLongLong && expireLongLong <= createdLongLong + 60 {
                        continue
                    }
                    if expire == nil {
                        shouldDelete = true
                    } else if expireLongLong <= 0 {
                        continue
                    } else {
                        if expireLongLong < nowLongLong - 60 {
                            shouldDelete = true
                        }
                    }
                }
                if shouldDelete {
                    try? fileManager.removeItem(atPath: filePath)
                    try? fileManager.removeItem(atPath: filePath.appending(HFileInfoFileSuffix))
                }
            }
            if self.maxCacheSize < 0 {
                finish?()
                return
            }
            var cacheSize = self._getSize()
            if cacheSize > self.maxCacheSize {
                var fileInfos = [HFileCacheFileInfo]()
                for fileName in files! {
                    if fileName.hasSuffix(HFileInfoFileSuffix) {
                        continue
                    }
                    let filePath = self.cacheDir.appending("/").appending(fileName)
                    let attrs = try? fileManager.attributesOfItem(atPath: filePath)
                    let fileInfo = HFileCacheFileInfo()
                    fileInfo.filePath = filePath
                    fileInfo.lastAccess = UInt64(self._getAccessDate(forFilePath: filePath))
                    fileInfo.size = attrs?[FileAttributeKey.size] as? Int64
                    fileInfos.append(fileInfo)
                }
                fileInfos.sort { (obj1, obj2) -> Bool in
                    if obj1.lastAccess! < obj2.lastAccess! {
                        return true
                    } else if obj1.lastAccess! > obj2.lastAccess! {
                        return false
                    } else {
                        return true
                    }
                }
                for fileInfo in fileInfos {
                    try? fileManager.removeItem(atPath: fileInfo.filePath!)
                    try? fileManager.removeItem(atPath: fileInfo.filePath!.appending(HFileInfoFileSuffix))
                    cacheSize -= fileInfo.size!
                    if cacheSize < self.maxCacheSize {
                        break
                    }
                }
            }
            
            finish?()
        }
    }
    
    /**
     *  clear all
     *
     *  param finish
     */
    func clearAll(finish: (() -> Void)?) {
        self.queue.async(flags: .barrier, execute: {
            try? FileManager.default.removeItem(atPath: self.cacheDir)
            try? FileManager.default.createDirectory(atPath: self.cacheDir, withIntermediateDirectories: true, attributes: nil)
            finish?()
        })
    }
    
}


