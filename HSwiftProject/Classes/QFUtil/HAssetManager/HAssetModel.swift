//
//  HAssetModel.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/22.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import AVFoundation

enum HAssetType: Int {
    case photo = 1
    case video = 2
}

class HAssetModel: NSObject {
    
    /** asset的类别 */
    var assetType: HAssetType = .photo
    
    /** asset的标识 */
    var localIdentifier: String?
    
    /**
     assetType == photo, imagew为照片;
     assetType == video, imagew为视频的缩略图;
     */
    var image: UIImage?
    
    /**
     assetType == photo, avAsset为空;
     assetType == video, avAsset为本地相册的视频
     你可以这样使用 AVAsset: [[AVPlayer alloc] initWithPlayerItem: [AVPlayerItem playerItemWithAsset:avAsset]]
     */
    var avAsset: AVAsset?
}
