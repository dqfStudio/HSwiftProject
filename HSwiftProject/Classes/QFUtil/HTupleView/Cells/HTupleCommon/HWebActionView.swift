//
//  HWebActionView.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/7.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Kingfisher

enum HWebActionDirection {
    case top
    case left
    case bottom
    case right
}

class HWebActionView: UIControl {

    /// imageView大小
    var imageSize: CGSize = .zero
    
    /// imageView和titleLabel之间的间隔
    var imageSpace: CGFloat = 0.0
    
    /// imageView布局方向
    var imagePosition: HWebActionDirection = .left

    // The tintColor in the parent class is problematic
    var renderColor: UIColor?

    private var _imageView: UIImageView?
    private var imageView: UIImageView {
        if _imageView == nil {
            _imageView = UIImageView()
            _imageView!.backgroundColor = .clear
            _imageView!.layer.masksToBounds = true
            _imageView!.contentMode = .scaleAspectFill
            _imageView!.isUserInteractionEnabled = false
        }
        return _imageView!
    }

    private var _titleLabel: UILabel?
    var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel!.backgroundColor = .clear
            _titleLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _titleLabel!
    }
    
    
    var hasImage: Bool {
        return imageView.image != nil
    }
    var pressed: Callback?
    var didGetImage: Callback?
    var didGetError: Callback?

    
    /// 左边布局View
    private lazy var leftView: UIView = {
        return UIView()
    }()

    /// 右边布局View
    private lazy var rightView: UIView = {
        return UIView()
    }()
    
    private var lastURL: String = ""
    // Click time
    private var pressedInterval: TimeInterval = 0.0
    
    /// 用于imageView和titleLabel布局
    private lazy var layoutView: UIStackView = {
        let layoutView = UIStackView(frame: self.bounds)
        layoutView.isUserInteractionEnabled = false
        layoutView.distribution = .fill
        layoutView.alignment = .center
        layoutView.axis = .horizontal
        self.addSubview(layoutView)
        return layoutView
    }()

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
        self.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
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
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        switch imagePosition {
        case .left, .right:
            size.width += imageSpace
        case .top, .bottom:
            let titleHeight = _titleLabel?.height ?? 0
            let imageHeight = _imageView?.height ?? 0
            size.height = imageSpace + titleHeight + imageHeight
        }
        return size
    }
    
    override func layoutSubviews() {
        // 更新布局
        self.updateSubviews()
    }

    private func updateSubviews(_ image: UIImage? = nil) {
        
        if let image = image ?? self.imageView.image {
            if self.imageSize == .zero {
                self.imageSize = image.size
                if self.imageSize == .zero ||
                    self.imageSize.width > self.bounds.size.width ||
                    self.imageSize.height > self.bounds.size.height {
                    self.imageSize = self.bounds.size
                    switch imagePosition {
                    case .left, .right:
                        self.imageSize.width -= imageSpace
                        self.imageSize.width -= titleLabel.intrinsicContentSize.width
                    case .top, .bottom:
                        self.imageSize.height -= imageSpace
                        self.imageSize.height -= titleLabel.intrinsicContentSize.height
                    }
                }
            }
            let tmpImage = image.cropImage(self.imageSize)
            if let renderColor = self.renderColor {
                self.imageView.tintColor = renderColor
                self.imageView.image = tmpImage?.withRenderingMode(.alwaysTemplate)
            } else {
                self.imageView.image = tmpImage
            }
        }
        
        // 更新image和text坐标
        updatePosition()
    }
    
    // 更新布局
    private func updatePosition() {

        /// 左边布局View
        layoutView.addArrangedSubview(leftView)
        
        switch imagePosition {
        case .top:
            
            var imageHeight = 0.0
            var textHeight = 0.0

            layoutView.addArrangedSubview(imageView)
            imageHeight = imageSize.height
            imageHeight = max(imageHeight, 0)

            layoutView.addArrangedSubview(titleLabel)
            textHeight = titleLabel.intrinsicContentSize.height
            textHeight = max(textHeight, 0)

            /// 设置imageView和titleLabel之间的间隔
            layoutView.setCustomSpacing(imageSpace, after: imageView)

            /// 上下两边的间隔
            let space = (self.height - imageHeight - textHeight - imageSpace) / 2
            if space >= 0 { layoutView.spacing = space }

            /// 设置布局方向
            layoutView.axis = .vertical
            
        case .left:
            
            var imageWidth = 0.0
            var textWidth = 0.0

            layoutView.addArrangedSubview(imageView)
            imageWidth = imageSize.width
            imageWidth = max(imageWidth, 0)
            
            layoutView.addArrangedSubview(titleLabel)
            textWidth = titleLabel.intrinsicContentSize.width
            textWidth = max(textWidth, 0)

            /// 设置imageView和titleLabel之间的间隔
            layoutView.setCustomSpacing(imageSpace, after: imageView)
            
            /// 左右两边的间隔
            let space = (self.width - imageWidth - textWidth - imageSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .horizontal
            
        case .bottom:
            
            var textHeight = 0.0
            var imageHeight = 0.0

            layoutView.addArrangedSubview(titleLabel)
            textHeight = titleLabel.intrinsicContentSize.height
            textHeight = max(textHeight, 0)

            layoutView.addArrangedSubview(imageView)
            imageHeight = imageSize.height
            imageHeight = max(imageHeight, 0)

            /// 设置imageView和titleLabel之间的间隔
            layoutView.setCustomSpacing(imageSpace, after: titleLabel)

            /// 上下两边的间隔
            let space = (self.height - textHeight - imageHeight - imageSpace) / 2
            if space >= 0 { layoutView.spacing = space }

            /// 设置布局方向
            layoutView.axis = .vertical
            
        case .right:
            
            var textWidth = 0.0
            var imageWidth = 0.0

            layoutView.addArrangedSubview(titleLabel)
            textWidth = titleLabel.intrinsicContentSize.width
            textWidth = max(textWidth, 0)

            layoutView.addArrangedSubview(imageView)
            imageWidth = imageSize.width
            imageWidth = max(imageWidth, 0)

            /// 设置imageView和titleLabel之间的间隔
            layoutView.setCustomSpacing(imageSpace, after: titleLabel)
            
            /// 左右两边的间隔
            let space = (self.width - textWidth - imageWidth - imageSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .horizontal
            
        }

        /// 右边布局View
        layoutView.addArrangedSubview(rightView)

    }

}

extension HWebActionView {

    /**
    *  Set image directly
    *
    *  @param image image
    */
    private func _setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            if image != nil {
                self.updateSubviews(image)
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
            didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(urlString)"))
            return
        }

        if urlString.hasPrefix("http") == false {
            let image = UIImage(named: urlString)
            self._setImage(image)
            self.imageView.alpha = 1.0
            didGetImage?(self, imageView.image)
            return
        }
        if self.imageView.image != nil && lastURL.isEqual(urlString) {
            self.imageView.alpha = 1.0
            didGetImage?(self, imageView.image)
            return
        }

        if placeholder == nil && self.imageView.image == nil {
            self.imageView.alpha = 0
        }

        //self._setImage(nil)
        self.lastURL = ""
        
        guard let url = URL(string: urlString) else {
            return
        }

        if cache {
            KingfisherManager.shared.cache.retrieveImage(forKey: urlString) { result in
                DispatchQueue.main.async {
                    switch result {
                    case.success(let value):
                        if value.image != nil {
                            self._setImage(value.image)
                            self.imageView.alpha = 1.0
                            self.lastURL = url.absoluteString
                            self.didGetImage?(self, value.image)
                        }
                    case .failure(_): break
                    }
                }
            }
        }
        
        //imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString
                        if value.cacheType == .none {
                            UIView.animate(withDuration: 0.5) {
                                self.imageView.alpha = 1.0
                            }
                        }else {
                            self.imageView.alpha = 1.0
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
    func setImage(WithFile fileName: String) {
        if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
           let image = UIImage(contentsOfFile: filePath) {
            self._setImage(image)
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
    func setImage(named fileName: String) {
        if let image = UIImage(named: fileName) {
            self._setImage(image)
        }else {
            self._setImage(nil)
            self.lastURL = ""
            didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(fileName)"))
        }
    }
    
    func setImage(_ image: UIImage?) {
        if image != nil {
            self._setImage(image)
        }else {
            self._setImage(nil)
            self.lastURL = ""
        }
    }

}
