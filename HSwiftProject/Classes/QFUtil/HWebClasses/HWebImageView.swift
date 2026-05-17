//
//  HWebImageView.swift
//  FreeChat
//
//  Created by Wind on 2019/11/18.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

enum HWebGetImageStyle {
    case local //本地图片
    case origin //控件原有图片
    case cache //缓存图片
    case network //网络图片
}

typealias HWebGetImageBlock = (_ sender: Any?, _ data: Any?, _ style: HWebGetImageStyle) -> Void

class HWebImageView: UIImageView {
    
    var imageSize: CGSize = .zero {
        didSet {
            if imageSize != oldValue, superview != nil {
                updateSubviews()
            }
        }
    }
    
    // The tintColor in the parent class is problematic
    var renderColor: UIColor? {
        didSet {
            if renderColor != oldValue, superview != nil {
                updateSubviews()
            }
        }
    }
    
    var pressed: Callback? {
        didSet {
            if pressed != nil {
                isUserInteractionEnabled = true
                if pressedGesture.view == nil {
                    addGestureRecognizer(pressedGesture)
                }
            } else {
                isUserInteractionEnabled = false
            }
        }
    }
    
    var hasImage: Bool {
        return super.image != nil
    }
    var didGetError: Callback?
    var didGetImage: HWebGetImageBlock?
    
    private var lastURL: String = ""
    // Click time
    private var pressedInterval: TimeInterval = 0.0
    
    lazy private var pressedGesture: UITapGestureRecognizer = {
        let pressedGesture = UITapGestureRecognizer()
        pressedGesture.numberOfTapsRequired = 1
        pressedGesture.numberOfTouchesRequired = 1
        pressedGesture.addTarget(self, action: #selector(pressedAction))
        return pressedGesture
    }()
    
    // Click response event
    @objc
    private func pressedAction() {
        guard let pressed = pressed else { return }
        // Click time
        if Date().timeIntervalSince1970 - pressedInterval > 0.5 {
            // Record click time
            pressedInterval = Date().timeIntervalSince1970
            // Callback
            pressed(self, nil)
        }
    }
    
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
        self.backgroundColor = .clear
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateSubviews()
    }
    
    private func updateSubviews() {
        if let superImage = super.image {
            var image: UIImage? = superImage
            if imageSize != .zero {
                image = image?.cropImage(imageSize)
            }
            if let color = renderColor {
                self.tintColor = color
                image = image?.withRenderingMode(.alwaysTemplate)
            }
            super.image = image
        }
    }

}

extension HWebImageView {
    func setImage(WithFile fileName: String) {
        if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
           let image = UIImage(contentsOfFile: filePath) {
            self.image = image
        }
    }
    func setImage(named fileName: String) {
        if let image = UIImage(named: fileName) {
            self.image = image
        }
    }
    func setImage(_ image: UIImage?) {
        self.image = image
    }
    
    override var image: UIImage? {
        didSet {
            updateSubviews()
        }
    }
}

extension HWebImageView {
    
    /**
    *  Set image directly
    *
    *  @param image image
    */
    private func _setImage(_ image: UIImage?, _ completion: @escaping () -> Void) {
        DispatchQueue.mainAsync {
            if image != nil {
                super.image = image
            }
            completion()
        }
    }

    /**
    *  Set image link, read cache synchronously if available
    *
    *  @param url                      Link
    *  @param placeholder        Placeholder image
    *  @param syncLoadCache Synchronously read cache
    *
    */
    func setAvatarUrl(_ url: URL, placeholder: UIImage? = nil) {
        self.setImageUrl(url, placeholder: placeholder, syncLoadCache: false)
    }
    func setImageUrl(_ url: URL, placeholder: UIImage? = nil, syncLoadCache cache: Bool = false) {
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
    func setAvatarUrlString(_ urlString: String, placeholder: UIImage? = nil) {
        self.setImageUrlString(urlString, placeholder: placeholder, syncLoadCache: false)
    }
    func setImageUrlString(_ urlString: String, placeholder: UIImage? = nil, syncLoadCache cache: Bool = false, cropSize: CGSize = .zero) {
        if urlString.count == 0 {
            self._setImage(placeholder) { [weak self] in
                guard let self = self else { return }
                self.lastURL = ""
                self.didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            }
            return
        }
        
        if urlString.hasPrefix("http") == false {
            let image = UIImage(named: urlString)
            self._setImage(image) { [weak self] in
                guard let self = self else { return }
                self.didGetImage?(self, self.image, .local)
            }
            return
        }
        
        if self.image != nil && self.lastURL == urlString {
            self.didGetImage?(self, self.image, .origin)
            return
        }
        
        //self._setImage(nil) {}
        self.lastURL = ""
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var option = KingfisherOptionsInfo()
        option.append(.cacheOriginalImage)
        option.append(.scaleFactor(1))
        option.append(.memoryCacheExpiration(.seconds(5)))
        option.append(.transition(ImageTransition.fade(1)))
        if cropSize != .zero {
            let processor = DownsamplingImageProcessor(size: cropSize)
            option.append(.processor(processor))
        }
        if cache {
            // 从缓存加载图片
            KingfisherManager.shared.cache.retrieveImage(forKey: urlString) { [weak self] result in
                guard let self = self else { return }
                if case.success(let value) = result, value.image != nil {
                    self._setImage(value.image) { [weak self] in
                        guard let self = self else { return }
                        self.lastURL = urlString
                        self.didGetImage?(self, value.image, .cache)
                    }
                }else {
                    // 从网络加载图片
                    self.kf.setImage(with: url, placeholder: placeholder, options: option) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let value):
                            self._setImage(value.image) { [weak self] in
                                guard let self = self else { return }
                                self.lastURL = urlString
                                self.didGetImage?(self, value.image, .network)
                            }
                        case .failure(let value):
                            self.didGetError?(self, value as AnyObject)
                        }
                    }
                }
            }
        }else {
            // 从缓存加载图片
            KingfisherManager.shared.cache.retrieveImage(forKey: urlString) { [weak self] result in
                guard let self = self else { return }
                if case.success(let value) = result, value.image != nil {
                    self._setImage(value.image) { [weak self] in
                        guard let self = self else { return }
                        self.lastURL = urlString
                        self.didGetImage?(self, value.image, .cache)
                    }
                }
            }
            // 从网络加载图片
            self.kf.setImage(with: url, placeholder: placeholder, options: option) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self._setImage(value.image) { [weak self] in
                        guard let self = self else { return }
                        self.lastURL = urlString
                        self.didGetImage?(self, value.image, .network)
                    }
                case .failure(let value):
                    self.didGetError?(self, value as AnyObject)
                }
            }
        }
    }
    
    /**
    *  可以根据指定大小压缩图片
    */
    func setAvatarCompressUrlString(_ urlString: String, placeholder: UIImage? = nil, size: CGSize = CGSize(width: 50, height: 50)) {
        self.setCompressUrlString(urlString, placeholder: placeholder, syncLoadCache: false, size: size)
    }
    func setCompressUrlString(_ urlString: String, placeholder: UIImage? = nil, syncLoadCache cache: Bool = false, size: CGSize = CGSize(width: 50, height: 50)) {
        self.setImageUrlString(urlString, placeholder: placeholder, syncLoadCache: cache, cropSize: size)
    }
    
}

extension UIImageView {
    var doubleSize: CGSize {
        return CGSize(width: bounds.size.width * 2, height: bounds.size.height * 2)
    }
    
    convenience init(named: String) {
        self.init(image: UIImage(named: named))
    }
}
