//
//  HCollView+DeviceAdaptation.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 设备适配扩展
///
/// 为HCollView添加折叠屏、高刷新率屏幕等设备的适配支持
extension HCollView {
    
    /// 设备适配管理器
    class DeviceAdaptationManager {
        
        // MARK: - 单例
        static let shared = DeviceAdaptationManager()
        private init() {}
        
        // MARK: - 属性
        
        /// 当前设备类型
        let deviceType: DeviceType
        
        /// 当前屏幕类型
        let screenType: ScreenType
        
        /// 屏幕尺寸
        let screenSize: CGSize
        
        /// 是否是高刷新率屏幕
        let isHighRefreshRateScreen: Bool
        
        /// 屏幕刷新率
        let screenRefreshRate: Double
        
        // MARK: - 设备类型
        
        /// 设备类型
        enum DeviceType {
            case iPhone
            case iPad
            case Mac
            case AppleTV
            case unknown
        }
        
        /// 屏幕类型
        enum ScreenType {
            case regular         // 常规屏幕
            case foldable        // 折叠屏
            case highRefreshRate // 高刷新率屏幕
            case unknown         // 未知屏幕
        }
        
        // MARK: - 初始化
        
        /// 初始化
        init() {
            // 检测设备类型
            deviceType = detectDeviceType()
            
            // 检测屏幕尺寸
            screenSize = UIScreen.main.bounds.size
            
            // 检测屏幕类型
            screenType = detectScreenType()
            
            // 检测是否是高刷新率屏幕
            isHighRefreshRateScreen = detectHighRefreshRateScreen()
            
            // 检测屏幕刷新率
            screenRefreshRate = detectScreenRefreshRate()
        }
        
        // MARK: - 方法
        
        /// 检测设备类型
        /// - Returns: 设备类型
        private func detectDeviceType() -> DeviceType {
            let device = UIDevice.current
            
            if device.userInterfaceIdiom == .phone {
                return .iPhone
            } else if device.userInterfaceIdiom == .pad {
                return .iPad
            } else if device.userInterfaceIdiom == .mac {
                return .Mac
            } else if device.userInterfaceIdiom == .tv {
                return .AppleTV
            } else {
                return .unknown
            }
        }
        
        /// 检测屏幕类型
        /// - Returns: 屏幕类型
        private func detectScreenType() -> ScreenType {
            // 检测折叠屏
            if UIDevice.current.hasFoldableDisplay {
                return .foldable
            }
            
            // 检测高刷新率屏幕
            if detectHighRefreshRateScreen() {
                return .highRefreshRate
            }
            
            return .regular
        }
        
        /// 检测是否是高刷新率屏幕
        /// - Returns: 是否是高刷新率屏幕
        private func detectHighRefreshRateScreen() -> Bool {
            if #available(iOS 13.0, *) {
                return UIScreen.main.maximumFramesPerSecond > 60
            } else {
                return false
            }
        }
        
        /// 检测屏幕刷新率
        /// - Returns: 屏幕刷新率
        private func detectScreenRefreshRate() -> Double {
            if #available(iOS 13.0, *) {
                return Double(UIScreen.main.maximumFramesPerSecond)
            } else {
                return 60.0
            }
        }
        
        /// 适配设备
        /// - Parameter collectionView: 集合视图
        func adaptToDevice(_ collectionView: HCollView) {
            // 适配折叠屏
            if screenType == .foldable {
                adaptToFoldableDisplay(collectionView)
            }
            
            // 适配高刷新率屏幕
            if screenType == .highRefreshRate {
                adaptToHighRefreshRateScreen(collectionView)
            }
            
            // 适配屏幕尺寸
            adaptToScreenSize(collectionView)
        }
        
        /// 适配折叠屏
        /// - Parameter collectionView: 集合视图
        private func adaptToFoldableDisplay(_ collectionView: HCollView) {
            // 监听折叠状态变化
            NotificationCenter.default.addObserver(
                forName: UIDevice.foldStateDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateForFoldState(collectionView)
            }
            
            // 初始更新
            updateForFoldState(collectionView)
        }
        
        /// 更新折叠状态
        /// - Parameter collectionView: 集合视图
        private func updateForFoldState(_ collectionView: HCollView) {
            // 根据折叠状态调整布局
            if UIDevice.current.isFolded {
                // 折叠状态
                adjustLayoutForFoldedState(collectionView)
            } else {
                // 展开状态
                adjustLayoutForUnfoldedState(collectionView)
            }
        }
        
        /// 调整折叠状态的布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForFoldedState(_ collectionView: HCollView) {
            // 折叠状态的布局调整
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: collectionView.bounds.width - 20, height: 100)
                collectionView.reloadData()
            }
        }
        
        /// 调整展开状态的布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForUnfoldedState(_ collectionView: HCollView) {
            // 展开状态的布局调整
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = (collectionView.bounds.width - 30) / 2
                layout.itemSize = CGSize(width: itemWidth, height: 100)
                collectionView.reloadData()
            }
        }
        
        /// 适配高刷新率屏幕
        /// - Parameter collectionView: 集合视图
        private func adaptToHighRefreshRateScreen(_ collectionView: HCollView) {
            // 启用预渲染
            collectionView.prefetchingEnabled = true
            
            // 优化动画
            if #available(iOS 10.0, *) {
                UIView.setAnimationsEnabled(true)
            }
        }
        
        /// 适配屏幕尺寸
        /// - Parameter collectionView: 集合视图
        private func adaptToScreenSize(_ collectionView: HCollView) {
            // 根据屏幕尺寸调整布局
            if screenSize.width < 375 {
                // 小屏幕
                adjustLayoutForSmallScreen(collectionView)
            } else if screenSize.width > 768 {
                // 大屏幕
                adjustLayoutForLargeScreen(collectionView)
            } else {
                // 中等屏幕
                adjustLayoutForMediumScreen(collectionView)
            }
        }
        
        /// 调整小屏幕的布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForSmallScreen(_ collectionView: HCollView) {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: collectionView.bounds.width - 20, height: 80)
                layout.minimumInteritemSpacing = 5
                layout.minimumLineSpacing = 5
                collectionView.reloadData()
            }
        }
        
        /// 调整中等屏幕的布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForMediumScreen(_ collectionView: HCollView) {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = (collectionView.bounds.width - 30) / 2
                layout.itemSize = CGSize(width: itemWidth, height: 100)
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
                collectionView.reloadData()
            }
        }
        
        /// 调整大屏幕的布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForLargeScreen(_ collectionView: HCollView) {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = (collectionView.bounds.width - 40) / 3
                layout.itemSize = CGSize(width: itemWidth, height: 120)
                layout.minimumInteritemSpacing = 10
                layout.minimumLineSpacing = 10
                collectionView.reloadData()
            }
        }
        
        /// 检测是否是横屏
        /// - Returns: 是否是横屏
        func isLandscape() -> Bool {
            return UIDevice.current.orientation.isLandscape
        }
        
        /// 检测是否是竖屏
        /// - Returns: 是否是竖屏
        func isPortrait() -> Bool {
            return UIDevice.current.orientation.isPortrait
        }
        
        /// 适配横竖屏
        /// - Parameter collectionView: 集合视图
        func adaptToOrientation(_ collectionView: HCollView) {
            // 监听屏幕旋转
            NotificationCenter.default.addObserver(
                forName: UIDevice.orientationDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateForOrientation(collectionView)
            }
            
            // 初始更新
            updateForOrientation(collectionView)
        }
        
        /// 更新横竖屏状态
        /// - Parameter collectionView: 集合视图
        private func updateForOrientation(_ collectionView: HCollView) {
            if isLandscape() {
                // 横屏
                adjustLayoutForLandscape(collectionView)
            } else if isPortrait() {
                // 竖屏
                adjustLayoutForPortrait(collectionView)
            }
        }
        
        /// 调整横屏布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForLandscape(_ collectionView: HCollView) {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = (collectionView.bounds.width - 40) / 3
                layout.itemSize = CGSize(width: itemWidth, height: 100)
                collectionView.reloadData()
            }
        }
        
        /// 调整竖屏布局
        /// - Parameter collectionView: 集合视图
        private func adjustLayoutForPortrait(_ collectionView: HCollView) {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                let itemWidth = (collectionView.bounds.width - 30) / 2
                layout.itemSize = CGSize(width: itemWidth, height: 100)
                collectionView.reloadData()
            }
        }
    }
    
    /// 设备适配管理器
    var deviceAdaptationManager: DeviceAdaptationManager {
        return DeviceAdaptationManager.shared
    }
    
    /// 适配设备
    func adaptToDevice() {
        deviceAdaptationManager.adaptToDevice(self)
    }
    
    /// 适配横竖屏
    func adaptToOrientation() {
        deviceAdaptationManager.adaptToOrientation(self)
    }
    
    /// 获取设备类型
    /// - Returns: 设备类型
    func getDeviceType() -> DeviceAdaptationManager.DeviceType {
        return deviceAdaptationManager.deviceType
    }
    
    /// 获取屏幕类型
    /// - Returns: 屏幕类型
    func getScreenType() -> DeviceAdaptationManager.ScreenType {
        return deviceAdaptationManager.screenType
    }
    
    /// 获取屏幕尺寸
    /// - Returns: 屏幕尺寸
    func getScreenSize() -> CGSize {
        return deviceAdaptationManager.screenSize
    }
    
    /// 是否是高刷新率屏幕
    /// - Returns: 是否是高刷新率屏幕
    func isHighRefreshRateScreen() -> Bool {
        return deviceAdaptationManager.isHighRefreshRateScreen
    }
    
    /// 获取屏幕刷新率
    /// - Returns: 屏幕刷新率
    func getScreenRefreshRate() -> Double {
        return deviceAdaptationManager.screenRefreshRate
    }
    
    /// 是否是横屏
    /// - Returns: 是否是横屏
    func isLandscape() -> Bool {
        return deviceAdaptationManager.isLandscape()
    }
    
    /// 是否是竖屏
    /// - Returns: 是否是竖屏
    func isPortrait() -> Bool {
        return deviceAdaptationManager.isPortrait()
    }
}

/// UIDevice 扩展，用于检测折叠屏
extension UIDevice {
    /// 是否有折叠屏
    var hasFoldableDisplay: Bool {
        if #available(iOS 14.0, *) {
            return traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact
        } else {
            return false
        }
    }
    
    /// 是否处于折叠状态
    var isFolded: Bool {
        if #available(iOS 14.0, *) {
            return traitCollection.horizontalSizeClass == .compact
        } else {
            return true
        }
    }
    
    /// 折叠状态变化通知
    static let foldStateDidChangeNotification = Notification.Name("UIDeviceFoldStateDidChangeNotification")
}
