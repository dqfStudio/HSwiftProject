//
//  UIImage+HUtil.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/18.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

private var CompleteBlockKey = "CompleteBlockKey"
private var FailBlockKey = "FailBlockKey"

extension UIImage {

    static func imageFromName(_ aName: String) -> UIImage? {
        return UIImage(named: aName)
    }

    static func imageFromFile(_ filePath: String) -> UIImage? {
        return UIImage(contentsOfFile: filePath)
    }

    static func imageFromData(_ imageData: Data) -> UIImage? {
        return UIImage(data: imageData)
    }

    static func testImage() -> UIImage? {
        return self.testImage(CGSize(width: 200, height: 200))
    }

    static func testImage(_ size: CGSize) -> UIImage? {
        let imageString = "🏄"
        let font = UIFont(name: "Menlo", size: size.height)
        let image = self.imageWithString(imageString, font: font!, width: size.width, textAlignment: NSTextAlignment.left)
        return image
    }

    static func imageWithString(_ string: String, font: UIFont, width: CGFloat, textAlignment: NSTextAlignment) -> UIImage? {
        let attributeDic = [NSAttributedString.Key.font: font]

        let size = string.boundingRect(with: CGSize(width: width, height: 10000),
                                       options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
                                       attributes: attributeDic,
                                       context: nil).size

        if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
            if UIScreen.main.scale == 2.0 {
                UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
            }else {
                UIGraphicsBeginImageContext(size)
            }
        }else {
            UIGraphicsBeginImageContext(size)
        }

        let context = UIGraphicsGetCurrentContext()

        UIColor.white.set()

        let rect = CGRect(x: 0, y: 0, width: size.width + 1, height: size.height + 1)

        context?.fill(rect)


        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = textAlignment

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]

        string.draw(in: rect, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }

    static func mergeImage(_ imageSource: UIImage, tagertImage: UIImage) -> UIImage? {
        let imageSourceSize = imageSource.size
        let mixImageWidth = imageSourceSize.width
        let mixImageHeight = imageSourceSize.height

        UIGraphicsBeginImageContextWithOptions(imageSourceSize, false, UIScreen.main.scale)

        let rect = CGRect(x: (imageSourceSize.width - mixImageWidth) / 2.0,
                          y: (imageSourceSize.height - mixImageHeight) / 2.0,
                          width: mixImageWidth,
                          height: mixImageHeight)

        tagertImage.draw(in: rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resultImage
    }

    static func mergeImage(_ image: UIImage, text: String, font: UIFont, color: UIColor) -> UIImage? {
        if text.isEmpty { return image }

        let imageSize = image.size

        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.kern: 0.5,
            NSAttributedString.Key.paragraphStyle: paragraph
        ] as [NSAttributedString.Key : Any]

        let textRect = text.boundingRect(with: imageSize,
                                         options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
                                         attributes: attributes,
                                         context: nil)

        let textWidth = textRect.size.width
        let textHeight = textRect.size.height

        let mixTextWidth = min(textWidth, imageSize.width)
        let mixTextHeight = min(textHeight, imageSize.height)

        let rect = CGRect(x: (imageSize.width - mixTextWidth) / 2.0,
                          y: (imageSize.height - mixTextHeight) / 2.0,
                          width: mixTextWidth,
                          height: mixTextHeight)

        text.draw(in: rect, withAttributes: attributes)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resultImage
    }

    static func imageWithColor(_ color: UIColor) -> UIImage? {
        return self.imageWithColor(color, size: CGSize(width: 1, height: 1))
    }

    static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 { return nil }
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    static func resizeWithImageName(_ name: String, leftCap: CGFloat, topCap: CGFloat) -> UIImage? {
        let image = self.imageFromName(name)
        return image?.stretchableImage(withLeftCapWidth: Int((image?.size.width)! * leftCap), topCapHeight: Int((image?.size.height)! * topCap))
    }

    static func resizeWithImageName(_ name: String) -> UIImage? {
        return self.resizeWithImageName(name, leftCap: 0.5, topCap: 0.5)
    }

    static func clipCircleImage(_ name: String) -> UIImage? {
        return self.imageFromName(name)?.clipCircleImage()
    }

    func scaleImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    func clipCircleImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width)
        ctx?.addEllipse(in: rect)
        ctx?.clip()
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    func getImageHightWidthScale() -> CGFloat {
        return self.size.height / self.size.width
    }

    func fixOrientation() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up { return self }
        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break

        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            break

        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)
            break

        default:
            break
        }

        switch self.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break

        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break

        default:
            break
        }

        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                             bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                             space: self.cgImage!.colorSpace!,
                             bitmapInfo: self.cgImage!.bitmapInfo.rawValue)

        ctx?.concatenate(transform)

        switch self.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            break

        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            break
        }

        let cgimage = ctx?.makeImage()
        let image = UIImage(cgImage: cgimage!)
        return image
    }

    static func thumbnailWithImage(_ originalImage: UIImage, size: CGSize) -> UIImage? {
        let originalsize = originalImage.size
        if originalsize.width < size.width && originalsize.height < size.height { //原图长宽均小于标准长宽的，不作处理返回原图
            return originalImage
        }else if originalsize.width > size.width && originalsize.height > size.height { //原图长宽均大于标准长宽的，按比例缩小至最大适应值
            var rate: CGFloat = 1.0
            let widthRate = originalsize.width / size.width
            let heightRate = originalsize.height / size.height
            rate = widthRate > heightRate ? heightRate : widthRate
            var imageRef: CGImage?

            if heightRate > widthRate {
                imageRef = originalImage.cgImage?.cropping(to: CGRect(x: 0, y: originalsize.height / 2 - size.height * rate / 2, width: originalsize.width, height: size.height * rate))//获取图片整体部分
            }else {
                imageRef = originalImage.cgImage?.cropping(to: CGRect(x: originalsize.width / 2 - size.width * rate / 2, y: 0, width: size.width * rate, height: originalsize.height))//获取图片整体部分
            }

            UIGraphicsBeginImageContext(size)//指定要绘画图片的大小
            let con = UIGraphicsGetCurrentContext()

            con?.translateBy(x: 0.0, y: size.height)
            con?.scaleBy(x: 1.0, y: -1.0)
            con?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            let standardImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return standardImage
        }
        //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
        else if originalsize.height > size.height || originalsize.width > size.width {
            var imageRef: CGImage?
            if originalsize.height > size.height {
                imageRef = originalImage.cgImage?.cropping(to: CGRect(x: 0, y: originalsize.height / 2 - size.height / 2, width: originalsize.width, height: size.height))//获取图片整体部分
            }else if originalsize.width > size.width {
                imageRef = originalImage.cgImage?.cropping(to: CGRect(x: originalsize.width / 2 - size.width / 2, y: 0, width: size.width, height: originalsize.height))//获取图片整体部分
            }

            UIGraphicsBeginImageContext(size)//指定要绘画图片的大小
            let con = UIGraphicsGetCurrentContext()
            con?.translateBy(x: 0.0, y: size.height)
            con?.scaleBy(x: 1.0, y: -1.0)
            con?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            let standardImage = UIGraphicsGetImageFromCurrentImageContext()
            //NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
            UIGraphicsEndImageContext()

            return standardImage
        }
        //原图为标准长宽的，不做处理
        else {
            return originalImage
        }

    }

    /**
     *  保存相册
     *
     *  @param completeBlock 成功回调
     *  @param failBlock 出错回调
     */
    func savedPhotosAlbum(completeBlock: (() -> Void)?, failBlock: (() -> Void)?) {
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        self.completeBlock = completeBlock
        self.failBlock = failBlock
    }

    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if error == nil {
            if let completeBlock = self.completeBlock { completeBlock() }
        }else {
            if let failBlock = self.failBlock { failBlock() }
        }
    }

    static func compressImage(_ sourceImage: UIImage, toTargetWidth targetWidth: CGFloat) -> UIImage? {
        //获取原图片的大小尺寸
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        //根据目标图片的宽度计算目标图片的高度
        let targetHeight = (targetWidth / width) * height
        //开启图片上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight), false, UIScreen.main.scale)
        //绘制图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        //从上下文中获取绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭图片上下文
        UIGraphicsEndImageContext()

        return newImage
    }

    /*
     *  模拟成员变量
     */
    private var failBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &FailBlockKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &FailBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var completeBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &CompleteBlockKey) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &CompleteBlockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
