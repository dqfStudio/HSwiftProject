//
//  jfjjfjfjjfjfj.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/9.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HAnimatedImageView: UIImageView {
    // gif in project
    func startGifWithImageName(name:String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print ("SwiftGif: Source for the image does not exist")
            return
        }
        self.startGifwithFilePath(filePath: path)
    }
    // implement gif effect
    func startGifwithFilePath(filePath: String) {
        //1. Load GIF image and convert to data type
        guard let data = NSData(contentsOfFile: filePath) else { return }
        //2. Read data from data and convert to CGImageSource
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        //3. Traverse all images
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0...imageCount {

            //3.1 Take out the image
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            images.append(image)

            //3.2 Take out the duration
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }

        //4. Set the properties of the imageview
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 0

        //5. Start playing
        self.startAnimating ()
    }
    func imageStopAnimating() {
        self.stopAnimating()
    }
}
