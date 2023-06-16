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
    
    var didGetImage: Callback?
    var didGetError: Callback?
    
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
    
    /**
    *  Set image directly
    *
    *  @param image image
    */
    private func _setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            super.kf.cancelDownloadTask()
            super.image = image
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
            didGetImage?(self, self.image)
            return
        }
        if self.image != nil && lastURL.isEqual(urlString) {
            didGetImage?(self, self.image)
            return
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
                        self.lastURL = url.absoluteString
                        self.didGetImage?(self, value.image)
                    }
                case .failure(_): break
                }
            }
        }
        //self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, options: [.transition(ImageTransition.fade(1))], progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self._setImage(value.image)
                self.lastURL = url.absoluteString
                self.didGetImage?(self, value.image)
            case .failure(let value):
                self.didGetError?(self, value as AnyObject)
            }
        }
    }
}

extension UIImageView {
    convenience init(named: String) {
        self.init(image: UIImage(named: named))
    }
    func setImage(WithFile fileName: String) {
        if let filePath = Bundle.main.resourcePath?.appendingFormat("/%@", fileName),
           let image = UIImage(contentsOfFile: filePath) {
            self.image = image
        }
    }
    func setImage(WithName fileName: String) {
        if let image = UIImage(named: fileName) {
            self.image = image
        }
    }
    func setImage(_ image: UIImage?) {
        self.image = image
    }
}
