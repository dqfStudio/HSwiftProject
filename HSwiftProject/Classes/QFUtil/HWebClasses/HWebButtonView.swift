//
//  HWebButtonView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import Kingfisher

class HWebButtonView: UIButton {
    
    lazy private var _imageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return imageView
    }()
    
    private var lastURL: String = ""
    // Click time
    private var pressedInterval: TimeInterval = 0.0

    override var contentMode: UIView.ContentMode {
        didSet {
            _imageView.contentMode = contentMode
        }
    }
    
    // The tintColor in the parent class is problematic
    var renderColor: UIColor? {
        didSet {
            guard let color = renderColor else {
                _imageView.image = _imageView.image?.withRenderingMode(.alwaysOriginal)
                self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysOriginal), for:.normal)
                return
            }
            _imageView.tintColor = color
            _imageView.image = _imageView.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
            self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysTemplate), for:.normal)
        }
    }
    
    var hasImage: Bool {
        return _imageView.image != nil
    }
    var pressed: Callback?
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
        self.addSubview(_imageView)
        self.backgroundColor = UIColor.clear
        self.initialize()
    }
    
    private func initialize() {
        titleLabel?.font = .systemFont(ofSize: 14.0)
        self.imageView?.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(buttonPressed), for:.touchUpInside)
    }

    private func _setImage(_ image: UIImage?) {
        self._imageView.kf.cancelDownloadTask()
        guard let image = image else {
            _imageView.image = nil
            return
        }
        if let renderColor = renderColor {
            _imageView.tintColor = renderColor
            _imageView.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            _imageView.image = image
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
            self._imageView.alpha = 1.0
            didGetImage?(self, _imageView.image)
            return
        }
        if self._imageView.image != nil && lastURL.isEqual(urlString) {
            self._imageView.alpha = 1.0
            didGetImage?(self, _imageView.image)
            return
        }
        
        if placeholder == nil && self._imageView.image == nil {
            self._imageView.alpha = 0
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
                        self._imageView.alpha = 1.0
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        if _imageView.image == nil {
            //_imageView.kf.indicatorType = .activity
            _imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString
                    if value.cacheType == .none {
                        UIView.animate(withDuration: 0.5) {
                            self._imageView.alpha = 1.0
                        }
                    }else {
                        self._imageView.alpha = 1.0
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

    // Set background color
    override internal var backgroundColor: UIColor? {
        get { return _imageView.backgroundColor }
        set { _imageView.backgroundColor = newValue }
    }
    
}

extension UIButton {

    public var text: String? {
        get { return self.title(for: .normal) }
        set { self.setTitle(newValue, for: .normal) }
    }

    public var textFont: UIFont? {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
    
    public var textColor: UIColor? {
        get { return self.titleColor(for: .normal) }
        set { self.setTitleColor(newValue, for: .normal) }
    }
    
    public var textAlignment: NSTextAlignment {
        get { return self.titleLabel?.textAlignment ?? .center }
        set { self.titleLabel?.textAlignment = newValue }
    }
    
    @objc open var image: UIImage? {
        get { return self.image(for: .normal) }
        set { self.setImage(newValue, for: .normal) }
    }
    
    public var backgroundImage: UIImage? {
        get { return self.backgroundImage(for: .normal) }
        set { self.setBackgroundImage(newValue, for: .normal) }
    }
    
    public func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }

    //let the min respond area is 44*44
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        let widthDelta: CGFloat = max(44.0 - bounds.width, 0)
        let heightDelta: CGFloat = max(44.0 - bounds.height, 0)
        bounds = bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return bounds.contains(point)
    }
    
    ///图左文字右
    public func imageAndTextWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
    }

    ///图右文字左
    public func textAndImageWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.width ?? 0), bottom: 0, right: (self.imageView?.width)!-spacing)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: (self.titleLabel?.width ?? 0) - spacing, bottom: 0, right: -(self.titleLabel?.width)!)
    }
    
    ///图上文字下
    public func imageUpAndTextDownWithSpacing(_ spacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.width ?? 0), bottom: -(self.imageView?.width ?? 0) - spacing / 2, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: -(self.titleLabel?.intrinsicContentSize.width ?? 0) - spacing / 2, left: 0, bottom: 0, right: -(self.titleLabel?.intrinsicContentSize.width ?? 0))
    }

}
