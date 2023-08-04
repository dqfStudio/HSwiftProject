//
//  HAvatarView.swift
//  HSwiftProject
//
//  Created by owner on 2023/8/4.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Kingfisher

private var kAvatarUrlsKey = "kAvatarUrlsKey"

extension HWebImageView {
    
    private var avatarUrls: [String]? {
        get { return self.getAssociatedValueForKey(&kAvatarUrlsKey) as? [String] }
        set { self.setAssociateValue(newValue, key: &kAvatarUrlsKey) }
    }
    
    /// 设置群头像
    func setGroupAvatar(faceUrls: [String], width: CGFloat) {
        guard avatarUrls != faceUrls else { return }
        avatarUrls = faceUrls
        
        let count = min(faceUrls.count, 9)
        guard count >= 2 else {
            self.setImageUrlString(faceUrls.first ?? "")
            return
        }
        
        let kInterval: CGFloat = 2
        let kWidth: CGFloat = width
        self.backgroundColor = UIColor.white
        
        for i in 0..<count {
            var imgFrame = CGRect.zero
            switch count {
            case 2:
                let w = (kWidth - 3 * kInterval) / 2
                let x = kInterval + (kInterval + w) * CGFloat(i % 2)
                let y = (kWidth - w) / 2
                imgFrame = CGRect(x: x, y: y, width: w, height: w)
            case 3:
                let w = (kWidth - 3 * kInterval) / 2
                if i == 0 {
                    imgFrame = CGRect(x: (kWidth - w) / 2, y: kInterval, width: w, height: w)
                } else if i == 1 {
                    imgFrame = CGRect(x: kInterval, y: kInterval * 2 + w, width: w, height: w)
                } else if i == 2 {
                    imgFrame = CGRect(x: kInterval * 2 + w, y: kInterval * 2 + w, width: w, height: w)
                }
            case 4:
                let w = (kWidth - 3 * kInterval) / 2
                let x = kInterval + (kInterval + w) * CGFloat(i % 2)
                let y = kInterval + (kInterval + w) * CGFloat(i / 2)
                imgFrame = CGRect(x: x, y: y, width: w, height: w)
            case 5:
                let w = (kWidth - 4 * kInterval) / 3
                if i == 0 {
                    let x = (kWidth - (w * 2 + kInterval)) / 2
                    let y = x
                    imgFrame = CGRect(x: x, y: y, width: w, height: w)
                } else if i == 1 {
                    let x = (kWidth - (w * 2 + kInterval)) / 2 + w + kInterval
                    let y = (kWidth - (w * 2 + kInterval)) / 2
                    imgFrame = CGRect(x: x, y: y, width: w, height: w)
                } else {
                    let x = kInterval + (kInterval + w) * CGFloat((i - 2) % 3)
                    let y = (kWidth - (w * 2 + kInterval)) / 2 + w + kInterval
                    imgFrame = CGRect(x: x, y: y, width: w, height: w)
                }
            case 6:
                let w = (kWidth - 4 * kInterval) / 3
                let x = kInterval + (kInterval + w) * CGFloat(i % 3)
                let y = i < 3
                ? (kWidth - (w * 2 + kInterval)) / 2
                : (kWidth - (w * 2 + kInterval)) / 2 + w + kInterval
                imgFrame = CGRect(x: x, y: y, width: w, height: w)
            case 7:
                let w = (kWidth - 4 * kInterval) / 3
                if i == 0 {
                    imgFrame = CGRect(x: (kWidth - w) / 2, y: kInterval, width: w, height: w)
                } else {
                    let x = kInterval + (kInterval + w) * CGFloat((i - 1) % 3)
                    let y = i > 3 ? (kInterval + w) : (kInterval + w) * 2
                    imgFrame = CGRect(x: x, y: y, width: w, height: w)
                }
            case 8:
                let w = (kWidth - 4 * kInterval) / 3
                if i == 0 {
                    let x = (kWidth - (w * 2 + kInterval)) / 2
                    imgFrame = CGRect(x: x, y: kInterval, width: w, height: w)
                } else if i == 1 {
                    let x = (kWidth - (w * 2 + kInterval)) / 2 + kInterval + w
                    imgFrame = CGRect(x: x, y: kInterval, width: w, height: w)
                } else {
                    let x = kInterval + (kInterval + w) * CGFloat((i - 2) % 3)
                    let y = i > 4 ? (kInterval + w) * 2 + kInterval : (kInterval + w) + kInterval
                    imgFrame = CGRect(x: x, y: y, width: w, height: w)
                }
            default:
                let w = (kWidth - 4 * kInterval) / 3
                let x = kInterval + (kInterval + w) * CGFloat(i % 3)
                let y = kInterval + (kInterval + w) * CGFloat(i / 3)
                imgFrame = CGRect(x: x, y: y, width: w, height: w)
            }
            
            self.image = nil
            let imgView = HWebImageView(frame: imgFrame)
            imgView.layer.cornerRadius = 2
            imgView.clipsToBounds = true
            self.addSubview(imgView)
            imgView.setImageUrlString(faceUrls[i])
        }
    }
    
}
