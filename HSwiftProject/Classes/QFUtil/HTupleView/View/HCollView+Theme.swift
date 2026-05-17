//
//  HCollView+Theme.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 主题协议
protocol HCollViewTheme {
    /// 背景色
    var backgroundColor: UIColor { get }
    
    /// 文本颜色
    var textColor: UIColor { get }
    
    /// 强调色
    var accentColor: UIColor { get }
    
    /// 边框颜色
    var borderColor: UIColor { get }
    
    /// 分隔线颜色
    var separatorColor: UIColor { get }
    
    /// 刷新控件颜色
    var refreshControlColor: UIColor { get }
    
    /// 空视图背景色
    var emptyViewBackgroundColor: UIColor { get }
    
    /// 空视图文本颜色
    var emptyViewTextColor: UIColor { get }
}

/// 亮色主题
class HCollViewLightTheme: HCollViewTheme {
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black
    var accentColor: UIColor = .systemBlue
    var borderColor: UIColor = .lightGray
    var separatorColor: UIColor = .lightGray
    var refreshControlColor: UIColor = .gray
    var emptyViewBackgroundColor: UIColor = .white
    var emptyViewTextColor: UIColor = .gray
}

/// 暗色主题
class HCollViewDarkTheme: HCollViewTheme {
    var backgroundColor: UIColor = .black
    var textColor: UIColor = .white
    var accentColor: UIColor = .systemBlue
    var borderColor: UIColor = .darkGray
    var separatorColor: UIColor = .darkGray
    var refreshControlColor: UIColor = .lightGray
    var emptyViewBackgroundColor: UIColor = .black
    var emptyViewTextColor: UIColor = .lightGray
}

/// 主题管理类
class HCollViewThemeManager {
    
    // MARK: - 单例
    static let shared = HCollViewThemeManager()
    private init() {}
    
    // MARK: - 当前主题
    private var _currentTheme: HCollViewTheme = HCollViewLightTheme()
    
    /// 当前主题
    var currentTheme: HCollViewTheme {
        get {
            return _currentTheme
        }
        set {
            _currentTheme = newValue
            // 通知所有 HCollView 实例更新主题
            NotificationCenter.default.post(name: .HCollViewThemeChanged, object: nil)
        }
    }
    
    /// 设置亮色主题
    func setLightTheme() {
        currentTheme = HCollViewLightTheme()
    }
    
    /// 设置暗色主题
    func setDarkTheme() {
        currentTheme = HCollViewDarkTheme()
    }
    
    /// 根据系统设置自动切换主题
    func setSystemTheme() {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            setDarkTheme()
        } else {
            setLightTheme()
        }
    }
}

/// 通知名称扩展
extension Notification.Name {
    static let HCollViewThemeChanged = Notification.Name("HCollViewThemeChanged")
}

/// HCollView 主题扩展
///
/// 提供主题支持
extension HCollView {
    
    /// 应用主题
    func applyTheme() {
        let theme = HCollViewThemeManager.shared.currentTheme
        
        // 应用主题颜色
        backgroundColor = theme.backgroundColor
        
        // 应用到空视图
        if let emptyView = emptyView {
            emptyView.backgroundColor = theme.emptyViewBackgroundColor
            
            // 应用到空视图的子视图
            for subview in emptyView.subviews {
                if let label = subview as? UILabel {
                    label.textColor = theme.emptyViewTextColor
                }
            }
        }
        
        // 应用到刷新控件
        // MJRefresh types not available in Swift without bridging header

    }
    
    /// 注册主题变化通知
    func registerForThemeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeChanged),
            name: .HCollViewThemeChanged,
            object: nil
        )
    }
    
    /// 主题变化回调
    @objc private func themeChanged() {
        applyTheme()
        (self as UICollectionView).reloadData()
    }
    
    /// 取消注册主题变化通知
    func unregisterForThemeChanges() {
        NotificationCenter.default.removeObserver(self, name: .HCollViewThemeChanged, object: nil)
    }
}
