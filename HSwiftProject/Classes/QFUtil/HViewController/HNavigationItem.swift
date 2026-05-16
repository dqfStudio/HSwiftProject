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
    
    /// 点击时间间隔
    private var pressedInterval: TimeInterval = 0.0
    
    /// 刷新回调
    var refresh: HNavigationItemBlock?
    
    /// 点击回调
    var pressed: HNavigationItemBlock?

    /// 禁用状态背景色
    var disableBgColor: UIColor?
    
    /// 禁用状态文字颜色
    var disableTextColor: UIColor?

    /// 标题
    var title: String? {
        get { title(for: .normal) }
        set { 
            setTitle(newValue, for: .normal)
            setTitle(newValue, for: .highlighted)
            setImage(nil, for: .normal)
            setImage(nil, for: .highlighted)
        }
    }

    /// 图片
    override var image: UIImage? {
        get { image(for: .normal) }
        set { 
            setTitle(nil, for: .normal)
            setTitle(nil, for: .highlighted)
            setImage(newValue, for: .normal)
            setImage(newValue, for: .highlighted)
        }
    }

    // MARK: - Overrides
    
    /// 原始背景色
    private var originalBgColor: UIColor?
    
    /// 原始文字颜色
    private var originalTextColor: UIColor?
    
    /// 禁用状态
    override var isEnabled: Bool {
        didSet {
            updateEnabledState()
        }
    }
    
    // MARK: - Initialization
    
    required init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .clear
        layer.masksToBounds = true
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font = .systemFont(ofSize: 17.0)
        titleLabel?.adjustsFontSizeToFitWidth = true
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonPressed() {
        guard let pressed = pressed else { return }
        
        // 防抖动处理
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - pressedInterval > 0.5 else { return }
        
        pressedInterval = currentTime
        pressed()
    }
    
    // MARK: - Private Methods
    
    /// 更新启用状态
    private func updateEnabledState() {
        if isEnabled {
            // 恢复原始颜色
            backgroundColor = originalBgColor ?? .clear
            if let originalTextColor = originalTextColor {
                setTitleColor(originalTextColor, for: .normal)
            }
        } else {
            // 保存原始颜色
            originalBgColor = backgroundColor
            originalTextColor = currentTitleColor
            // 设置禁用颜色
            backgroundColor = disableBgColor ?? backgroundColor
            let titleColor = disableTextColor ?? currentTitleColor
            setTitleColor(titleColor, for: .normal)
        }
        isUserInteractionEnabled = isEnabled
    }
    
    // MARK: - Overrides
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        refresh?()
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        refresh?()
    }

}
