//
//  NSFileManager+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var IS_IOS8_OR_HIGHER = (UIDevice.current.systemVersion as NSString).floatValue >= 8.0

extension FileManager {
    // sandbox path /Documents/
    static func documentPath(_ subPath: String?) -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if let subPath = subPath {
            return dir + "/" + subPath
        } else {
            return dir
        }
    }
    // sandbox path /Library/Caches/
    static func cachePath(_ subPath: String?) -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        if let subPath = subPath {
            return dir + "/" + subPath
        } else {
            return dir
        }
    }
    // sandbox path /Library/
    static func libPath(_ subPath: String?) -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        if let subPath = subPath {
            return dir + "/" + subPath
        } else {
            return dir
        }
    }
    // sandbox path /tmp/
    static func tempPath(_ subPath: String?) -> String {
        let dir = NSTemporaryDirectory()
        if let subPath = subPath {
            return dir + subPath
        } else {
            return dir
        }
    }
    // group path
    static func sharePath(_ subPath: String?, appGroup: String?) -> String {
        if IS_IOS8_OR_HIGHER {
            let dirURL: URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup ?? "")
            let dir = dirURL?.path ?? ""
            if let subPath = subPath {
                return dir + "/" + subPath
            } else {
                return dir
            }
        } else {
            return libPath(subPath)
        }
    }
    //atomistic copy
    func copyItemAtPath(srcPath: String, toPath dstPath: String, atomically: Bool, isOverwrite overwrite: Bool, error: NSErrorPointer) -> Bool {
        if srcPath.isEmpty || dstPath.isEmpty {
            return false
        }

        if !atomically {
            do {
                try self.copyItem(atPath: srcPath, toPath: dstPath)
                return true
            } catch {
                print("Error: \(error)")
                return false
            }
        }
        let dstPathTemp = dstPath + ".temp"
        //1.delete tmp file/dir
        do {
            try self.removeItem(atPath: dstPathTemp)
        } catch {
            print("Error: \(error)")
            return false
        }
        //2.copy to tmp file/dir
        do {
            try self.copyItem(atPath: srcPath, toPath: dstPath)
        } catch {
            print("Error: \(error)")
            do {
                try self.removeItem(atPath: dstPathTemp)
            } catch {
                print("Error: \(error)")
                return false
            }
            return false
        }
        //3.rename
        if overwrite {
            if self.fileExists(atPath: dstPath) {
                do {
                    try self.moveItem(atPath: dstPath, toPath: dstPath)
                } catch {
                    print("Error: \(error)")
                    return false
                }
            }
        }

        do {
            try self.moveItem(atPath: dstPathTemp, toPath: dstPath)
        } catch {
            print("Error: \(error)")
            return false
        }
        return true
    }
    //atomistic copy
    func copyItemAtPath(srcPath: String, toPath dstPath: String, atomically: Bool) -> Bool {
        if !atomically {
            do {
                try self.copyItem(atPath: srcPath, toPath: dstPath)
                return true
            } catch {
                print("Error: \(error)")
                return false
            }
        }
        let dstPathTemp = dstPath + ".temp"
        //1.delete tmp file/dir
        do {
            try self.removeItem(atPath: dstPathTemp)
        } catch {
            print("Error: \(error)")
            return false
        }
        //2.copy to tmp file/dir
        do {
            try self.copyItem(atPath: srcPath, toPath: dstPath)
        } catch {
            print("Error: \(error)")
            do {
                try self.removeItem(atPath: dstPathTemp)
            } catch {
                print("Error: \(error)")
                return false
            }
            return false
        }
        //3.rename
        do {
            try self.moveItem(atPath: dstPathTemp, toPath: dstPath)
        } catch {
            print("Error: \(error)")
            return false
        }
        return true
    }
    //atomistic copy
    func copyItemAtURL(srcURL: URL, toURL dstURL: URL, atomically: Bool) -> Bool {
        if !atomically {
            do {
                try self.copyItem(at: srcURL, to: dstURL)
                return true
            } catch {
                print("Error: \(error)")
                return false
            }
        }
        let dstURLTemp = dstURL.appendingPathExtension(".temp")
        //1.delete tmp file/dir
        do {
            try self.removeItem(at: dstURLTemp)
        } catch {
            print("Error: \(error)")
            return false
        }
        //2.copy to tmp file/dir
        do {
            try self.copyItem(at: srcURL, to: dstURLTemp)
        } catch {
            print("Error: \(error)")
            do {
                try self.removeItem(at: dstURLTemp)
            } catch {
                print("Error: \(error)")
                return false
            }
            return false
        }
        //3.rename
        do {
            try self.moveItem(at: dstURLTemp, to: dstURL)
        } catch {
            print("Error: \(error)")
            return false
        }
        return true
    }
    //don't backup this file
    func skipBackupAttributeToItemAtFilePath(filePath: String) -> Bool {
        if filePath.isEmpty {
            assertionFailure("filePath is empty")
            return false
        }
        var URL: NSURL
        if filePath.hasPrefix("file://") {
            URL = NSURL(string: filePath)!
        }else {
            URL = NSURL(fileURLWithPath: filePath)
        }
        let isExist = FileManager.default.fileExists(atPath: URL.path!)
        if isExist {
            var error: NSError?
            do {
                try URL.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
                return true
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil {
                NSLog("error_happened %@", error!)
            }

            return false
        }else {
            assertionFailure("File not found: \(filePath)")
            NSLog("没有找到文件:%@", filePath)
            return false
        }
    }
    
}
