//
//  jfjjfjfjjfjfj.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HAnimatedImageView: UIImageView {
    //MARK： 工程內gif
    public func startGifWithImageName(name:String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print ("SwiftGif: Source for the image does not exist")
            return
        }
        self.startGifwithFilePath(filePath: path)
    }
    //MARK：实现动图效果
    public func startGifwithFilePath(filePath: String) {
        //1.加载GIF图片，并转化为data类型
        guard let data = NSData(contentsOfFile: filePath) else { return }
        //2.从data中读取数据，转换为CGImageSource
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        //3.遍历所有图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0...imageCount {
        
            //3.1取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            //3.2取出持续时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        
        //4.设置imageview的属性
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 0
        
        //5.开始播放
        self.startAnimating ()
    }
    public func imageStopAnimating() {
        self.stopAnimating()
    }
}
