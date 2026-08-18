//
//  HNavigationItem.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

// MARK: - Type Aliases

typealias HNavigationItemBlock = () -> Void

// MARK: - HNavigationItem

/// 自定义导航栏按钮项
class HNavigationItem: UIButton {
    
    // MARK: - Properties
    
    /// 上次点击时间（单调时钟，避免系统时间回拨）
    private var lastPressedTime: TimeInterval = 0
    
    /// 点击节流间隔
    private let pressedThrottle: TimeInterval = 0.5
    
    /// 批量更新时抑制 refresh，避免 title/image 互相清空导致重复回调
    private var isBatchUpdating = false
    
    /// 刷新回调
    var refresh: HNavigationItemBlock?
    
    /// 点击回调
    var pressed: HNavigationItemBlock?

    /// 禁用状态背景色
    var disableBgColor: UIColor?
    
    /// 禁用状态文字颜色
    var disableTextColor: UIColor?
    
    /// 启用态背景色
    private var storedBackgroundColor: UIColor?
    
    /// 启用态文字颜色
    private var storedTitleColor: UIColor?

    /// 标题（与图片互斥）
    var title: String? {
        get { title(for: .normal) }
        set {
            performBatchUpdate {
                setTitle(newValue, for: .normal)
                setTitle(newValue, for: .highlighted)
                setImage(nil, for: .normal)
                setImage(nil, for: .highlighted)
            }
        }
    }

    /// 图片（与标题互斥）
    override var image: UIImage? {
        get { image(for: .normal) }
        set {
            performBatchUpdate {
                setTitle(nil, for: .normal)
                setTitle(nil, for: .highlighted)
                setImage(newValue, for: .normal)
                setImage(newValue, for: .highlighted)
            }
        }
    }
    
    /// 禁用状态：只在 true→false 时保存颜色，避免连续 disable 覆盖原始值
    override var isEnabled: Bool {
        didSet {
            guard oldValue != isEnabled else { return }
            updateEnabledState()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            imageView?.alpha = 1.0
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: max(size.width, 44), height: max(size.height, 44))
    }

    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .clear
        layer.masksToBounds = true
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = .systemFont(ofSize: 17.0)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.8
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonPressed() {
        guard let pressed = pressed else { return }
        let now = CACurrentMediaTime()
        guard now - lastPressedTime > pressedThrottle else { return }
        lastPressedTime = now
        pressed()
    }
    
    // MARK: - Private Methods
    
    private func performBatchUpdate(_ updates: () -> Void) {
        isBatchUpdating = true
        updates()
        isBatchUpdating = false
        refresh?()
        invalidateIntrinsicContentSize()
    }
    
    private func updateEnabledState() {
        if isEnabled {
            backgroundColor = storedBackgroundColor ?? .clear
            if let storedTitleColor = storedTitleColor {
                setTitleColor(storedTitleColor, for: .normal)
            }
        } else {
            storedBackgroundColor = backgroundColor
            storedTitleColor = titleColor(for: .normal)
            if let disableBgColor = disableBgColor {
                backgroundColor = disableBgColor
            }
            if let disableTextColor = disableTextColor {
                setTitleColor(disableTextColor, for: .normal)
            }
        }
    }
    
    // MARK: - Overrides
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        guard !isBatchUpdating else { return }
        refresh?()
        invalidateIntrinsicContentSize()
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        guard !isBatchUpdating else { return }
        refresh?()
        invalidateIntrinsicContentSize()
    }

}
