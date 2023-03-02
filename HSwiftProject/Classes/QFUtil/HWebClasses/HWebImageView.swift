//
//  HWebImageView.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Kingfisher

class HWebImageView: UIImageView {
    
    lazy private var tapGesture: UITapGestureRecognizer! = {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: #selector(tapGestureAction))
        return tapGesture
    }()
    
    private var lastURL: String = ""
    
    //父类那个tintColor有问题
    var renderColor: UIColor? {
        didSet {
            self.renderColor = oldValue
            if self.renderColor != nil {
                self.tintColor = oldValue
                super.h_image = self.image?.withRenderingMode(.alwaysTemplate)
            }else {
                super.h_image = self.image?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    var placeHoderImage: UIImage?
    
    var pressed: Callback? {
        didSet {
            self.pressed = oldValue
            if self.pressed != nil {
                self.isUserInteractionEnabled = true
                if self.tapGesture.view != nil {
                    self.addGestureRecognizer(self.tapGesture)
                }
            }else {
                self.isUserInteractionEnabled = false
            }
        }
    }
    var didGetImage: Callback?
    var didGetError: Callback?
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    private func setup() {
        //self.backgroundColor = UIColor.colorWithHex(0xe8e8e8)
        self.backgroundColor = UIColor.clear
        self.initialize()
    }
    
    private func initialize() {
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
    }
    
    private func _setImage(_ image: UIImage?) {
        self.kf.cancelDownloadTask()
        if (image != nil) {
            if renderColor != nil {
                self.tintColor = renderColor
                super.h_image = image?.withRenderingMode(.alwaysTemplate)
            }else {
                super.h_image = image
            }
        }else {
            super.h_image = nil
        }
    }
    
    /**
    *  直接设置图片
    *
    *  @param image 图片
    */
    func setImage(_ image: UIImage?) {
        self._setImage(image)
        self.lastURL = ""
        self.placeHoderImage = nil
        self.alpha = 1
        if didGetImage != nil {
            didGetImage!(self, image!)
        }
    }

    /**
    *  设置图片链接
    *
    *  @param url 链接
    *
    */
    func setImageUrl(_ url: URL) {
        self.setImageUrl(url, syncLoadCache: false)
    }

    /**
    *  设置图片链接,如果有缓存同步读取缓存
    *
    *  @param url           链接
    *  @param syncLoadCache 是否同步读缓存
    *
    */
    func setImageUrl(_ url: URL, syncLoadCache cache: Bool) {
        self.setImageUrlString(url.absoluteString, syncLoadCache: cache)
    }

    /**
    *  设置图片链接
    *
    *  @param urlString 链接字符串
    *
    */
    func setImageUrlString(_ urlString: String) {
        self.setImageUrlString(urlString, syncLoadCache: false)
    }
    
    /**
    *  设置图片链接,如果有缓存同步读取缓存
    *
    *  @param urlString           链接字符串
    *  @param syncLoadCache 是否同步读缓存
    *
    */
    func setImageUrlString(_ urlString: String, syncLoadCache cache: Bool) {
        if urlString.lengthOfBytes(using: .utf8) == 0 {
            self._setImage(nil)
            self.lastURL = ""
            if didGetError != nil {
                didGetError!(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            }
            return
        }
        
        if urlString.hasPrefix("http") == false {
            let image: UIImage? = UIImage(named: urlString)
            self._setImage(image)
            self.alpha = 1
            if didGetImage != nil {
                didGetImage!(self, self.image!)
            }
            return
        }
        if self.image != nil && lastURL.isEqual(urlString) {
            self.alpha = 1
            if didGetImage != nil {
                didGetImage!(self, self.image!)
            }
            return
        }
        
        if self.placeHoderImage == nil && self.image == nil {
            self.alpha = 0
        }
        
        let placeholder: UIImage? = self.placeHoderImage
        
        self._setImage(nil)
        self.lastURL = ""
        let url: URL = URL(string: urlString)!
        
        if cache {
            KingfisherManager.shared.cache.retrieveImage(forKey: urlString) { result in
                switch result {
                case.success(let value):
                    if value.image != nil {
                        self._setImage(value.image)
                        self.alpha = 1
                        self.lastURL = url.absoluteString
                        if self.didGetImage != nil {
                            self.didGetImage!(self, value.image)
                        }
                    }
                case .failure(_): break
                }
            }
        }
        if self.image == nil {
            self.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString
                    if value.cacheType == .none {
                        UIView.animate(withDuration: 0.5) {
                            self.alpha = 1
                        }
                    }else {
                        self.alpha = 1
                    }
                    if self.didGetImage != nil {
                        self.didGetImage!(self, value.image)
                    }
                case .failure(let value):
                    if self.didGetError != nil {
                        self.didGetError!(self, value as AnyObject)
                    }
                }
            }
        }
    }

    /**
    *  设置图片名称，通过文件的方式加载
    *
    *  @param fileName 图片名称
    */
    func setImageWithFile(_ fileName: String) {
        if fileName.lengthOfBytes(using: .utf8) > 0 {
            let resourcePath: String = Bundle.main.resourcePath!
            let filePath: String = resourcePath.appendingFormat("/%@", fileName)
            let image: UIImage = UIImage(contentsOfFile: filePath)!
            self.setImage(image)
        }else {
            self._setImage(nil)
            self.lastURL = ""
            if didGetError != nil {
                didGetError!(self, herr(kDataFormatErrorCode, desc: "url = \(fileName)"))
            }
        }
    }

    /**
    *  设置图片名称，通过imageName的方式加载
    *
    *  @param fileName 图片名称
    */
    func setImageWithName(_ fileName: String) {
        if fileName.lengthOfBytes(using: .utf8) > 0 {
            self.setImage(UIImage(named: fileName))
        }
    }

    //点击响应事件
    @objc
    private func tapGestureAction() {
        if pressed != nil {
            pressed!(self, nil)
        }
    }

}
