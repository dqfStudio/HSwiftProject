//
//  HWebActionView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Kingfisher

enum HActionDirection: Int {
    case horizontal = 0 // Horizontal design
    case vertical = 1 // Vertical design
}

enum HActionImageDirection: Int {
    case left = 0 // Left design
    case right = 1 // Right design
}

class HWebActionView: UIControl {
    
    /// 布局方向，横向或纵向布局
    var direction: HActionDirection = .horizontal
    
    /// image布局方向，左向或右向布局
    var imageDirection: HActionImageDirection = .left
    
    /// imageView和titleLabel之间的间隔
    var spacing: CGFloat = 5.0
    
    /// 左边布局View
    private lazy var leftView: UIView = {
        return UIView()
    }()
    
    /// 右边布局View
    private lazy var rightView: UIView = {
        return UIView()
    }()
    
    private var _imageView: UIImageView?
    var imageView: UIImageView {
        if _imageView == nil {
            _imageView = UIImageView()
            _imageView!.layer.masksToBounds = true
        }
        return _imageView!
    }
    
    private var _titleLabel: UILabel?
    var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
        }
        return _titleLabel!
    }
    
    /// 用于imageView和titleLabel布局
    private lazy var layoutView: UIStackView = {
        let layoutView = UIStackView(frame: self.bounds)
        layoutView.axis = .horizontal
        layoutView.distribution = .fill
        layoutView.alignment = .center
        self.addSubview(layoutView)
        return layoutView
    }()
    
    private var lastURL: String = ""
    // Click time
    private var pressedInterval: TimeInterval = 0.0
    
    // The tintColor in the parent class is problematic
    var renderColor: UIColor? {
        didSet {
            guard let color = renderColor else {
                imageView.image = imageView.image?.withRenderingMode(.alwaysOriginal)
                return
            }
            imageView.tintColor = color
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var hasImage: Bool {
        return _imageView?.image != nil
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
    
    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }
            var _frame = frame
            _frame.origin = .zero
            layoutView.frame = _frame
        }
    }

    private func setup() {
        self.addTarget(self, action: #selector(buttonPressed), for:.touchUpInside)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 左边布局View
        layoutView.addArrangedSubview(leftView)
        
        if direction == .horizontal {
            
            var textWidth1 = 0.0
            var textWidth2 = 0.0
            var textSpace = spacing
            
            if imageDirection == .left {
              
                if let imageView = _imageView {
                    imageView.contentMode = (_titleLabel != nil) ? .right : .center
                    layoutView.addArrangedSubview(imageView)
                    
                    textWidth1 = imageView.intrinsicContentSize.width
                    textWidth1 = ceil(textWidth1)//向上取整
                }
                
                if let titleLabel = _titleLabel {
                    titleLabel.textAlignment = (_imageView != nil) ? .left : .center
                    layoutView.addArrangedSubview(titleLabel)
                    
                    textWidth2 = titleLabel.intrinsicContentSize.width
                    textWidth2 = ceil(textWidth2)//向上取整
                }
                
                /// 设置imageView和titleLabel之间的间隔
                if let imageView = _imageView, _titleLabel != nil {
                    layoutView.setCustomSpacing(textSpace, after: imageView)
                } else {
                    textSpace = 0.0
                }
                
            } else {
                
                if let titleLabel = _titleLabel {
                    titleLabel.textAlignment = (_imageView != nil) ? .right : .center
                    layoutView.addArrangedSubview(titleLabel)
                    
                    textWidth1 = titleLabel.intrinsicContentSize.width
                    textWidth1 = ceil(textWidth1)//向上取整
                }
                
                if let imageView = _imageView {
                    imageView.contentMode = (_titleLabel != nil) ? .left : .center
                    layoutView.addArrangedSubview(imageView)
                    
                    textWidth2 = imageView.intrinsicContentSize.width
                    textWidth2 = ceil(textWidth2)//向上取整
                }
                
                /// 设置imageView和titleLabel之间的间隔
                if let titleLabel = _titleLabel, _imageView != nil {
                    layoutView.setCustomSpacing(textSpace, after: titleLabel)
                } else {
                    textSpace = 0.0
                }
                
            }
            
            /// 左右两边的间隔
            let space = (self.width - textWidth1 - textWidth2 - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .horizontal
            
        } else {
            
            var textHeight1 = 0.0
            var textHeight2 = 0.0
            var textSpace = spacing

            if let imageView = _imageView {
                layoutView.addArrangedSubview(imageView)
                
                textHeight1 = imageView.intrinsicContentSize.height
                textHeight1 = ceil(textHeight1)//向上取整
            }
            
            if let titleLabel = _titleLabel {
                titleLabel.textAlignment = .center
                layoutView.addArrangedSubview(titleLabel)
                
                textHeight2 = titleLabel.intrinsicContentSize.height
                textHeight2 = ceil(textHeight2)//向上取整
            }
            
            /// 设置imageView和titleLabel之间的间隔
            if let imageView = _imageView, _titleLabel != nil {
                layoutView.setCustomSpacing(textSpace, after: imageView)
            } else {
                textSpace = 0.0
            }
            
            /// 左右两边的间隔
            let space = (self.height - textHeight1 - textHeight2 - textSpace) / 2
            if space >= 0 { layoutView.spacing = space }
            
            /// 设置布局方向
            layoutView.axis = .vertical
            
        }
        
        /// 右边布局View
        layoutView.addArrangedSubview(rightView)
        
    }
    
}

extension HWebActionView {

    private func _setImage(_ image: UIImage?) {
        imageView.kf.cancelDownloadTask()
        guard let image = image else {
            imageView.image = nil
            return
        }
        
        if let renderColor = renderColor {
            imageView.tintColor = renderColor
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            imageView.image = image
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
        self.alpha = 1
        didGetImage?(self, image!)
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
                didGetImage!(self, imageView.image!)
            }
            return
        }
        if imageView.image != nil && lastURL.isEqual(urlString) {
            self.alpha = 1
            if didGetImage != nil {
                didGetImage!(self, imageView.image!)
            }
            return
        }
        
        if placeholder == nil && imageView.image == nil {
            self.alpha = 0
        }
        
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
        if imageView.image == nil {
            //self.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
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
    *  Set the image name and load it through the file
    *
    *  @param fileName image name
    */
    func setImageWithFile(_ fileName: String) {
        if fileName.count > 0 {
            if let resourcePath: String = Bundle.main.resourcePath {
                let filePath: String = resourcePath.appendingFormat("/%@", fileName)
                if let image: UIImage = UIImage(contentsOfFile: filePath) {
                    self.setImage(image)
                }
            }
        }else {
            self._setImage(nil)
            self.lastURL = ""
            if didGetError != nil {
                didGetError!(self, herr(kDataFormatErrorCode, desc: "url = \(fileName)"))
            }
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
    
}
