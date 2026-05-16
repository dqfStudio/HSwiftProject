//
//  HFlowView+DeviceAdaptation.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// 设备类型枚举
enum HFlowDeviceType {
    case iPhone4S
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case iPhoneX
    case iPhoneXR
    case iPhone11
    case iPhone12
    case iPhone13
    case iPhone14
    case iPhone15
    case iPad
    case iPadPro
    case unknown
}

/// 设备方向枚举
enum HFlowDeviceOrientation {
    case portrait
    case landscape
    case unknown
}

/// HFlowView 设备适配扩展
///
/// 为 HFlowView 提供设备适配功能，使其在不同尺寸和方向的设备上正确显示
///
/// 实现功能：
/// 1. 自动适配不同设备尺寸
/// 2. 响应设备方向变化
/// 3. 提供设备类型和方向的检测
/// 4. 根据设备类型和方向调整布局
extension HFlowView {
    
    // MARK: - Device Properties
    
    /// 当前设备类型
    public var currentDeviceType: HFlowDeviceType {
        return getDeviceType()
    }
    
    /// 当前设备方向
    public var currentDeviceOrientation: HFlowDeviceOrientation {
        return getDeviceOrientation()
    }
    
    /// 是否是 iPhone
    public var isiPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// 是否是 iPad
    public var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 是否是横屏
    public var isLandscape: Bool {
        return currentDeviceOrientation == .landscape
    }
    
    /// 是否是竖屏
    public var isPortrait: Bool {
        return currentDeviceOrientation == .portrait
    }
    
    /// 是否有安全区域
    public var hasSafeArea: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets.bottom ?? 0 > 0
    }
    
    /// 安全区域 insets
    override public var safeAreaInsets: UIEdgeInsets {
        return super.safeAreaInsets
    }
    
    // MARK: - Device Detection Methods
    
    /// 获取设备类型
    /// - Returns: 设备类型
    private func getDeviceType() -> HFlowDeviceType {
        // 首先尝试通过设备标识符获取具体型号
        let deviceIdentifier = getDeviceIdentifier()
        
        switch deviceIdentifier {
        case "iPhone11,8":
            return .iPhone11
        case "iPhone12,1":
            return .iPhone12
        case "iPhone12,3":
            return .iPhone12
        case "iPhone13,1":
            return .iPhone13
        case "iPhone13,2":
            return .iPhone13
        case "iPhone14,1":
            return .iPhone14
        case "iPhone14,2":
            return .iPhone14
        case "iPhone15,2":
            return .iPhone15
        case "iPhone15,3":
            return .iPhone15
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return .iPad
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return .iPadPro
        default:
            // 如果无法通过标识符识别，则使用屏幕尺寸作为后备方案
            let screen = UIScreen.main
            let screenSize = screen.bounds.size
            let maxLength = max(screenSize.width, screenSize.height)
            
            switch maxLength {
            case 480:
                return .iPhone4S
            case 568:
                return .iPhone5
            case 667:
                return .iPhone6
            case 736:
                return .iPhone6Plus
            case 812:
                return .iPhoneX
            case 896:
                // iPhone XR 和 iPhone 14 具有相同的屏幕尺寸
                return .iPhoneXR
            case 844:
                return .iPhone12
            case 852:
                return .iPhone13
            case 932:
                return .iPhone15
            case 1024:
                return .iPad
            case 1194, 1366:
                return .iPadPro
            default:
                return .unknown
            }
        }
    }
    
    /// 获取设备标识符
    /// - Returns: 设备标识符
    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    /// 获取设备方向
    /// - Returns: 设备方向
    private func getDeviceOrientation() -> HFlowDeviceOrientation {
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait, .portraitUpsideDown:
            return .portrait
        case .landscapeLeft, .landscapeRight:
            return .landscape
        default:
            // 尝试通过屏幕尺寸判断
            let screenSize = UIScreen.main.bounds.size
            if screenSize.width > screenSize.height {
                return .landscape
            } else {
                return .portrait
            }
        }
    }
    
    // MARK: - Adaptation Methods
    
    /// 初始化设备适配
    func setupDeviceAdaptation() {
        // 监听设备方向变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeviceOrientationChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        // 监听屏幕尺寸变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenSizeChange),
            name: UIScreen.didConnectNotification,
            object: nil
        )
    }
    
    /// 处理设备方向变化
    @objc private func handleDeviceOrientationChange() {
        // 延迟执行，确保方向变化完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateLayoutForDeviceOrientation()
        }
    }
    
    /// 处理屏幕尺寸变化
    @objc private func handleScreenSizeChange() {
        updateLayoutForScreenSize()
    }
    
    /// 根据设备方向更新布局
    func updateLayoutForDeviceOrientation() {
        flowDelegate?.didChangeDeviceOrientation(currentDeviceOrientation)
        reloadFlowDataIncremental()
    }

    /// 根据屏幕尺寸更新布局
    func updateLayoutForScreenSize() {
        flowDelegate?.didChangeScreenSize()
        reloadFlowDataIncremental()
    }
    
    /// 获取适应设备的行高
    /// - Parameter baseHeight: 基础行高
    /// - Returns: 适应设备的行高
    func getDeviceAdaptiveHeight(for baseHeight: CGFloat) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let referenceHeight: CGFloat = 812 // iPhone X 高度
        
        // 根据屏幕高度调整行高
        let heightRatio = screenSize.height / referenceHeight
        let adaptiveHeight = baseHeight * heightRatio
        
        // 限制最小和最大高度
        return max(44, min(adaptiveHeight, 100))
    }
    
    /// 获取适应设备的字体大小
    /// - Parameter baseSize: 基础字体大小
    /// - Returns: 适应设备的字体大小
    func getDeviceAdaptiveFontSize(for baseSize: CGFloat) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let referenceWidth: CGFloat = 375 // iPhone X 宽度
        
        // 根据屏幕宽度调整字体大小
        let widthRatio = screenSize.width / referenceWidth
        let adaptiveSize = baseSize * widthRatio
        
        // 限制最小和最大字体大小
        return max(12, min(adaptiveSize, 24))
    }
    
    /// 检查是否需要为当前设备调整布局
    /// - Returns: 是否需要调整布局
    func needsLayoutAdjustment() -> Bool {
        return isiPad || isLandscape || hasSafeArea
    }
}

/// 扩展 HFlowViewDelegate，添加设备适配相关方法
extension HFlowViewDelegate {
    /// 当设备方向变化时调用
    /// - Parameter orientation: 新的设备方向
    func didChangeDeviceOrientation(_ orientation: HFlowDeviceOrientation) {
        // 默认实现为空
    }
    
    /// 当屏幕尺寸变化时调用
    func didChangeScreenSize() {
        // 默认实现为空
    }
    
    /// 获取适应设备的行高
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - baseHeight: 基础行高
    /// - Returns: 适应设备的行高
    func getDeviceAdaptiveHeight(for indexPath: IndexPath, baseHeight: CGFloat) -> CGFloat {
        return baseHeight
    }
    
    /// 获取适应设备的字体大小
    /// - Parameters:
    ///   - indexPath: 索引路径
    ///   - baseSize: 基础字体大小
    /// - Returns: 适应设备的字体大小
    func getDeviceAdaptiveFontSize(for indexPath: IndexPath, baseSize: CGFloat) -> CGFloat {
        return baseSize
    }
}
