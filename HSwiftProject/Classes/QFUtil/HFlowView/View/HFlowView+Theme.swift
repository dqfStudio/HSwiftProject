//
//  HFlowView+Theme.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 主题类型枚举
enum HFlowThemeType {
    case light      // 浅色主题
    case dark       // 深色主题
    case custom     // 自定义主题
}

/// 主题颜色结构体
struct HFlowThemeColors {
    /// 背景颜色
    var backgroundColor: UIColor
    /// 文本颜色
    var textColor: UIColor
    /// 次要文本颜色
    var secondaryTextColor: UIColor
    /// 分割线颜色
    var separatorColor: UIColor
    /// 选中颜色
    var selectionColor: UIColor
    /// 强调颜色
    var accentColor: UIColor
    
    /// 浅色主题
    static let light = HFlowThemeColors(
        backgroundColor: .white,
        textColor: .black,
        secondaryTextColor: .gray,
        separatorColor: .lightGray,
        selectionColor: UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 0.5),
        accentColor: .systemBlue
    )
    
    /// 深色主题
    static let dark = HFlowThemeColors(
        backgroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0),
        textColor: .white,
        secondaryTextColor: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
        separatorColor: UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0),
        selectionColor: UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 0.5),
        accentColor: .systemBlue
    )
}

/// 主题字体结构体
struct HFlowThemeFonts {
    /// 标题字体
    var titleFont: UIFont
    /// 正文字体
    var bodyFont: UIFont
    /// 次要文本字体
    var secondaryFont: UIFont
    
    /// 默认字体
    static let `default` = HFlowThemeFonts(
        titleFont: UIFont.systemFont(ofSize: 18, weight: .bold),
        bodyFont: UIFont.systemFont(ofSize: 16, weight: .regular),
        secondaryFont: UIFont.systemFont(ofSize: 14, weight: .light)
    )
}

/// 主题结构体
struct HFlowTheme {
    /// 主题类型
    var type: HFlowThemeType
    /// 主题颜色
    var colors: HFlowThemeColors
    /// 主题字体
    var fonts: HFlowThemeFonts
    
    /// 浅色主题
    static let light = HFlowTheme(
        type: .light,
        colors: .light,
        fonts: .default
    )
    
    /// 深色主题
    static let dark = HFlowTheme(
        type: .dark,
        colors: .dark,
        fonts: .default
    )
}

/// HFlowView 主题支持扩展
///
/// 为 HFlowView 提供主题支持，使其能够响应系统主题变化，并且支持自定义主题
///
/// 实现功能：
/// 1. 支持系统主题自动切换
/// 2. 支持自定义主题
/// 3. 提供主题颜色和字体管理
/// 4. 响应主题变化事件

// 关联对象的键
private var ThemeKey: UInt8 = 0
private var followSystemThemeKey: UInt8 = 0

extension HFlowView {
    
    // MARK: - Theme Properties
    
    /// 当前主题
    public var currentTheme: HFlowTheme {
        get {
            if let theme = objc_getAssociatedObject(self, &ThemeKey) as? HFlowTheme {
                return theme
            }
            return .light
        }
        set {
            objc_setAssociatedObject(self, &ThemeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applyTheme(newValue)
        }
    }
    
    /// 是否跟随系统主题
    public var followSystemTheme: Bool {
        get {
            if let follow = objc_getAssociatedObject(self, &followSystemThemeKey) as? Bool {
                return follow
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &followSystemThemeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Theme Methods
    
    /// 初始化主题支持
    func setupThemeSupport() {
        // 监听系统主题变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSystemThemeChange),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // 应用初始主题
        if followSystemTheme {
            updateThemeFromSystem()
        } else {
            applyTheme(currentTheme)
        }
    }
    
    /// 处理系统主题变化
    @objc private func handleSystemThemeChange() {
        if followSystemTheme {
            updateThemeFromSystem()
        }
    }
    
    /// 从系统获取主题
    func updateThemeFromSystem() {
        let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        let newTheme: HFlowTheme
        
        switch userInterfaceStyle {
        case .dark:
            newTheme = .dark
        case .light, .unspecified:
            newTheme = .light
        @unknown default:
            newTheme = .light
        }
        
        currentTheme = newTheme
    }
    
    /// 应用主题
    /// - Parameter theme: 要应用的主题
    func applyTheme(_ theme: HFlowTheme) {
        backgroundColor = theme.colors.backgroundColor
        separatorColor = theme.colors.separatorColor
        tintColor = theme.colors.selectionColor
        flowDelegate?.themeDidChange(theme)
        reloadFlowDataIncremental()
    }
    
    /// 切换到浅色主题
    func switchToLightTheme() {
        followSystemTheme = false
        currentTheme = .light
    }
    
    /// 切换到深色主题
    func switchToDarkTheme() {
        followSystemTheme = false
        currentTheme = .dark
    }
    
    /// 切换到自定义主题
    /// - Parameter theme: 自定义主题
    func switchToCustomTheme(_ theme: HFlowTheme) {
        followSystemTheme = false
        currentTheme = theme
    }
    
    /// 获取当前主题的颜色
    /// - Parameter colorType: 颜色类型
    /// - Returns: 颜色
    func getThemeColor(_ colorType: String) -> UIColor {
        switch colorType {
        case "background":
            return currentTheme.colors.backgroundColor
        case "text":
            return currentTheme.colors.textColor
        case "secondaryText":
            return currentTheme.colors.secondaryTextColor
        case "separator":
            return currentTheme.colors.separatorColor
        case "selection":
            return currentTheme.colors.selectionColor
        case "accent":
            return currentTheme.colors.accentColor
        default:
            return currentTheme.colors.textColor
        }
    }
    
    /// 获取当前主题的字体
    /// - Parameter fontType: 字体类型
    /// - Returns: 字体
    func getThemeFont(_ fontType: String) -> UIFont {
        switch fontType {
        case "title":
            return currentTheme.fonts.titleFont
        case "body":
            return currentTheme.fonts.bodyFont
        case "secondary":
            return currentTheme.fonts.secondaryFont
        default:
            return currentTheme.fonts.bodyFont
        }
    }
}

/// 扩展 HFlowViewDelegate，添加主题相关方法
extension HFlowViewDelegate {
    /// 当主题变化时调用
    /// - Parameter theme: 新的主题
    func themeDidChange(_ theme: HFlowTheme) {
        // 默认实现为空
    }
    
    /// 获取指定 cell 的主题颜色
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - colorType: 颜色类型
    /// - Returns: 颜色
    func themeColorForCell(at indexPath: IndexPath, colorType: String) -> UIColor? {
        return nil
    }
    
    /// 获取指定 cell 的主题字体
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - fontType: 字体类型
    /// - Returns: 字体
    func themeFontForCell(at indexPath: IndexPath, fontType: String) -> UIFont? {
        return nil
    }
}
