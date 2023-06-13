//
//  HWebImageView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/18.
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
    // Click time
    private var pressedInterval: TimeInterval = 0.0
    
    // The tintColor in the parent class is problematic
    var renderColor: UIColor? {
        didSet {
            guard let color = renderColor else {
                super.image = self.image?.withRenderingMode(.alwaysOriginal)
                return
            }
            self.tintColor = color
            super.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var pressed: Callback? {
        didSet {
            if pressed != nil {
                isUserInteractionEnabled = true
                if tapGesture.view == nil {
                    addGestureRecognizer(tapGesture)
                }
            } else {
                isUserInteractionEnabled = false
            }
        }
    }
    
    var hasImage: Bool {
        return super.image != nil
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
        kf.cancelDownloadTask()
        guard let image = image else {
            super.image = nil
            return
        }
        
        if let renderColor = renderColor {
            tintColor = renderColor
            super.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            super.image = image
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
        self.alpha = 1.0
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
            self._setImage(nil)
            self.lastURL = ""
            didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            return
        }
        
        if urlString.hasPrefix("http") == false {
            let image: UIImage? = UIImage(named: urlString)
            self._setImage(image)
            self.alpha = 1.0
            didGetImage?(self, self.image)
            return
        }
        if self.image != nil && lastURL.isEqual(urlString) {
            self.alpha = 1.0
            didGetImage?(self, self.image)
            return
        }
        
        if placeholder == nil && self.image == nil {
            self.alpha = 0
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
                        self.alpha = 1.0
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        if self.image == nil {
            //self.kf.indicatorType = .activity
            self.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString
                    if value.cacheType == .none {
                        UIView.animate(withDuration: 0.5) {
                            self.alpha = 1.0
                        }
                    }else {
                        self.alpha = 1.0
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
            if let resourcePath = Bundle.main.resourcePath {
                let filePath = resourcePath.appendingFormat("/%@", fileName)
                if let image = UIImage(contentsOfFile: filePath) {
                    self.setImage(image)
                }
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
    private func tapGestureAction() {
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

extension UIImageView {
    convenience init(named: String) {
        self.init(image: UIImage(named: named))
    }
}
