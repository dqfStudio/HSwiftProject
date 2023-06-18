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
    var imageView: UIImageView {
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
        layoutView.axis = .horizontal
        layoutView.distribution = .fill
        layoutView.alignment = .center
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
        super.layoutSubviews()

        /// 左边布局View
        layoutView.addArrangedSubview(leftView)
        
        switch imagePosition {
        case .top:
            
            var imageHeight = 0.0
            var textHeight = 0.0
            var textSpace = imageSpace

            if let imageView = _imageView {
                layoutView.addArrangedSubview(imageView)
                
                imageHeight = imageView.intrinsicContentSize.height
                imageHeight = ceil(imageHeight)//向上取整
            }

            if let titleLabel = _titleLabel {
                titleLabel.textAlignment = .center
                layoutView.addArrangedSubview(titleLabel)
                
                textHeight = titleLabel.intrinsicContentSize.height
                textHeight = ceil(textHeight)//向上取整
            }

            /// 设置imageView和titleLabel之间的间隔
            if let imageView = _imageView, _titleLabel != nil {
                layoutView.setCustomSpacing(textSpace, after: imageView)
            } else {
                textSpace = 0.0
            }

            /// 上下两边的间隔
            let space = (self.height - imageHeight - textHeight - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }

            /// 设置布局方向
            layoutView.axis = .vertical
            
        case .left:
            
            var imageWidth = 0.0
            var textWidth = 0.0
            var textSpace = imageSpace
            
            if let imageView = _imageView {
                imageView.contentMode = (_titleLabel != nil) ? .right : .center
                layoutView.addArrangedSubview(imageView)

                imageWidth = imageView.intrinsicContentSize.width
                imageWidth = ceil(imageWidth)//向上取整
            }

            if let titleLabel = _titleLabel {
                titleLabel.textAlignment = (_imageView != nil) ? .left : .center
                layoutView.addArrangedSubview(titleLabel)

                textWidth = titleLabel.intrinsicContentSize.width
                textWidth = ceil(textWidth)//向上取整
            }

            /// 设置imageView和titleLabel之间的间隔
            if let imageView = _imageView, _titleLabel != nil {
                layoutView.setCustomSpacing(textSpace, after: imageView)
            } else {
                textSpace = 0.0
            }
            
            /// 左右两边的间隔
            let space = (self.width - imageWidth - textWidth - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .horizontal
            
        case .bottom:
            
            var textHeight = 0.0
            var imageHeight = 0.0
            var textSpace = imageSpace
            
            if let titleLabel = _titleLabel {
                titleLabel.textAlignment = .center
                layoutView.addArrangedSubview(titleLabel)
                
                textHeight = titleLabel.intrinsicContentSize.height
                textHeight = ceil(textHeight)//向上取整
            }

            if let imageView = _imageView {
                layoutView.addArrangedSubview(imageView)
                
                imageHeight = imageView.intrinsicContentSize.height
                imageHeight = ceil(imageHeight)//向上取整
            }

            /// 设置imageView和titleLabel之间的间隔
            if let titleLabel = _titleLabel, _imageView != nil {
                layoutView.setCustomSpacing(textSpace, after: titleLabel)
            } else {
                textSpace = 0.0
            }

            /// 上下两边的间隔
            let space = (self.height - textHeight - imageHeight - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }

            /// 设置布局方向
            layoutView.axis = .vertical
            
        case .right:
            
            var textWidth = 0.0
            var imageWidth = 0.0
            var textSpace = imageSpace
            
            if let titleLabel = _titleLabel {
                titleLabel.textAlignment = (_imageView != nil) ? .right : .center
                layoutView.addArrangedSubview(titleLabel)

                textWidth = titleLabel.intrinsicContentSize.width
                textWidth = ceil(textWidth)//向上取整
            }

            if let imageView = _imageView {
                imageView.contentMode = (_titleLabel != nil) ? .left : .center
                layoutView.addArrangedSubview(imageView)

                imageWidth = imageView.intrinsicContentSize.width
                imageWidth = ceil(imageWidth)//向上取整
            }

            /// 设置imageView和titleLabel之间的间隔
            if let titleLabel = _titleLabel, _imageView != nil {
                layoutView.setCustomSpacing(textSpace, after: titleLabel)
            } else {
                textSpace = 0.0
            }
            
            /// 左右两边的间隔
            let space = (self.width - textWidth - imageWidth - textSpace) / 2
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
            self.imageView.kf.cancelDownloadTask()
            guard let tmpImage = image else {
                self.imageView.image = nil
                return
            }
            var image: UIImage? = tmpImage
            if self.imageSize != .zero {
                image = image?.cropImage(self.imageSize)
            }
            if let renderColor = self.renderColor {
                self.imageView.tintColor = renderColor
                self.imageView.image = image?.withRenderingMode(.alwaysTemplate)
            } else {
                self.imageView.image = image
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
            self._setImage(nil)
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
        if imageView.image != nil && lastURL.isEqual(urlString) {
            self.imageView.alpha = 1.0
            didGetImage?(self, imageView.image)
            return
        }

        if placeholder == nil && imageView.image == nil {
            self.imageView.alpha = 0
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
                        self.imageView.alpha = 1.0
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        
        //imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
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
    func setImage(WithName fileName: String) {
        if let image = UIImage(named: fileName) {
            self._setImage(image)
        }else {
            self._setImage(nil)
            self.lastURL = ""
            didGetError?(self, herr(kDataFormatErrorCode, desc: "url = \(fileName)"))
        }
    }

}
