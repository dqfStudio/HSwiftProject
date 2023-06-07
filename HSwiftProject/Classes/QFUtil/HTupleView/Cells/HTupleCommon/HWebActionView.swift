//
//  HWebActionView.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/7.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Kingfisher

class HWebActionView: UIButton {

    enum Position {
        case top
        case left
        case bottom
        case right
    }

    var imageSpace: CGFloat = 0.0
    var imagePosition: Position = .left
    private var originBounds: CGRect = .zero

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
            self.imageView?.tintColor = color
            self.setImage(self.image(for:.normal)?.withRenderingMode(.alwaysTemplate), for:.normal)
        }
    }

    var hasImage: Bool {
        return self.imageView?.image != nil
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
        self.initialize()
    }

    private func initialize() {
        self.backgroundColor = UIColor.clear
        self.imageView?.contentMode = .scaleAspectFill
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.layer.masksToBounds = true
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

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.superview != nil, originBounds != bounds {
            originBounds = bounds
            updatePosition()
        }
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


extension HWebActionView {

    private func _setImage(_ image: UIImage?) {
        self.imageView?.kf.cancelDownloadTask()
        guard let image = image else {
            self.imageView?.image = nil
            return
        }
        if let renderColor = renderColor {
            self.imageView?.tintColor = renderColor
            self.imageView?.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            self.imageView?.image = image
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
        self.imageView?.alpha = 1
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
            let image = UIImage(named: urlString)
            self._setImage(image)
            self.imageView?.alpha = 1
            didGetImage?(self, self.imageView?.image)
            return
        }

        if self.imageView?.image != nil, lastURL.isEqual(urlString) {
            self.imageView?.alpha = 1
            didGetImage?(self, self.imageView?.image)
            return
        }

        if self.imageView?.image == nil, placeholder == nil {
            self.imageView?.alpha = 0
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
                        self.imageView?.alpha = 1
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        if self.imageView?.image == nil {
            //self.imageView?.kf.indicatorType = .activity
            self.imageView?.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self._setImage(value.image)
                    self.lastURL = url.absoluteString
                    if value.cacheType == .none {
                        UIView.animate(withDuration: 0.25) {
                            self.imageView?.alpha = 1
                        }
                    }else {
                        self.imageView?.alpha = 1
                    }
                    self.didGetImage?(self, value.image)
                case .failure(let value):
                    self.didGetError?(self, value)
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

}
