//
//  UIImage+Wechat.swift
//  FreeChat
//
//  Created by owner on 2024/6/12.
//

import UIKit

extension UIImage {

    func wcSessionCompress() -> UIImage {
        return wcCompres(isSession: true)
    }

    func wcTimelineCompress() -> UIImage {
        return wcCompres(isSession: false)
    }

    /**
     wechat image compress
     
     - Parameter isSession: session image boundary is 800, timeline is 1280
     
     - Returns: thumb image
     */
    func wcCompres(isSession: Bool) -> UIImage {
        let size = wxImageSize(isSession: isSession)
        let reImage = resizedImage(newSize: size)
        guard let data = reImage.jpegData(compressionQuality: 0.5) else { return UIImage() }
        return UIImage(data: data) ?? UIImage()
    }

    /**
     get wechat compress image size
     
     - Parameter isSession: session image boundary is 800, timeline is 1280
     
     - Returns: thumb image size
     */
    func wxImageSize(isSession: Bool) -> CGSize {
        var width = self.size.width
        var height = self.size.height
        var boundary: CGFloat = 1280
        
        if width < boundary && height < boundary {
            return CGSize(width: width, height: height)
        }
        
        let ratio = max(width, height) / min(width, height)
        if ratio <= 2 {
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            if min(width, height) >= boundary {
                boundary = isSession ? 800 : 1280
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }

        return CGSize(width: width, height: height)
    }

    /**
     Zoom the picture to the specified size
     
     - Parameter newSize: session image boundary is 800, timeline is 1280
     
     - Returns: new image
     */
    func resizedImage(newSize: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContext(newRect.size)
        let newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: newRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage ?? UIImage()
    }
}
