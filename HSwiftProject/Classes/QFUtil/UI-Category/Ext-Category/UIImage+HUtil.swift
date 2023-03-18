//
//  UIImage+HUtil.swift
//  HSwiftProject
//
//  Created by owner on 2023/3/18.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

extension  UIImage {
    func redraw() -> UIImage {
        return self.redraw(with: self.size)
    }
    func redraw(with _aSize: CGSize) -> UIImage {
        var resizeImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(_aSize, false, 0)
        //stretch image
        self.draw(in: CGRect(origin: CGPoint.zero, size: _aSize))
        resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!.withRenderingMode(.alwaysOriginal)
    }
}
