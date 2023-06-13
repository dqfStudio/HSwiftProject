//
//  HWebButtonView2.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/13.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Kingfisher

class HWebButtonView2: UIButton {
    
    private var lastURL: String = ""
    // Click time
    private var pressedInterval: TimeInterval = 0.0
    
    // The tintColor in the parent class is problematic
    var renderColor: UIColor? {
        didSet {
            guard let color = renderColor else {
                self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysOriginal), for:.normal)
                return
            }
            imageView?.tintColor = color
            self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysTemplate), for:.normal)
        }
    }
    
    var hasImage: Bool {
        return imageView?.image != nil
    }
    var pressed: Callback?
    var didGetImage: Callback?
    var didGetError: Callback?
    
    required init() {
        super.init(frame: .zero)
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
        self.backgroundColor = UIColor.clear
        titleLabel?.font = .systemFont(ofSize: 14.0)
        self.imageView?.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(buttonPressed), for:.touchUpInside)
    }

    private func _setImage(_ image: UIImage?) {
        imageView?.kf.cancelDownloadTask()
        guard let image = image else {
            imageView?.image = nil
            return
        }
        if let renderColor = renderColor {
            imageView?.tintColor = renderColor
            imageView?.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            imageView?.image = image
        }
    }
    
    /**
    *  Set image directly
    *
    *  @param image image
    */
    func setImage(_ image: UIImage?) {
        self._setImage(image)
        self.lastURL = ""
        self.imageView?.alpha = 1.0
        didGetImage?(self, image)
    }

    /**
    *  Set image link, read cache synchronously if available
    *
    *  @param url                      Link
    *  @param placeholder        Placeholder image
    *  @param syncLoadCache Synchronously read cache
    *
    */
    func setImageUrl(_ url: URL, placeholder: UIImage? = nil, syncLoadCache cache: Bool = true) {
        self.setImageUrlString(url.absoluteString, placeholder: placeholder, syncLoadCache: cache)
    }
    
    /**
    *  Set image link, read from cache if available
    *
    *  @param urlString             link string
    *  @param placeholder        default image
    *  @param syncLoadCache whether to read cache synchronously
    *
    */
    func setImageUrlString(_ urlString: String, placeholder: UIImage? = nil, syncLoadCache cache: Bool = true) {
        if urlString.count == 0 {
            self._setImage(placeholder)
            self.lastURL = ""
            didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            return
        }
        
        if urlString.hasPrefix("http") == false {
            let image: UIImage? = UIImage(named: urlString)
            self._setImage(image)
            self.imageView?.alpha = 1.0
            didGetImage?(self, imageView?.image)
            return
        }
        if self.imageView?.image != nil && lastURL.isEqual(urlString) {
            self.imageView?.alpha = 1.0
            didGetImage?(self, imageView?.image)
            return
        }
        
        if placeholder == nil && self.imageView?.image == nil {
            self.imageView?.alpha = 0
        }
        
        self._setImage(nil)
        self.lastURL = ""
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        if cache {
            KingfisherManager.shared.cache.retrieveImage(forKey: urlString) { result in
                switch result {
                case.success(let value):
                    if value.image != nil {
                        self._setImage(value.image)
                        self.imageView?.alpha = 1.0
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        if imageView?.image == nil {
            //_imageView.kf.indicatorType = .activity
            imageView?.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString
                    if value.cacheType == .none {
                        UIView.animate(withDuration: 0.5) {
                            self.imageView?.alpha = 1.0
                        }
                    }else {
                        self.imageView?.alpha = 1.0
                    }
                    self.didGetImage?(self, value.image)
                case .failure(let value):
                    self.didGetError?(self, value as AnyObject)
                }
            }
        }
    }

    /**
    *  Set the image name and load it through the file
    *
    *  @param fileName image name
    */
    func setImageWithFile(_ fileName: String) {
        if fileName.count > 0 {
            if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
               let image = UIImage(contentsOfFile: filePath) {
                self.setImage(image)
            }
        }else {
            self._setImage(nil)
            self.lastURL = ""
            didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(fileName)"))
        }
    }

    /**
    *  Set the image name and load it using imageName
    *
    *  @param fileName The name of the image
    */
    func setImageWithName(_ fileName: String) {
        if fileName.count > 0 {
            self.setImage(UIImage(named: fileName))
        }
    }

    // Click response event
    @objc
    private func buttonPressed() {
        guard let pressed = pressed else { return }
        // Click time
        if Date().timeIntervalSince1970 - pressedInterval > 0.5 {
            // Record click time
            pressedInterval = Date().timeIntervalSince1970
            // Callback
            pressed(self, nil)
        }
    }
    
}
