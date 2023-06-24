//
//  UIImage+QRCode.swift
//  HSwiftProject
//
//  Created by Wind on 2023/3/23.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     *  生成二维码
     *
     *  @param data    二维码数据
     *  @param size    二维码大小
     */
    class func generateQRCode(with data: String, size: CGFloat) -> UIImage? {
        return generateQRCode(with: data, size: size, color: UIColor.black, backgroundColor: UIColor.white)
    }
    /**
     *  生成二维码
     *
     *  @param data     二维码数据
     *  @param size     二维码大小
     *  @param color    二维码颜色
     *  @param backgroundColor    二维码背景颜色
     */
    class func generateQRCode(with data: String, size: CGFloat, color: UIColor, backgroundColor: UIColor) -> UIImage? {
        let stringData = data.data(using: .utf8)
        // 1、二维码滤镜
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        fileter?.setValue(stringData, forKey: "inputMessage")
        //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
        /*
         * L: 7%
         * M: 15%
         * Q: 25%
         * H: 30%
         */
        fileter?.setValue("H", forKey: "inputCorrectionLevel")
        let ciImage = fileter?.outputImage
        // 2、颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(cgColor: backgroundColor.cgColor), forKey: "inputColor1")
        // 3、生成处理
        if let outImage = colorFilter?.outputImage {
//            CGFloat scale = size / outImage.extent.size.width;
//            outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
//            return [UIImage imageWithCIImage:outImage];
            return createNonInterpolatedUIImageFormCIImage(image: outImage, withSize: size)
        }
        return nil
    }

    /**
     *  生成带 logo 的二维码（推荐使用）
     *
     *  @param data     二维码数据
     *  @param size     二维码大小
     *  @param logoImage    logo
     *  @param ratio        logo 相对二维码的比例
     */
    class func generateQRCode(with data: String, size: CGFloat, logoImage: UIImage?, ratio: CGFloat) -> UIImage? {
        return generateQRCode(with: data, size: size, logoImage: logoImage, ratio: ratio, logoImageCornerRadius: 5, logoImageBorderWidth: 2, logoImageBorderColor: UIColor.white)
    }
    /**
     *  生成带 logo 的二维码（拓展）
     *
     *  @param data     二维码数据
     *  @param size     二维码大小
     *  @param logoImage    logo
     *  @param ratio        logo 相对二维码的比例
     *  @param logoImageCornerRadius    logo 外边框圆角
     *  @param logoImageBorderWidth     logo 外边框宽度
     *  @param logoImageBorderColor     logo 外边框颜色
     */
    class func generateQRCode(with data: String, size: CGFloat, logoImage: UIImage?, ratio: CGFloat, logoImageCornerRadius: CGFloat, logoImageBorderWidth: CGFloat, logoImageBorderColor: UIColor) -> UIImage? {
        let image = generateQRCode(with: data, size: size, color: UIColor.black, backgroundColor: UIColor.white)
        if logoImage == nil { return image }
        var ratio = ratio
        if ratio < 0.0 || ratio > 0.5 {
            ratio = 0.25
        }
        let logoImageW = ratio * size
        let logoImageH = logoImageW
        let logoImageX = 0.5 * (image?.size.width ?? 0 - logoImageW)
        let logoImageY = 0.5 * (image?.size.height ?? 0 - logoImageH)
        let logoImageRect = CGRect(x: logoImageX, y: logoImageY, width: logoImageW, height: logoImageH)
        // 绘制logo
        UIGraphicsBeginImageContextWithOptions(image?.size ?? CGSize.zero, false, UIScreen.main.scale)
        image?.draw(in: CGRect(x: 0, y: 0, width: image?.size.width ?? 0, height: image?.size.height ?? 0))
        var logoImageCornerRadius = logoImageCornerRadius
        if logoImageCornerRadius < 0.0 || logoImageCornerRadius > 10 {
            logoImageCornerRadius = 5
        }
        let path = UIBezierPath(roundedRect: logoImageRect, cornerRadius: logoImageCornerRadius)
        var logoImageBorderWidth = logoImageBorderWidth
        if logoImageBorderWidth < 0.0 || logoImageBorderWidth > 10 {
            logoImageBorderWidth = 5
        }
        path.lineWidth = logoImageBorderWidth
        logoImageBorderColor.setStroke()
        path.stroke()
        path.addClip()
        logoImage?.draw(in: logoImageRect)
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return QRCodeImage
    }
    /**
     调整二维码清晰度
     
     @param image 模糊的二维码图片
     @param size 二维码的宽高
     @return 清晰的二维码图片
     */
    class func createNonInterpolatedUIImageFormCIImage(image: CIImage, withSize size: CGFloat) -> UIImage? {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs = CGColorSpaceCreateDeviceGray()
        if let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) {
            let context = CIContext(options: nil)
            if let bitmapImage = context.createCGImage(image, from: extent) {
                bitmapRef.interpolationQuality = .none
                bitmapRef.scaleBy(x: scale, y: scale)
                bitmapRef.draw(bitmapImage, in: extent)
                // 2.保存bitmap到图片
                if let scaledImage = bitmapRef.makeImage() {
                    return UIImage(cgImage: scaledImage)
                }
            }
        }
        return nil
    }

    /**
     *  给图片绘制颜色
     *
     *  @param color   颜色值
     *  return 绘制颜色后的图片
     */
    func image(with color: UIColor) -> UIImage? {
        if let cgImage = self.cgImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: 0, y: size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.setBlendMode(.normal)
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context?.clip(to: rect, mask: cgImage)
            color.setFill()
            context?.fill(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    /**
     *  按照固定的宽度缩放
     *
     *  @param defineWidth   固定宽度
     *  return 绘制颜色后的图片
     */
    func image(withWidth defineWidth: CGFloat) -> CGSize {
        let imageSize = size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = defineWidth
        let targetHeight = height / (width / targetWidth)
        var size = CGSize(width: targetWidth, height: targetHeight)
        var scaleFactor: CGFloat = 0.0
        //var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        if imageSize.equalTo(size) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }else {
                scaleFactor = heightFactor
            }
            //scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
        }
        size = CGSize(width: width, height: scaledHeight)
        return size
    }
}
