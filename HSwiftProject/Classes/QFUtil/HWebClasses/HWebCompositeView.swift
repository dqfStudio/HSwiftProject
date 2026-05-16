//
//  HWebCompositeView.swift
//  FreeChat
//
//  Created by Wind on 2026-04-16.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

typealias HWebCallback = (_ sender: Any?, _ data: Any?) -> Void

enum HWebCompositeViewState {
    case normal     // 正常状态
    case disabled   // 禁用状态
    case selected   // 选中状态
    case highlighted // 高亮状态
    case loading    // 加载中状态
}

/// 动画配置结构体，将 23 个动画属性合并为一个可选的引用，降低每实例内存占用
struct HWebAnimationConfig {
    var animationDuration: TimeInterval = 0.3
    var useTapAnimation: Bool = true
    var tapAnimationScale: CGFloat = 0.95
    var tapAnimationAlpha: CGFloat = 0.7
    var useReducedAnimation: Bool = false
    var useFadeAnimation: Bool = false
    var fadeAnimationDuration: TimeInterval = 0.3
    var useScaleAnimation: Bool = false
    var scaleAnimationFrom: CGFloat = 0.8
    var scaleAnimationTo: CGFloat = 1.0
    var scaleAnimationDuration: TimeInterval = 0.3
    var useRotateAnimation: Bool = false
    var rotateAnimationFrom: CGFloat = 0.0
    var rotateAnimationTo: CGFloat = .pi * 2
    var rotateAnimationDuration: TimeInterval = 0.5
    var useTranslateAnimation: Bool = false
    var translateAnimationFrom: CGPoint = .zero
    var translateAnimationTo: CGPoint = .zero
    var translateAnimationDuration: TimeInterval = 0.3
    var useSpringAnimation: Bool = false
    var springAnimationDamping: CGFloat = 0.7
    var springAnimationVelocity: CGFloat = 0.0
    var springAnimationDuration: TimeInterval = 0.5
}

/// 图文组合视图类，支持图片、文字、交互等多种功能
class HWebCompositeView: UIView {
    
    // MARK: - 图片相关属性
    
    /// 图片大小
    var imageSize: CGSize = .zero {
        didSet {
            if imageSize != oldValue {
                layoutNeedsUpdate = true
            }
        }
    }
    
    /// 图片与文字的间距
    var imageSpace: CGFloat = 0.0 {
        didSet {
            if imageSpace != oldValue {
                layoutNeedsUpdate = true
            }
        }
    }
    
    /// 图片位置
    var imagePosition: HImagePosition = .left {
        didSet {
            if imagePosition != oldValue {
                layoutNeedsUpdate = true
            }
        }
    }
    
    /// 渲染颜色，用于图片的色调调整
    var renderColor: UIColor? {
        didSet {
            if renderColor != oldValue {
                layoutNeedsUpdate = true
                updateSubviewsIfNeeded()
            }
        }
    }
    
    // MARK: - 交互相关属性
    
    /// 点击回调
    var pressed: HWebCallback? {
        didSet {
            if pressed != nil {
                isUserInteractionEnabled = true
                if pressedGesture.view == nil {
                    addGestureRecognizer(pressedGesture)
                }
            } else {
                if pressedGesture.view != nil {
                    removeGestureRecognizer(pressedGesture)
                }
            }
        }
    }
    
    /// 长按回调
    var longPressed: HWebCallback? {
        didSet {
            if longPressed != nil {
                isUserInteractionEnabled = true
                if longPressGesture.view == nil {
                    addGestureRecognizer(longPressGesture)
                }
            } else {
                if longPressGesture.view != nil {
                    removeGestureRecognizer(longPressGesture)
                }
            }
        }
    }
    
    /// 双击回调
    var doubleTapped: HWebCallback? {
        didSet {
            if doubleTapped != nil {
                isUserInteractionEnabled = true
                if doubleTapGesture.view == nil {
                    addGestureRecognizer(doubleTapGesture)
                    // 确保单击和双击手势可以同时工作
                    pressedGesture.require(toFail: doubleTapGesture)
                }
            } else {
                if doubleTapGesture.view != nil {
                    removeGestureRecognizer(doubleTapGesture)
                }
            }
        }
    }
    
    /// 滑动回调
    var swiped: ((Any?, UISwipeGestureRecognizer.Direction) -> Void)? {
        didSet {
            if swiped != nil {
                isUserInteractionEnabled = true
                setupSwipeGestures()
            } else {
                removeSwipeGestures()
            }
        }
    }
    
    /// 拖拽回调
    var dragged: ((Any?, CGPoint, CGPoint) -> Void)? {
        didSet {
            if dragged != nil {
                isUserInteractionEnabled = true
                if panGesture.view == nil {
                    addGestureRecognizer(panGesture)
                }
            } else {
                if panGesture.view != nil {
                    removeGestureRecognizer(panGesture)
                }
            }
        }
    }
    
    /// 扩大点击区域的额外边距
    var extraEdgeInsets = UIEdgeInsets.zero
    
    // MARK: - 状态管理
    
    /// 视图状态
    var state: HWebCompositeViewState = .normal {
        didSet {
            updateStateAppearance()
        }
    }
    
    // MARK: - 动画相关

    private static let defaultAnimationConfig = HWebAnimationConfig()

    private var _animationConfig: HWebAnimationConfig?

    private func setAnimation<Value>(_ keyPath: WritableKeyPath<HWebAnimationConfig, Value>, _ value: Value) {
        if _animationConfig == nil { _animationConfig = HWebAnimationConfig() }
        _animationConfig![keyPath: keyPath] = value
    }

    private var anim: HWebAnimationConfig {
        _animationConfig ?? Self.defaultAnimationConfig
    }

    var animationDuration: TimeInterval {
        get { anim.animationDuration }
        set { setAnimation(\.animationDuration, newValue) }
    }
    var useTapAnimation: Bool {
        get { anim.useTapAnimation }
        set { setAnimation(\.useTapAnimation, newValue) }
    }
    var tapAnimationScale: CGFloat {
        get { anim.tapAnimationScale }
        set { setAnimation(\.tapAnimationScale, newValue) }
    }
    var tapAnimationAlpha: CGFloat {
        get { anim.tapAnimationAlpha }
        set { setAnimation(\.tapAnimationAlpha, newValue) }
    }
    var useReducedAnimation: Bool {
        get { anim.useReducedAnimation }
        set { setAnimation(\.useReducedAnimation, newValue) }
    }
    var useFadeAnimation: Bool {
        get { anim.useFadeAnimation }
        set { setAnimation(\.useFadeAnimation, newValue) }
    }
    var fadeAnimationDuration: TimeInterval {
        get { anim.fadeAnimationDuration }
        set { setAnimation(\.fadeAnimationDuration, newValue) }
    }
    var useScaleAnimation: Bool {
        get { anim.useScaleAnimation }
        set { setAnimation(\.useScaleAnimation, newValue) }
    }
    var scaleAnimationFrom: CGFloat {
        get { anim.scaleAnimationFrom }
        set { setAnimation(\.scaleAnimationFrom, newValue) }
    }
    var scaleAnimationTo: CGFloat {
        get { anim.scaleAnimationTo }
        set { setAnimation(\.scaleAnimationTo, newValue) }
    }
    var scaleAnimationDuration: TimeInterval {
        get { anim.scaleAnimationDuration }
        set { setAnimation(\.scaleAnimationDuration, newValue) }
    }
    var useRotateAnimation: Bool {
        get { anim.useRotateAnimation }
        set { setAnimation(\.useRotateAnimation, newValue) }
    }
    var rotateAnimationFrom: CGFloat {
        get { anim.rotateAnimationFrom }
        set { setAnimation(\.rotateAnimationFrom, newValue) }
    }
    var rotateAnimationTo: CGFloat {
        get { anim.rotateAnimationTo }
        set { setAnimation(\.rotateAnimationTo, newValue) }
    }
    var rotateAnimationDuration: TimeInterval {
        get { anim.rotateAnimationDuration }
        set { setAnimation(\.rotateAnimationDuration, newValue) }
    }
    var useTranslateAnimation: Bool {
        get { anim.useTranslateAnimation }
        set { setAnimation(\.useTranslateAnimation, newValue) }
    }
    var translateAnimationFrom: CGPoint {
        get { anim.translateAnimationFrom }
        set { setAnimation(\.translateAnimationFrom, newValue) }
    }
    var translateAnimationTo: CGPoint {
        get { anim.translateAnimationTo }
        set { setAnimation(\.translateAnimationTo, newValue) }
    }
    var translateAnimationDuration: TimeInterval {
        get { anim.translateAnimationDuration }
        set { setAnimation(\.translateAnimationDuration, newValue) }
    }
    var useSpringAnimation: Bool {
        get { anim.useSpringAnimation }
        set { setAnimation(\.useSpringAnimation, newValue) }
    }
    var springAnimationDamping: CGFloat {
        get { anim.springAnimationDamping }
        set { setAnimation(\.springAnimationDamping, newValue) }
    }
    var springAnimationVelocity: CGFloat {
        get { anim.springAnimationVelocity }
        set { setAnimation(\.springAnimationVelocity, newValue) }
    }
    var springAnimationDuration: TimeInterval {
        get { anim.springAnimationDuration }
        set { setAnimation(\.springAnimationDuration, newValue) }
    }
    
    // MARK: - 图片处理相关
    
    /// 图片模糊半径
    var imageBlurRadius: CGFloat = 0
    
    /// 图片亮度调整 (-1.0 到 1.0)
    var imageBrightness: CGFloat = 0
    
    /// 图片饱和度调整 (0.0 到 2.0)
    var imageSaturation: CGFloat = 1.0
    
    /// 图片对比度调整 (0.0 到 2.0)
    var imageContrast: CGFloat = 1.0
    
    // MARK: - 加载指示器相关
    
    /// 加载指示器样式
    var activityIndicatorStyle: UIActivityIndicatorView.Style = .medium
    
    /// 加载指示器颜色
    var activityIndicatorColor: UIColor?
    
    /// 加载指示器大小
    var activityIndicatorSize: CGSize?
    
    /// 加载指示器位置（相对于视图中心的偏移）
    var activityIndicatorPosition: CGPoint?
    
    /// 加载指示器显示/隐藏动画时长
    var activityIndicatorAnimationDuration: TimeInterval = 0.3
    
    /// 加载时的文本提示
    var loadingText: String?
    
    // MARK: - 外观相关
    
    /// 图片圆角
    var imageCornerRadius: CGFloat = 0
    
    /// 背景图片圆角
    var backgroundImageCornerRadius: CGFloat = 0

    /// 视图圆角
    var viewCornerRadius: CGFloat = 0

    /// 边框宽度
    var viewBorderWidth: CGFloat = 0

    /// 边框颜色
    var viewBorderColor: UIColor?
    
    /// 阴影颜色
    var shadowColor: UIColor?
    
    /// 阴影偏移
    var shadowOffset: CGSize = .zero
    
    /// 阴影透明度
    var shadowOpacity: Float = 0
    
    /// 阴影半径
    var shadowRadius: CGFloat = 0
    
    // MARK: - 渐变色背景相关
    
    /// 渐变色颜色数组
    var gradientBackgroundColors: [CGColor]? {
        didSet {
            updateGradientBackground()
        }
    }
    
    /// 渐变起始点
    var gradientStartPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            updateGradientBackground()
        }
    }
    
    /// 渐变结束点
    var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            updateGradientBackground()
        }
    }
    /// 渐变图层
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - 图片加载相关
    
    /// 图片加载错误回调
    var didGetError: Callback?
    
    /// 获取图片回调
    var didGetImage: HWebGetImageBlock?
    
    /// 图片加载状态回调
    var imageLoadStatus: HWebImageLoadStatusBlock?
    
    // MARK: - 背景图片加载相关
    
    /// 背景图片加载错误回调
    var didGetBackgroundError: Callback?
    
    /// 获取背景图片回调
    var didGetBackgroundImage: HWebGetImageBlock?
    
    /// 背景图片加载状态回调
    var backgroundImageLoadStatus: HWebImageLoadStatusBlock?
    
    // MARK: - 状态外观配置
    
    /// 正常状态背景颜色
    private var normalBackgroundColor: UIColor = .clear
    
    /// 禁用状态背景颜色
    private var disabledBackgroundColor: UIColor = .lightGray.withAlphaComponent(0.3)
    
    /// 选中状态背景颜色
    private var selectedBackgroundColor: UIColor = .blue.withAlphaComponent(0.1)
    
    /// 高亮状态背景颜色
    private var highlightedBackgroundColor: UIColor = .gray.withAlphaComponent(0.1)
    
    /// 加载状态背景颜色
    private var loadingBackgroundColor: UIColor = .clear
    
    /// 正常状态文本颜色
    private var normalTextColor: UIColor = .black
    
    /// 禁用状态文本颜色
    private var disabledTextColor: UIColor = .gray
    
    /// 选中状态文本颜色
    private var selectedTextColor: UIColor = .blue
    
    /// 高亮状态文本颜色
    private var highlightedTextColor: UIColor = .black
    
    /// 加载状态文本颜色
    private var loadingTextColor: UIColor = .black
    
    // MARK: - 内部属性
    
    /// 上次加载的图片URL
    private var lastURLBox = StringBox("")

    /// 点击时间间隔
    private var pressedInterval: TimeInterval = 0.0
    
    /// 存储上一次的边界大小，用于判断是否需要重新布局
    private var previousBoundsSize: CGSize = .zero
    
    /// 标记是否需要更新布局
    private var layoutNeedsUpdate: Bool = true
    
    // MARK: - 子视图
    
    /// 图片视图
    private var _imageView: UIImageView?
    
    /// 背景图片视图
    private var _backgroundView: UIImageView?
    
    /// 文本标签
    private var _titleLabel: UILabel?
    
    /// 加载指示器
    private var _activityIndicator: UIActivityIndicatorView?
    
    // 懒加载子视图
    var imageView: UIImageView {
        if _imageView == nil {
            _imageView = UIImageView()
            _imageView!.contentMode = .scaleAspectFill
            _imageView!.layer.masksToBounds = true
            _imageView!.layer.cornerRadius = imageCornerRadius
            _imageView!.isUserInteractionEnabled = false
            _imageView!.isAccessibilityElement = false
            self.addSubview(_imageView!)
        }
        return _imageView!
    }
    
    var backgroundView: UIImageView {
        if _backgroundView == nil {
            _backgroundView = UIImageView()
            _backgroundView!.contentMode = .scaleToFill
            _backgroundView!.layer.masksToBounds = true
            _backgroundView!.layer.cornerRadius = backgroundImageCornerRadius
            _backgroundView!.isUserInteractionEnabled = false
            _backgroundView!.isAccessibilityElement = false
            self.insertSubview(_backgroundView!, at: 0)
            _backgroundView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        return _backgroundView!
    }
    
    var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel!.font = .systemFont(ofSize: 17.0)
            _titleLabel!.textAlignment = .center
            _titleLabel!.isUserInteractionEnabled = false
            _titleLabel!.isAccessibilityElement = false
            self.addSubview(_titleLabel!)
        }
        return _titleLabel!
    }
    
    var activityIndicator: UIActivityIndicatorView {
        if _activityIndicator == nil {
            _activityIndicator = UIActivityIndicatorView(style: activityIndicatorStyle)
            if let color = activityIndicatorColor {
                _activityIndicator!.color = color
            }
            _activityIndicator!.isUserInteractionEnabled = false
            _activityIndicator!.isAccessibilityElement = false
            self.addSubview(_activityIndicator!)
            _activityIndicator!.snp.makeConstraints { make in
                if let position = activityIndicatorPosition {
                    make.centerX.equalToSuperview().offset(position.x)
                    make.centerY.equalToSuperview().offset(position.y)
                } else {
                    make.center.equalToSuperview()
                }
                if let size = activityIndicatorSize {
                    make.width.equalTo(size.width)
                    make.height.equalTo(size.height)
                }
            }
        }
        return _activityIndicator!
    }
    
    // 便捷属性
    var text: String? {
        get { return titleLabel.text }
        set { 
            titleLabel.text = newValue
            updateSubviews()
        }
    }
    
    var textFont: UIFont? {
        get { return titleLabel.font }
        set { 
            titleLabel.font = newValue
            updateSubviews()
        }
    }
    
    var textColor: UIColor? {
        get { return titleLabel.textColor }
        set { 
            titleLabel.textColor = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get { return titleLabel.textAlignment }
        set { 
            titleLabel.textAlignment = newValue
            updateSubviews()
        }
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set { 
            if let image = newValue {
                imageView.image = processImage(image)
            } else {
                imageView.image = nil
            }
            updateSubviews()
        }
    }
    
    var backgroundImage: UIImage? {
        get { return backgroundView.image }
        set { 
            if let image = newValue {
                backgroundView.image = processImage(image)
            } else {
                backgroundView.image = nil
            }
            updateSubviews()
        }
    }
    
    // 点击手势
    lazy private var pressedGesture: UITapGestureRecognizer = {
        let pressedGesture = UITapGestureRecognizer()
        pressedGesture.numberOfTapsRequired = 1
        pressedGesture.numberOfTouchesRequired = 1
        pressedGesture.addTarget(self, action: #selector(pressedAction))
        return pressedGesture
    }()
    
    // 长按手势
    lazy private var longPressGesture: UILongPressGestureRecognizer = {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.addTarget(self, action: #selector(longPressAction(_:)))
        return longPressGesture
    }()
    
    // 双击手势
    lazy private var doubleTapGesture: UITapGestureRecognizer = {
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.addTarget(self, action: #selector(doubleTapAction))
        return doubleTapGesture
    }()
    
    // 拖拽手势
    lazy private var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panAction(_:)))
        return panGesture
    }()
    
    // 滑动手势数组
    private var swipeGestures: [UISwipeGestureRecognizer] = []

    // 初始化方法
    required init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        layer.masksToBounds = true
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // 点击响应
    @objc
    private func pressedAction() {
        guard let pressed = pressed, state != .disabled else { return }
        // 防重复点击
        if Date().timeIntervalSince1970 - pressedInterval > 0.5 {
            // 记录点击时间
            pressedInterval = Date().timeIntervalSince1970
            // 执行点击动画
            performTapAnimation()
            // 回调
            pressed(self, nil)
        }
    }
    
    // 长按响应
    @objc
    private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        guard let longPressed = longPressed, state != .disabled else { return }
        
        if gesture.state == .began {
            // 执行长按动画
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.6
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // 执行恢复动画
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1.0
            }
            
            // 回调
            longPressed(self, nil)
        }
    }
    
    // 双击响应
    @objc
    private func doubleTapAction() {
        guard let doubleTapped = doubleTapped, state != .disabled else { return }
        
        // 执行双击动画
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
        
        // 回调
        doubleTapped(self, nil)
    }
    
    // 设置滑动手势
    private func setupSwipeGestures() {
        // 移除旧的滑动手势
        removeSwipeGestures()
        
        // 添加四个方向的滑动手势
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
            swipeGesture.direction = direction
            addGestureRecognizer(swipeGesture)
            swipeGestures.append(swipeGesture)
        }
    }
    
    // 移除滑动手势
    private func removeSwipeGestures() {
        for gesture in swipeGestures {
            removeGestureRecognizer(gesture)
        }
        swipeGestures.removeAll()
    }
    
    // 滑动响应
    @objc
    private func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        guard let swiped = swiped, state != .disabled else { return }
        swiped(self, gesture.direction)
    }
    
    // 拖拽响应
    @objc
    private func panAction(_ gesture: UIPanGestureRecognizer) {
        guard let dragged = dragged, state != .disabled else { return }
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        dragged(self, translation, velocity)
    }
    
    // 执行点击动画
    private func performTapAnimation() {
        guard useTapAnimation else { return }
        
        if useReducedAnimation {
            // 简化动画，减少性能消耗
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.8
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.alpha = 1.0
                }
            }
        } else {
            // 完整动画
            UIView.animate(withDuration: animationDuration * 0.5, animations: {
                self.alpha = self.tapAnimationAlpha
                self.transform = CGAffineTransform(scaleX: self.tapAnimationScale, y: self.tapAnimationScale)
            }) { _ in
                UIView.animate(withDuration: self.animationDuration * 0.5) {
                    self.alpha = 1.0
                    self.transform = .identity
                }
            }
        }
    }
    

    
    // 更新状态外观
    private func updateStateAppearance() {
        UIView.animate(withDuration: animationDuration) {
            switch self.state {
            case .normal:
                self.backgroundColor = self.normalBackgroundColor
                self.titleLabel.textColor = self.normalTextColor
                self.isUserInteractionEnabled = true
                UIView.animate(withDuration: self.activityIndicatorAnimationDuration) {
                    self.activityIndicator.alpha = 0
                } completion: { _ in
                    self.activityIndicator.stopAnimating()
                }
            case .disabled:
                self.backgroundColor = self.disabledBackgroundColor
                self.titleLabel.textColor = self.disabledTextColor
                self.isUserInteractionEnabled = false
                UIView.animate(withDuration: self.activityIndicatorAnimationDuration) {
                    self.activityIndicator.alpha = 0
                } completion: { _ in
                    self.activityIndicator.stopAnimating()
                }
            case .selected:
                self.backgroundColor = self.selectedBackgroundColor
                self.titleLabel.textColor = self.selectedTextColor
                self.isUserInteractionEnabled = true
                UIView.animate(withDuration: self.activityIndicatorAnimationDuration) {
                    self.activityIndicator.alpha = 0
                } completion: { _ in
                    self.activityIndicator.stopAnimating()
                }
            case .highlighted:
                self.backgroundColor = self.highlightedBackgroundColor
                self.titleLabel.textColor = self.highlightedTextColor
                self.isUserInteractionEnabled = true
                UIView.animate(withDuration: self.activityIndicatorAnimationDuration) {
                    self.activityIndicator.alpha = 0
                } completion: { _ in
                    self.activityIndicator.stopAnimating()
                }
            case .loading:
                self.backgroundColor = self.loadingBackgroundColor
                self.titleLabel.textColor = self.loadingTextColor
                self.isUserInteractionEnabled = false
                // 显示加载文本
                if let loadingText = self.loadingText {
                    self.titleLabel.text = loadingText
                }
                self.activityIndicator.alpha = 0
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: self.activityIndicatorAnimationDuration) {
                    self.activityIndicator.alpha = 1
                }
            }
            self.updateAppearance()
        }
    }
    
    // 更新外观
    private func updateAppearance() {
        // 更新视图圆角
        layer.cornerRadius = viewCornerRadius
        layer.masksToBounds = viewCornerRadius > 0

        // 更新边框
        layer.borderWidth = viewBorderWidth
        if let color = viewBorderColor {
            layer.borderColor = color.cgColor
        }

        // 更新阴影（使用 shadowPath 避免与 masksToBounds 冲突）
        if let color = shadowColor {
            layer.shadowColor = color.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius).cgPath
        } else {
            layer.shadowOpacity = 0
            layer.shadowPath = nil
        }
        
        // 更新图片圆角
        _imageView?.layer.cornerRadius = imageCornerRadius
        
        // 更新背景图片圆角
        _backgroundView?.layer.cornerRadius = backgroundImageCornerRadius
        
        // 更新加载指示器
        if let activityIndicator = _activityIndicator {
            activityIndicator.style = activityIndicatorStyle
            if let color = activityIndicatorColor {
                activityIndicator.color = color
            }
        }
        
        // 更新渐变色背景
        updateGradientBackground()
    }
    
    // 更新渐变色背景
    private func updateGradientBackground() {
        if let colors = gradientBackgroundColors, !colors.isEmpty {
            // 创建或更新渐变图层
            if gradientLayer == nil {
                gradientLayer = CAGradientLayer()
                gradientLayer!.frame = self.bounds
                self.layer.insertSublayer(gradientLayer!, at: 0)
            }

            gradientLayer!.colors = colors
            gradientLayer!.startPoint = gradientStartPoint
            gradientLayer!.endPoint = gradientEndPoint
            gradientLayer!.cornerRadius = viewCornerRadius
            
            // 隐藏背景视图和背景色
            backgroundView.isHidden = true
            self.backgroundColor = .clear
        } else {
            // 移除渐变图层
            if let gradientLayer = gradientLayer {
                gradientLayer.removeFromSuperlayer()
                self.gradientLayer = nil
            }
            
            // 显示背景视图
            backgroundView.isHidden = false
        }
    }
    

    

    
    // 扩大点击区域
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let largerBounds = bounds.inset(by: UIEdgeInsets(
            top: -extraEdgeInsets.top,
            left: -extraEdgeInsets.left,
            bottom: -extraEdgeInsets.bottom,
            right: -extraEdgeInsets.right
        ))
        return largerBounds.contains(point)
    }
    
    // 可访问性属性
    var customAccessibilityHint: String? // 自定义可访问性提示
    var customAccessibilityValue: String? // 自定义可访问性值
    var customAccessibilityLanguage: String? // 自定义可访问性语言
    
    // 重写可访问性方法
    override var isAccessibilityElement: Bool {
        didSet {
            // 确保子视图不可访问，只有整个复合视图可访问
            _imageView?.isAccessibilityElement = false
            _titleLabel?.isAccessibilityElement = false
            _activityIndicator?.isAccessibilityElement = false
        }
    }
    
    override var accessibilityLabel: String? {
        get {
            return super.accessibilityLabel ?? titleLabel.text
        }
        set {
            super.accessibilityLabel = newValue
        }
    }
    
    override var accessibilityHint: String? {
        get {
            return super.accessibilityHint ?? customAccessibilityHint
        }
        set {
            super.accessibilityHint = newValue
        }
    }
    
    override var accessibilityValue: String? {
        get {
            return super.accessibilityValue ?? customAccessibilityValue ?? getStateDescription()
        }
        set {
            super.accessibilityValue = newValue
        }
    }
    
    override var accessibilityLanguage: String? {
        get {
            return super.accessibilityLanguage ?? customAccessibilityLanguage
        }
        set {
            super.accessibilityLanguage = newValue
        }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            var traits = super.accessibilityTraits
            if state == .disabled {
                traits.insert(.notEnabled)
            }
            if state == .selected {
                traits.insert(.selected)
            }
            if state == .loading {
                traits.insert(.updatesFrequently)
            }
            return traits
        }
        set {
            super.accessibilityTraits = newValue
        }
    }
    
    override var accessibilityElementsHidden: Bool {
        get {
            return super.accessibilityElementsHidden
        }
        set {
            super.accessibilityElementsHidden = newValue
            _imageView?.isAccessibilityElement = !newValue
            _titleLabel?.isAccessibilityElement = !newValue
            _activityIndicator?.isAccessibilityElement = !newValue
        }
    }
    
    // 获取状态描述
    private func getStateDescription() -> String {
        switch state {
        case .normal:
            return "Normal"
        case .disabled:
            return "Disabled"
        case .selected:
            return "Selected"
        case .highlighted:
            return "Highlighted"
        case .loading:
            return "Loading"
        }
    }
    
    // 模拟可访问性点击
    override func accessibilityActivate() -> Bool {
        if state != .disabled && state != .loading {
            pressedAction()
            return true
        }
        return false
    }
    
    // 可访问性元素
    private var _customAccessibilityElements: [Any]?

    override var accessibilityElements: [Any]? {
        get {
            return _customAccessibilityElements ?? [self]
        }
        set {
            _customAccessibilityElements = newValue
        }
    }
    
    func prepareForReuse() {
        _imageView?.kf.cancelDownloadTask()
        _backgroundView?.kf.cancelDownloadTask()
        _activityIndicator?.stopAnimating()
        state = .normal
        _imageView?.image = nil
        _backgroundView?.image = nil
        _titleLabel?.text = nil
        lastURLBox = StringBox("")
        transform = .identity
        alpha = 1.0
        layer.removeAllAnimations()
    }

    // 布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        // 更新渐变图层的frame
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = self.bounds
        }
        updateSubviewsIfNeeded()
    }
    
    // 优化布局更新，避免不必要的计算
    private func updateSubviewsIfNeeded() {
        if bounds.size != previousBoundsSize || layoutNeedsUpdate {
            updateSubviews()
            previousBoundsSize = bounds.size
            layoutNeedsUpdate = false
        }
    }
    
    // 更新子视图
    private func updateSubviews() {
        let params = HWebLayoutManager.LayoutParams(
            imageView: _imageView,
            titleLabel: _titleLabel,
            imageSize: imageSize,
            imageSpace: imageSpace,
            imagePosition: imagePosition
        )
        HWebLayoutManager.performLayout(with: params)
    }
    // 链式调用API
    @discardableResult
    func text(_ text: String) -> HWebCompositeView {
        self.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> HWebCompositeView {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func textFont(_ font: UIFont) -> HWebCompositeView {
        self.textFont = font
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> HWebCompositeView {
        self.textAlignment = alignment
        return self
    }

    @discardableResult
    func textNumberOfLines(_ lines: Int) -> HWebCompositeView {
        titleLabel.numberOfLines = lines
        return self
    }

    @discardableResult
    func image(_ image: UIImage) -> HWebCompositeView {
        self.image = image
        return self
    }
    
    @discardableResult
    func imageUrl(_ url: URL, placeholder: UIImage? = nil) -> HWebCompositeView {
        self.setImageUrl(url, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func imageUrlString(_ urlString: String, placeholder: UIImage? = nil) -> HWebCompositeView {
        self.setImageUrlString(urlString, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func imageSize(_ size: CGSize) -> HWebCompositeView {
        self.imageSize = size
        return self
    }
    
    @discardableResult
    func imageSpace(_ space: CGFloat) -> HWebCompositeView {
        self.imageSpace = space
        return self
    }
    
    @discardableResult
    func imagePosition(_ position: HImagePosition) -> HWebCompositeView {
        self.imagePosition = position
        return self
    }
    
    @discardableResult
    func backgroundImage(_ image: UIImage) -> HWebCompositeView {
        self.backgroundImage = image
        return self
    }
    
    @discardableResult
    func backgroundImageUrl(_ url: URL, placeholder: UIImage? = nil) -> HWebCompositeView {
        self.setBackgroundImageUrl(url, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func backgroundImageUrlString(_ urlString: String, placeholder: UIImage? = nil) -> HWebCompositeView {
        self.setBackgroundImageUrlString(urlString, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func extraEdgeInsets(_ insets: UIEdgeInsets) -> HWebCompositeView {
        self.extraEdgeInsets = insets
        return self
    }
    
    @discardableResult
    func pressed(_ action: @escaping HWebCallback) -> HWebCompositeView {
        self.pressed = action
        return self
    }
    
    @discardableResult
    func longPressed(_ action: @escaping HWebCallback) -> HWebCompositeView {
        self.longPressed = action
        return self
    }
    
    @discardableResult
    func doubleTapped(_ action: @escaping HWebCallback) -> HWebCompositeView {
        self.doubleTapped = action
        return self
    }
    
    @discardableResult
    func imageLoadStatus(_ status: @escaping HWebImageLoadStatusBlock) -> HWebCompositeView {
        self.imageLoadStatus = status
        return self
    }
    
    @discardableResult
    func backgroundImageLoadStatus(_ status: @escaping HWebImageLoadStatusBlock) -> HWebCompositeView {
        self.backgroundImageLoadStatus = status
        return self
    }
    
    @discardableResult
    func state(_ state: HWebCompositeViewState) -> HWebCompositeView {
        self.state = state
        return self
    }
    
    @discardableResult
    func animationDuration(_ duration: TimeInterval) -> HWebCompositeView {
        self.animationDuration = duration
        return self
    }
    
    @discardableResult
    func normalBackgroundColor(_ color: UIColor) -> HWebCompositeView {
        self.normalBackgroundColor = color
        if state == .normal {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func disabledBackgroundColor(_ color: UIColor) -> HWebCompositeView {
        self.disabledBackgroundColor = color
        if state == .disabled {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func selectedBackgroundColor(_ color: UIColor) -> HWebCompositeView {
        self.selectedBackgroundColor = color
        if state == .selected {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func normalTextColor(_ color: UIColor) -> HWebCompositeView {
        self.normalTextColor = color
        if state == .normal {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    @discardableResult
    func disabledTextColor(_ color: UIColor) -> HWebCompositeView {
        self.disabledTextColor = color
        if state == .disabled {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    @discardableResult
    func selectedTextColor(_ color: UIColor) -> HWebCompositeView {
        self.selectedTextColor = color
        if state == .selected {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    // 高亮状态外观链式调用
    @discardableResult
    func highlightedBackgroundColor(_ color: UIColor) -> HWebCompositeView {
        self.highlightedBackgroundColor = color
        if state == .highlighted {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func highlightedTextColor(_ color: UIColor) -> HWebCompositeView {
        self.highlightedTextColor = color
        if state == .highlighted {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    // 加载中状态外观链式调用
    @discardableResult
    func loadingBackgroundColor(_ color: UIColor) -> HWebCompositeView {
        self.loadingBackgroundColor = color
        if state == .loading {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func loadingTextColor(_ color: UIColor) -> HWebCompositeView {
        self.loadingTextColor = color
        if state == .loading {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    // 动画相关链式调用
    @discardableResult
    func useTapAnimation(_ use: Bool) -> HWebCompositeView {
        self.useTapAnimation = use
        return self
    }
    
    @discardableResult
    func useReducedAnimation(_ use: Bool) -> HWebCompositeView {
        self.useReducedAnimation = use
        if use {
            animationDuration = 0.2
        }
        return self
    }

    @discardableResult
    func useFadeAnimation(_ use: Bool) -> HWebCompositeView {
        self.useFadeAnimation = use
        return self
    }
    
    @discardableResult
    func fadeAnimationDuration(_ duration: TimeInterval) -> HWebCompositeView {
        self.fadeAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useScaleAnimation(_ use: Bool) -> HWebCompositeView {
        self.useScaleAnimation = use
        return self
    }
    
    @discardableResult
    func scaleAnimationFrom(_ from: CGFloat) -> HWebCompositeView {
        self.scaleAnimationFrom = from
        return self
    }
    
    @discardableResult
    func scaleAnimationTo(_ to: CGFloat) -> HWebCompositeView {
        self.scaleAnimationTo = to
        return self
    }
    
    @discardableResult
    func scaleAnimationDuration(_ duration: TimeInterval) -> HWebCompositeView {
        self.scaleAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useRotateAnimation(_ use: Bool) -> HWebCompositeView {
        self.useRotateAnimation = use
        return self
    }
    
    @discardableResult
    func rotateAnimationFrom(_ from: CGFloat) -> HWebCompositeView {
        self.rotateAnimationFrom = from
        return self
    }
    
    @discardableResult
    func rotateAnimationTo(_ to: CGFloat) -> HWebCompositeView {
        self.rotateAnimationTo = to
        return self
    }
    
    @discardableResult
    func rotateAnimationDuration(_ duration: TimeInterval) -> HWebCompositeView {
        self.rotateAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useTranslateAnimation(_ use: Bool) -> HWebCompositeView {
        self.useTranslateAnimation = use
        return self
    }
    
    @discardableResult
    func translateAnimationFrom(_ from: CGPoint) -> HWebCompositeView {
        self.translateAnimationFrom = from
        return self
    }
    
    @discardableResult
    func translateAnimationTo(_ to: CGPoint) -> HWebCompositeView {
        self.translateAnimationTo = to
        return self
    }
    
    @discardableResult
    func translateAnimationDuration(_ duration: TimeInterval) -> HWebCompositeView {
        self.translateAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useSpringAnimation(_ use: Bool) -> HWebCompositeView {
        self.useSpringAnimation = use
        return self
    }
    
    @discardableResult
    func springAnimationDamping(_ damping: CGFloat) -> HWebCompositeView {
        self.springAnimationDamping = damping
        return self
    }
    
    @discardableResult
    func springAnimationVelocity(_ velocity: CGFloat) -> HWebCompositeView {
        self.springAnimationVelocity = velocity
        return self
    }
    
    @discardableResult
    func springAnimationDuration(_ duration: TimeInterval) -> HWebCompositeView {
        self.springAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func tapAnimationScale(_ scale: CGFloat) -> HWebCompositeView {
        self.tapAnimationScale = scale
        return self
    }
    
    @discardableResult
    func tapAnimationAlpha(_ alpha: CGFloat) -> HWebCompositeView {
        self.tapAnimationAlpha = alpha
        return self
    }
    
    // 加载指示器相关链式调用
    @discardableResult
    func activityIndicatorStyle(_ style: UIActivityIndicatorView.Style) -> HWebCompositeView {
        self.activityIndicatorStyle = style
        updateAppearance()
        return self
    }
    
    @discardableResult
    func activityIndicatorColor(_ color: UIColor) -> HWebCompositeView {
        self.activityIndicatorColor = color
        updateAppearance()
        return self
    }
    
    // 外观相关链式调用
    @discardableResult
    func imageCornerRadius(_ radius: CGFloat) -> HWebCompositeView {
        self.imageCornerRadius = radius
        updateAppearance()
        return self
    }
    
    @discardableResult
    func backgroundImageCornerRadius(_ radius: CGFloat) -> HWebCompositeView {
        self.backgroundImageCornerRadius = radius
        updateAppearance()
        return self
    }
    
    @discardableResult
    func viewCornerRadius(_ radius: CGFloat) -> HWebCompositeView {
        self.viewCornerRadius = radius
        updateAppearance()
        return self
    }

    @discardableResult
    func viewBorderWidth(_ width: CGFloat) -> HWebCompositeView {
        self.viewBorderWidth = width
        updateAppearance()
        return self
    }

    @discardableResult
    func viewBorderColor(_ color: UIColor) -> HWebCompositeView {
        self.viewBorderColor = color
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowColor(_ color: UIColor) -> HWebCompositeView {
        self.shadowColor = color
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> HWebCompositeView {
        self.shadowOffset = offset
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> HWebCompositeView {
        self.shadowOpacity = opacity
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> HWebCompositeView {
        self.shadowRadius = radius
        updateAppearance()
        return self
    }
    
    // 可访问性相关链式调用
    @discardableResult
    func accessibilityLabel(_ label: String) -> HWebCompositeView {
        self.accessibilityLabel = label
        return self
    }

    @discardableResult
    func accessibilityHint(_ hint: String) -> HWebCompositeView {
        self.accessibilityHint = hint
        return self
    }

    @discardableResult
    func accessibilityValue(_ value: String) -> HWebCompositeView {
        self.accessibilityValue = value
        return self
    }

    @discardableResult
    func isAccessibilityElement(_ isElement: Bool) -> HWebCompositeView {
        self.isAccessibilityElement = isElement
        return self
    }

    @discardableResult
    func customAccessibilityHint(_ hint: String) -> HWebCompositeView {
        self.customAccessibilityHint = hint
        return self
    }

    @discardableResult
    func customAccessibilityValue(_ value: String) -> HWebCompositeView {
        self.customAccessibilityValue = value
        return self
    }

    @discardableResult
    func customAccessibilityLanguage(_ language: String) -> HWebCompositeView {
        self.customAccessibilityLanguage = language
        return self
    }
    
    @discardableResult
    func accessibilityTraits(_ traits: UIAccessibilityTraits) -> HWebCompositeView {
        self.accessibilityTraits = traits
        return self
    }
    
    @discardableResult
    func accessibilityElementsHidden(_ hidden: Bool) -> HWebCompositeView {
        self.accessibilityElementsHidden = hidden
        return self
    }
}



// 图片处理扩展
extension HWebCompositeView {
    private static let sharedCIContext = CIContext(options: [.useSoftwareRenderer: false])

    // 处理图片，应用模糊效果、亮度、饱和度和对比度调整
    private func processImage(_ image: UIImage) -> UIImage? {
        // 如果没有需要处理的效果，直接返回原图
        guard imageBlurRadius > 0 || imageBrightness != 0 || imageSaturation != 1.0 || imageContrast != 1.0 else {
            return image
        }

        guard let ciImage = CIImage(image: image) else { return image }
        var outputImage = ciImage

        // 应用模糊效果（使用 CI 高斯模糊）
        if imageBlurRadius > 0, let blurFilter = CIFilter(name: "CIGaussianBlur") {
            blurFilter.setValue(outputImage, forKey: kCIInputImageKey)
            blurFilter.setValue(imageBlurRadius, forKey: kCIInputRadiusKey)
            if let blurred = blurFilter.outputImage {
                outputImage = blurred
            }
        }

        // 应用亮度、饱和度和对比度调整
        if imageBrightness != 0 || imageSaturation != 1.0 || imageContrast != 1.0 {
            if let colorControls = CIFilter(name: "CIColorControls") {
                colorControls.setValue(outputImage, forKey: kCIInputImageKey)
                colorControls.setValue(imageBrightness, forKey: kCIInputBrightnessKey)
                colorControls.setValue(imageSaturation, forKey: kCIInputSaturationKey)
                colorControls.setValue(imageContrast, forKey: kCIInputContrastKey)
                if let adjusted = colorControls.outputImage {
                    outputImage = adjusted
                }
            }
        }

        let ciContext = HWebCompositeView.sharedCIContext
        guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else { return image }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

// 图片加载扩展
extension HWebCompositeView {
    
    // 预加载图片到缓存
    class func preloadImage(with url: URL) {
        HWebImageLoader.preloadImage(with: url)
    }
    
    // 批量预加载图片
    class func preloadImages(with urls: [URL]) {
        HWebImageLoader.preloadImages(with: urls)
    }
    
    // 预加载图片到缓存（通过URL字符串）
    class func preloadImage(with urlString: String) {
        if let url = URL(string: urlString) {
            HWebImageLoader.preloadImage(with: url)
        }
    }
    
    // 批量预加载图片（通过URL字符串数组）
    class func preloadImages(with urlStrings: [String]) {
        let urls = urlStrings.compactMap { URL(string: $0) }
        HWebImageLoader.preloadImages(with: urls)
    }
    
    // 设置本地图片
    func setImage(WithFile fileName: String) {
        do {
            try HWebImageLoader.loadLocalImage(with: fileName, imageView: imageView)
            updateSubviews()
        } catch let error {
            didGetError?(self, error as AnyObject)
            imageLoadStatus?(self, .failure, error)
        }
    }
    
    func setImage(WithName fileName: String) {
        do {
            try HWebImageLoader.loadAssetImage(with: fileName, imageView: imageView)
            updateSubviews()
        } catch let error {
            didGetError?(self, error as AnyObject)
            imageLoadStatus?(self, .failure, error)
        }
    }
    
    // 设置网络图片
    func setImageUrl(_ url: URL, placeholder: UIImage? = nil) {
        setImageUrlString(url.absoluteString, placeholder: placeholder)
    }
    
    func setImageUrlString(_ urlString: String, placeholder: UIImage? = nil, cropSize: CGSize = .zero) {
        // 显示加载指示器
        activityIndicator.startAnimating()
        imageLoadStatus?(self, .loading, nil)
        
        // 检查URL字符串是否有效
        guard URL(string: urlString) != nil else {
            let error = NSError(domain: "HWebCompositeView", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL string"])
            activityIndicator.stopAnimating()
            imageLoadStatus?(self, .failure, error)
            didGetError?(self, error)
            return
        }
        
        _ = HWebImageLoader.loadImage(
            with: urlString,
            imageView: imageView,
            placeholder: placeholder,
            cropSize: cropSize,
            loadStatus: { [weak self] (_, status, error) in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.imageLoadStatus?(self, status, error)
            },
            getImage: { [weak self] (_, image, source) in
                guard let self = self else { return }
                self.image = image
                let style: HWebGetImageStyle = {
                    switch source {
                    case .local: return .local
                    case .network: return .network
                    case .origin: return .origin
                    }
                }()
                self.didGetImage?(self, image, style)
            },
            getError: { [weak self] (_, error) in
                guard let self = self else { return }
                self.didGetError?(self, error)
            },
            lastURLBox: lastURLBox
        )
    }
    
    // 设置背景图片
    func setBackgroundImage(WithFile fileName: String) {
        do {
            try HWebImageLoader.loadLocalImage(with: fileName, imageView: backgroundView)
            updateSubviews()
        } catch let error {
            didGetBackgroundError?(self, error as AnyObject)
            backgroundImageLoadStatus?(self, .failure, error)
        }
    }
    
    func setBackgroundImage(WithName fileName: String) {
        do {
            try HWebImageLoader.loadAssetImage(with: fileName, imageView: backgroundView)
            updateSubviews()
        } catch let error {
            didGetBackgroundError?(self, error as AnyObject)
            backgroundImageLoadStatus?(self, .failure, error)
        }
    }
    
    func setBackgroundImageUrl(_ url: URL, placeholder: UIImage? = nil) {
        setBackgroundImageUrlString(url.absoluteString, placeholder: placeholder)
    }
    
    func setBackgroundImageUrlString(_ urlString: String, placeholder: UIImage? = nil) {
        backgroundImageLoadStatus?(self, .loading, nil)

        _ = HWebImageLoader.loadImage(
            with: urlString,
            imageView: backgroundView,
            placeholder: placeholder,
            cropSize: .zero,
            loadStatus: { [weak self] (_, status, error) in
                guard let self = self else { return }
                self.backgroundImageLoadStatus?(self, status, error)
            },
            getImage: { [weak self] (_, image, source) in
                guard let self = self else { return }
                self.backgroundImage = image
                let style: HWebGetImageStyle = {
                    switch source {
                    case .local: return .local
                    case .network: return .network
                    case .origin: return .origin
                    }
                }()
                self.didGetBackgroundImage?(self, image, style)
            },
            getError: { [weak self] (_, error) in
                guard let self = self else { return }
                self.didGetBackgroundError?(self, error)
            },
            lastURLBox: nil
        )
    }
}

// 动画扩展
extension HWebCompositeView {
    
    // 执行淡入淡出动画
    func performFadeAnimation() {
        if !useFadeAnimation || useReducedAnimation {
            return
        }
        
        UIView.animate(withDuration: fadeAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: self.fadeAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.alpha = 1.0
            })
        }
    }
    
    // 执行缩放动画
    func performScaleAnimation() {
        if !useScaleAnimation || useReducedAnimation {
            return
        }
        
        UIView.animate(withDuration: scaleAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: self.scaleAnimationFrom, y: self.scaleAnimationFrom)
        }) { _ in
            UIView.animate(withDuration: self.scaleAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(scaleX: self.scaleAnimationTo, y: self.scaleAnimationTo)
            }) { _ in
                UIView.animate(withDuration: self.scaleAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = .identity
                })
            }
        }
    }
    
    // 执行旋转动画
    func performRotateAnimation() {
        if !useRotateAnimation || useReducedAnimation {
            return
        }
        
        UIView.animate(withDuration: rotateAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(rotationAngle: self.rotateAnimationFrom)
        }) { _ in
            UIView.animate(withDuration: self.rotateAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(rotationAngle: self.rotateAnimationTo)
            }) { _ in
                UIView.animate(withDuration: self.rotateAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = .identity
                })
            }
        }
    }
    
    // 执行平移动画
    func performTranslateAnimation() {
        if !useTranslateAnimation || useReducedAnimation {
            return
        }
        
        UIView.animate(withDuration: translateAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: self.translateAnimationFrom.x, y: self.translateAnimationFrom.y)
        }) { _ in
            UIView.animate(withDuration: self.translateAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(translationX: self.translateAnimationTo.x, y: self.translateAnimationTo.y)
            }) { _ in
                UIView.animate(withDuration: self.translateAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
                    self.transform = .identity
                })
            }
        }
    }
    
    // 执行弹性动画
    func performSpringAnimation() {
        if !useSpringAnimation || useReducedAnimation {
            return
        }
        
        UIView.animate(withDuration: springAnimationDuration, delay: 0, usingSpringWithDamping: springAnimationDamping, initialSpringVelocity: springAnimationVelocity, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: self.springAnimationDuration, delay: 0, usingSpringWithDamping: self.springAnimationDamping, initialSpringVelocity: self.springAnimationVelocity, options: .curveEaseInOut, animations: {
                self.transform = .identity
            })
        }
    }
    
    // 执行所有启用的动画
    func performAllAnimations() {
        if useFadeAnimation {
            performFadeAnimation()
        }
        if useScaleAnimation {
            performScaleAnimation()
        }
        if useRotateAnimation {
            performRotateAnimation()
        }
        if useTranslateAnimation {
            performTranslateAnimation()
        }
        if useSpringAnimation {
            performSpringAnimation()
        }
    }
    
    // 执行加载动画
    func startLoadingAnimation() {
        activityIndicator.startAnimating()
    }
    
    // 停止加载动画
    func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
    }
}
