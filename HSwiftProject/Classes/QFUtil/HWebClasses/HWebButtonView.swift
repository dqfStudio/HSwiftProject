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

    enum HImagePosition {
        case top
        case left
        case bottom
        case right
    }

    var imageSize: CGSize = .zero {
        didSet {
            if imageSize != oldValue, superview != nil {
                updateSubviews()
            }
        }
    }
    var imageSpace: CGFloat = 0.0 {
        didSet {
            if imageSpace != oldValue, superview != nil {
                updateSubviews()
            }
        }
    }
    var imagePosition: HImagePosition = .left {
        didSet {
            if imagePosition != oldValue, superview != nil {
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

    var hasImage: Bool {
        return webImageView.image != nil
    }
    var pressed: Callback?
    var didGetImage: Callback?
    var didGetError: Callback?

    private var lastURL: String = ""
    // Click time
    private var pressedInterval: TimeInterval = 0.0

    private var _webImageView: UIImageView?
    var webImageView: UIImageView {
        if _webImageView == nil {
            _webImageView = UIImageView(frame: self.bounds)
            _webImageView!.contentMode = .scaleAspectFill
            _webImageView!.layer.masksToBounds = true
            _webImageView!.isUserInteractionEnabled = false
            _webImageView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.addSubview(_webImageView!)
        }
        return _webImageView!
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
        self.imageView?.contentMode = .scaleAspectFill
        self.titleLabel?.font = .systemFont(ofSize: 17.0)
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(buttonPressed), for:.touchUpInside)
    }

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

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        switch imagePosition {
        case .left, .right:
            size.width += imageSpace
        case .top, .bottom:
            let titleHeight = titleLabel?.bounds.height ?? 0
            let imageHeight = imageView?.bounds.height ?? 0
            size.height = imageSpace + titleHeight + imageHeight
        }
        return size
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateSubviews()
    }

    private func updateSubviews() {
        if let normalImage = self.image(for: .normal) {
            var image: UIImage? = normalImage
            if imageSize != .zero {
                image = image?.cropImage(imageSize)
            }
            if let color = renderColor {
                self.tintColor = color
                image = image?.withRenderingMode(.alwaysTemplate)
            }
            self.setImage(image, for: .normal)
        }
        // 更新image和text坐标
        updatePosition()
    }

    private func updatePosition() {
        switch imagePosition {
        case .top:
            let imageWidth = imageView?.bounds.width ?? 0
            let titleWidth = titleLabel?.bounds.width ?? 0
            let titleHeight = titleLabel?.bounds.height ?? 0
            let imageHeight = imageView?.bounds.height ?? 0
            titleEdgeInsets = UIEdgeInsets(top: (titleHeight + imageSpace) * 0.5, left: -imageWidth * 0.5, bottom: -imageSpace, right: imageWidth * 0.5)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth * 0.5, bottom: imageHeight + imageSpace, right: -titleWidth * 0.5)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: imageSpace, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageSpace)
        case .bottom:
            let imageWidth = imageView?.bounds.width ?? 0
            let titleWidth = titleLabel?.bounds.width ?? 0
            let titleHeight = titleLabel?.bounds.height ?? 0
            let imageHeight = imageView?.bounds.height ?? 0
            titleEdgeInsets = UIEdgeInsets(top: -(titleHeight + imageSpace) * 0.5, left: -imageWidth * 0.5, bottom: imageSpace, right: imageWidth * 0.5)
            imageEdgeInsets = UIEdgeInsets(top: imageHeight + imageSpace, left: titleWidth * 0.5, bottom: 0, right: -titleWidth * 0.5)
        case .right:
            let imageWidth = (imageView?.bounds.width ?? 0) + imageSpace * 0.5
            let titleWidth = (titleLabel?.bounds.width ?? 0) + imageSpace * 0.5
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
        }
    }

}

extension HWebButtonView {
    func setImage(WithFile fileName: String) {
        if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
           let image = UIImage(contentsOfFile: filePath) {
            self.setImage(image, for: .normal)
            self.adjustsImageWhenHighlighted = false
            updateSubviews()
        }
    }
    func setImage(WithName fileName: String) {
        if let image = UIImage(named: fileName) {
            self.setImage(image, for: .normal)
            self.adjustsImageWhenHighlighted = false
            updateSubviews()
        }
    }
    func setImage(_ image: UIImage?) {
        if image != nil {
            self.setImage(image, for: .normal)
            self.adjustsImageWhenHighlighted = false
            updateSubviews()
        }
    }
    
    override var image: UIImage? {
        didSet {
            updateSubviews()
        }
    }
}

extension HWebButtonView {

    /**
    *  Set image directly
    *
    *  @param image image
    */
    private func _setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.adjustsImageWhenHighlighted = false
            if image != nil {
                self.webImageView.image = image
            }
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
            self.didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            return
        }

        if urlString.hasPrefix("http") == false {
            let image = UIImage(named: urlString)
            self._setImage(image)
            self.webImageView.alpha = 1.0
            self.didGetImage?(self, self.webImageView.image)
            return
        }
        
        if self.webImageView.image != nil && lastURL.isEqual(urlString) {
            self.webImageView.alpha = 1.0
            self.didGetImage?(self, self.webImageView.image)
            return
        }

        if placeholder == nil && self.webImageView.image == nil {
            self.webImageView.alpha = 0
        }

        //self._setImage(nil)
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
                        self.webImageView.alpha = 1.0
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        
        //self.webImageView.kf.indicatorType = .activity
        self.webImageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self._setImage(value.image)
                self.lastURL = url.absoluteString
                if value.cacheType == .none {
                    UIView.animate(withDuration: 0.5) {
                        self.webImageView.alpha = 1.0
                    }
                }else {
                    self.webImageView.alpha = 1.0
                }
                self.didGetImage?(self, value.image)
            case .failure(let value):
                self.didGetError?(self, value as AnyObject)
            }
        }
    }

}

extension UIButton {

    public var text: String? {
        get { return self.title(for: .normal) }
        set {
            self.setTitle(newValue, for: .normal)
            self.adjustsImageWhenHighlighted = false
        }
    }

    public var textFont: UIFont? {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }

    public var textColor: UIColor? {
        get { return self.titleColor(for: .normal) }
        set {
            self.setTitleColor(newValue, for: .normal)
            self.adjustsImageWhenHighlighted = false
        }
    }

    public var textAlignment: NSTextAlignment {
        get { return self.titleLabel?.textAlignment ?? .center }
        set { self.titleLabel?.textAlignment = newValue }
    }

    @objc open var image: UIImage? {
        get { return self.image(for: .normal) }
        set {
            self.setImage(newValue, for: .normal)
            self.adjustsImageWhenHighlighted = false
        }
    }

    public var backgroundImage: UIImage? {
        get { return self.backgroundImage(for: .normal) }
        set {
            self.setBackgroundImage(newValue, for: .normal)
            self.adjustsImageWhenHighlighted = false
        }
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
        let imageLeft = -(self.imageView?.width ?? 0)
        let imageRight = (self.imageView?.width ?? 0) - spacing
        let titleLeft = (self.titleLabel?.width ?? 0) - spacing
        let titleRight = -(self.titleLabel?.width ?? 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageLeft, bottom: 0, right: imageRight)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleLeft, bottom: 0, right: titleRight)
    }

    ///图上文字下
    public func imageUpAndTextDownWithSpacing(_ spacing: CGFloat) {
        let imageLeft = -(self.imageView?.width ?? 0)
        let imageBottom = -(self.imageView?.width ?? 0) - spacing / 2
        let titleTop = -(self.titleLabel?.intrinsicContentSize.width ?? 0) - spacing / 2
        let titleRight = -(self.titleLabel?.intrinsicContentSize.width ?? 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageLeft, bottom: imageBottom, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: titleTop, left: 0, bottom: 0, right: titleRight)
    }

}

extension UIImage {
    func cropImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}
