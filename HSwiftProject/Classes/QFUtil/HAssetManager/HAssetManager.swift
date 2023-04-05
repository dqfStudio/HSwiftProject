//
//  HAssetManager.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/22.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Photos

private var KInOperationKey = "inOperation"
private var KExecutingKey = "executing"

class HAssetManager: NSObject {
    
    static var share: HAssetManager = {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied || status == .restricted {
            HAssetManager.showDeniedAlert()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .denied || status == .restricted {
                    HAssetManager.showDeniedAlert()
                }
            })
        }
        return HAssetManager()
    }()
    
    private var modelArray: [HAssetModel] = []
    var albumsName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    
    private static func showDeniedAlert() {
        UIAlertController.showAlertWithTitle("未获得照片使用权限", message: "请在iOS 设置-隐私-照片 中打开", style: .alert, cancelButtonTitle: "好的", otherButtonTitles: nil, completion: nil)
    }
    
    private func createAlbums() {
        self.exclusive(exc: KInOperationKey) {
            if !self.isExistAlbums() {
                PHPhotoLibrary.shared().performChanges({
                    self.exclusive(exc: KExecutingKey) {
                        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumsName)
                    }
                }) { (success, error) in
                    self.removeExclusive(exc: KExecutingKey)
                    self.removeExclusive(exc: KInOperationKey)
                }
            }
        }
    }
    
    func getImagesAndVideoFromFolder() -> [HAssetModel]? {
        guard checkShouldCreateAlbums() else { return nil }
        modelArray.removeAll()
        let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        var assetCollection: PHAssetCollection?
        collectonResuts.enumerateObjects { (obj, idx, stop) in
            if obj.localizedTitle == self.albumsName {
                assetCollection = obj as? PHAssetCollection
                stop.pointee = true
            }
        }
        guard let collection = assetCollection else { return nil }
        let res = PHAsset.fetchAssets(in: collection, options: nil)
        res.enumerateObjects { (obj, idx, stop) in
            let sem = DispatchSemaphore(value: 0)
            self.getAsset(with: obj, semaphore: sem)
            sem.wait()
        }
        return modelArray
    }
    
    func getAsset(with asset: PHAsset, semaphore: DispatchSemaphore) {
        if asset.mediaType == .image {
            let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true
            imageOptions.resizeMode = .exact
            imageOptions.deliveryMode = .opportunistic
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: imageOptions) { (result, info) in
                let model = HAssetModel()
                model.localIdentifier = asset.localIdentifier
                model.image = result
                model.avAsset = nil
                self.modelArray.append(model)
                semaphore.signal()
            }
        } else if asset.mediaType == .video {
            let videoRequsetOptions = PHVideoRequestOptions()
            videoRequsetOptions.deliveryMode = .automatic
            videoRequsetOptions.isNetworkAccessAllowed = false
            PHImageManager.default().requestAVAsset(forVideo: asset, options: videoRequsetOptions) { (avasset, audioMix, info) in
                let gen = AVAssetImageGenerator(asset: avasset!)
                gen.appliesPreferredTrackTransform = true
                let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
                var actualTime = CMTime()
                var image: CGImage?
                do {
                    image = try gen.copyCGImage(at: time, actualTime: &actualTime)
                } catch {
                    print(error)
                }
                let shotImage = UIImage(cgImage: image!)
                let model = HAssetModel()
                model.assetType = .video
                model.localIdentifier = asset.localIdentifier
                model.image = shotImage
                model.avAsset = avasset
                self.modelArray.append(model)
                semaphore.signal()
            }
        }
    }
    

    func saveImageToDefaultAlbum(_ image: UIImage?, completionHandler: ((Bool, Error?) -> Void)?) {
        if let _ = image {
            self.exclusive(exc: KInOperationKey) {
                PHPhotoLibrary.shared().performChanges({
                    self.exclusive(exc: KExecutingKey) {
                        PHAssetChangeRequest.creationRequestForAsset(from: image!)
                    }
                }, completionHandler: { (success, error) in
                    self.removeExclusive(exc: KExecutingKey)
                    self.removeExclusive(exc: KInOperationKey)
                    if let completionHandler = completionHandler {
                        completionHandler(success, error)
                    }
                })
            }
        } else {
            if let completionHandler = completionHandler {
                let error = NSError(domain: "HAssetOperator", code: -999, userInfo: [NSLocalizedDescriptionKey : "图片不能为空"])
                completionHandler(false, error)
            }
        }
    }

    
    func saveImage(_ image: UIImage?, completionHandler: ((Bool, Error?) -> Void)?) {
        if checkShouldCreateAlbums() {
            if image == nil {
                if let completionHandler = completionHandler {
                    let error = NSError(domain: "HAssetOperator", code: -999, userInfo: [NSLocalizedDescriptionKey : "图片不能为空"])
                    completionHandler(false, error)
                }
                return
            }
            let semaphore = DispatchSemaphore(value: 0)
            saveFile(isImage: true, image: image, videoPathURL: nil, semaphore: semaphore, completionHandler: completionHandler)
            semaphore.wait()
        }
    }
    
    func saveVideoPath(_ videoPath: String?, completionHandler: ((Bool, Error?) -> Void)?) {
        if videoPath == nil {
            if let completionHandler = completionHandler {
                let error = NSError(domain: "HAssetOperator", code: -999, userInfo: [NSLocalizedDescriptionKey : "视频路径不能为空"])
                completionHandler(false, error)
            }
            return
        }
        if FileManager.default.fileExists(atPath: videoPath!) == false {
            if let completionHandler = completionHandler {
                let error = NSError(domain: "HAssetOperator", code: -999, userInfo: [NSLocalizedDescriptionKey : "该路径下的文件不存在"])
                completionHandler(false, error)
            }
            return
        }
        saveVideoPathURL(URL(fileURLWithPath: videoPath!), completionHandler: completionHandler)
    }
    
    func saveVideoPathURL(_ videoPathURL: URL?, completionHandler: ((Bool, Error?) -> Void)?) {
        if !checkShouldCreateAlbums() {
            return
        }
        let semaphore = DispatchSemaphore(value: 0)
        saveFile(isImage: false, image: nil, videoPathURL: videoPathURL, semaphore: semaphore, completionHandler: completionHandler)
        semaphore.wait()
    }
    
    func deleteFile(with localIdentifier: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        if !checkShouldCreateAlbums() {
            return
        }
        let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        collectonResuts.enumerateObjects { (assetCollection, idx, collectionStop) in
            if assetCollection.localizedTitle == self.albumsName {
                collectionStop.pointee = true
                let assetResult = PHAsset.fetchAssets(in: assetCollection as! PHAssetCollection, options: PHFetchOptions())
                assetResult.enumerateObjects { (asset, idx, assetStop) in
                    if localIdentifier == asset.localIdentifier {
                        assetStop.pointee = true
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
                        }) { (success, error) in
                            completionHandler(success, error)
                        }
                    }
                }
            }
        }
    }
    
    func deleteAlbumsAllFile(completionHandler: ((Bool, Error?) -> Void)?) {
        guard let albumArray = HAssetManager.share.getImagesAndVideoFromFolder() else { return }
        for model in albumArray {
            HAssetManager.share.deleteFile(with: model.localIdentifier ?? "", completionHandler: { (success, error) in })
        }
        completionHandler?(true, nil)
    }
    
    func saveFile(isImage: Bool, image: UIImage?, videoPathURL: URL?, semaphore: DispatchSemaphore?, completionHandler: ((Bool, Error?) -> Void)?) {
        self.exclusive(exc: KInOperationKey) {
            let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            collectonResuts.enumerateObjects { (obj, idx, stop) in
                if let assetCollection = obj as? PHAssetCollection, assetCollection.localizedTitle == self.albumsName {
                    stop.pointee = true
                    PHPhotoLibrary.shared().performChanges({
                        self.exclusive(exc: KExecutingKey) {
                            var assetRequest: PHAssetChangeRequest
                            if isImage {
                                assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
                            } else {
                                assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoPathURL!)!
                            }
                            let collectonRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                            let placeHolder = assetRequest.placeholderForCreatedAsset
                            collectonRequest?.insertAssets([placeHolder!] as NSArray, at: IndexSet(integer: 0))
                        }
                    }, completionHandler: { (success, error) in
                        self.removeExclusive(exc: KExecutingKey)
                        self.removeExclusive(exc: KInOperationKey)
                        semaphore?.signal()
                        completionHandler?(success, error)
                    })
                }
            }
        }
    }

    func checkShouldCreateAlbums() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status != .authorized {
            return false
        } else {
            createAlbums()
        }
        return true
    }

    func isExistAlbums() -> Bool {
        let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        var isExisted = false
        collectonResuts.enumerateObjects { (obj, idx, stop) in
            if let assetCollection = obj as? PHAssetCollection, assetCollection.localizedTitle == self.albumsName {
                isExisted = true
                stop.pointee = true
            }
        }
        return isExisted
    }

    func saveGif(path: String, completion: ((Bool, Error?) -> Void)?) {
        if !FileManager.default.fileExists(atPath: path) {
            let error = NSError(domain: "QMNL", code: -99, userInfo: [NSLocalizedDescriptionKey: "path路径下文件不存在"])
            completion?(false, error)
            return
        }
        
        self.exclusive(exc: KInOperationKey) {
            let collectonResuts = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            collectonResuts.enumerateObjects { (obj, idx, stop) in
                guard let assetCollection = obj as? PHAssetCollection else { return }
                stop.pointee = true
                PHPhotoLibrary.shared().performChanges({
                    self.exclusive(exc: KExecutingKey) {
                        let url = URL(fileURLWithPath: path)
                        let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
                        
                        //请求编辑相册
                        let collectonRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                        //为Asset创建一个占位符，放到相册编辑请求中
                        let placeHolder = assetRequest?.placeholderForCreatedAsset
                        //相册中添加照片 或者 视频
                        collectonRequest?.addAssets([placeHolder] as NSFastEnumeration)
                    }
                }) { (success, error) in
                    self.removeExclusive(exc: KExecutingKey)
                    self.removeExclusive(exc: KInOperationKey)
                    completion?(success, error)
                }
            }
        }
    }

}
