//
//  HImageTextView.swift
//  FreeChat
//
//  Created by Wind on 2026-04-16.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

/// 动画配置。仅在调用方改过默认值时才分配，降低每实例占用。
struct HImageTextAnimation {
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

/// 图文视图：图片与文本按相对位置排布，可加载网络图、响应手势。
final class HImageTextView: UIView {

    enum State {
        case normal
        case disabled
        case selected
        case highlighted
        case loading
    }
    
    // MARK: - 图片相关属性
    
    /// 图片大小
    var imageSize: CGSize = .zero {
        didSet {
            if imageSize != oldValue {
                setNeedsContentLayout()
            }
        }
    }
    
    /// 图片与文字的间距
    var imageSpace: CGFloat = 0.0 {
        didSet {
            if imageSpace != oldValue {
                setNeedsContentLayout()
            }
        }
    }
    
    /// 图片位置
    var imagePosition: HImageTextPosition = .left {
        didSet {
            if imagePosition != oldValue {
                setNeedsContentLayout()
            }
        }
    }
    
    /// 模板渲染色。设置后图片以 `.alwaysTemplate` 绘制。
    var renderColor: UIColor? {
        didSet {
            if renderColor != oldValue {
                applyRenderColorToCurrentImage()
            }
        }
    }
    
    // MARK: - 交互相关属性
    
    /// 点击回调
    var pressed: Callback? {
        didSet { syncGesture(pressedGesture, enabled: pressed != nil) }
    }
    
    /// 长按回调
    var longPressed: Callback? {
        didSet { syncGesture(longPressGesture, enabled: longPressed != nil) }
    }
    
    /// 双击回调
    var doubleTapped: Callback? {
        didSet { syncGesture(doubleTapGesture, enabled: doubleTapped != nil) }
    }
    
    /// 滑动回调。与 `dragged` 同时设置时以拖拽为准，不再挂载 swipe，避免抢识别。
    var swiped: ((Any?, UISwipeGestureRecognizer.Direction) -> Void)? {
        didSet {
            if swiped != nil, dragged == nil {
                setupSwipeGestures()
            } else {
                removeSwipeGestures()
            }
            refreshUserInteraction()
        }
    }
    
    /// 拖拽回调
    var dragged: ((Any?, CGPoint, CGPoint) -> Void)? {
        didSet {
            syncGesture(panGesture, enabled: dragged != nil)
            if dragged != nil {
                removeSwipeGestures()
            } else if swiped != nil {
                setupSwipeGestures()
            }
        }
    }
    
    /// 扩大点击区域的额外边距
    var extraEdgeInsets = UIEdgeInsets.zero
    
    // MARK: - 状态管理
    
    /// 点击时是否在 `.normal` / `.selected` 间切换。默认关闭，避免普通卡片被当成开关。
    var togglesSelectionOnTap = false

    /// 视图状态。触摸高亮是临时叠加，不会覆盖 selected。
    var state: State = .normal {
        didSet {
            guard state != oldValue else { return }
            if oldValue == .loading {
                restoreTextAfterLoading()
            }
            updateStateAppearance(animated: allowsStateAnimation)
        }
    }
    
    // MARK: - 动画相关

    private static let defaultAnimationConfig = HImageTextAnimation()

    private var _animationConfig: HImageTextAnimation?

    private func setAnimation<Value>(_ keyPath: WritableKeyPath<HImageTextAnimation, Value>, _ value: Value) {
        var config = _animationConfig ?? HImageTextAnimation()
        config[keyPath: keyPath] = value
        _animationConfig = config
        if window != nil, !didPlayAppearAnimation {
            playAppearAnimationIfNeeded()
        }
    }

    private var anim: HImageTextAnimation {
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
    var imageBlurRadius: CGFloat = 0 {
        didSet { if imageBlurRadius != oldValue { reprocessCurrentImage() } }
    }
    
    /// 图片亮度调整 (-1.0 到 1.0)
    var imageBrightness: CGFloat = 0 {
        didSet { if imageBrightness != oldValue { reprocessCurrentImage() } }
    }
    
    /// 图片饱和度调整 (0.0 到 2.0)
    var imageSaturation: CGFloat = 1.0 {
        didSet { if imageSaturation != oldValue { reprocessCurrentImage() } }
    }
    
    /// 图片对比度调整 (0.0 到 2.0)
    var imageContrast: CGFloat = 1.0 {
        didSet { if imageContrast != oldValue { reprocessCurrentImage() } }
    }
    
    // MARK: - 加载指示器相关
    
    /// 加载指示器样式
    var activityIndicatorStyle: UIActivityIndicatorView.Style = .medium {
        didSet { _activityIndicator?.style = activityIndicatorStyle }
    }
    
    /// 加载指示器颜色
    var activityIndicatorColor: UIColor? {
        didSet { _activityIndicator?.color = activityIndicatorColor }
    }
    
    /// 加载指示器大小
    var activityIndicatorSize: CGSize? {
        didSet {
            if let indicator = _activityIndicator {
                remakeActivityIndicatorConstraints(indicator)
            }
        }
    }
    
    /// 加载指示器位置（相对于视图中心的偏移）
    var activityIndicatorPosition: CGPoint? {
        didSet {
            if let indicator = _activityIndicator {
                remakeActivityIndicatorConstraints(indicator)
            }
        }
    }
    
    /// 加载指示器显示/隐藏动画时长
    var activityIndicatorAnimationDuration: TimeInterval = 0.3
    
    /// 加载时的文本提示
    var loadingText: String?
    
    // MARK: - 外观相关
    
    /// 图片圆角
    var imageCornerRadius: CGFloat = 0 {
        didSet { _imageView?.layer.cornerRadius = imageCornerRadius }
    }
    
    /// 背景图片圆角
    var backgroundImageCornerRadius: CGFloat = 0 {
        didSet { _backgroundView?.layer.cornerRadius = backgroundImageCornerRadius }
    }

    /// 视图圆角。写 `layer.cornerRadius`
    var viewCornerRadius: CGFloat = 0 {
        didSet { if viewCornerRadius != oldValue { updateAppearance() } }
    }

    /// 边框宽度。写 `layer.borderWidth`
    var viewBorderWidth: CGFloat = 0 {
        didSet { if viewBorderWidth != oldValue { updateAppearance() } }
    }

    /// 边框颜色。写 `layer.borderColor`
    var viewBorderColor: UIColor? {
        didSet { if viewBorderColor != oldValue { updateAppearance() } }
    }

    /// 阴影颜色
    var shadowColor: UIColor? {
        didSet { if shadowColor != oldValue { updateAppearance() } }
    }
    
    /// 阴影偏移
    var shadowOffset: CGSize = .zero {
        didSet { if shadowOffset != oldValue { updateAppearance() } }
    }
    
    /// 阴影透明度
    var shadowOpacity: Float = 0 {
        didSet { if shadowOpacity != oldValue { updateAppearance() } }
    }
    
    /// 阴影半径
    var shadowRadius: CGFloat = 0 {
        didSet { if shadowRadius != oldValue { updateAppearance() } }
    }
    
    // MARK: - 渐变色背景相关
    
    /// 渐变色。使用 `UIColor` 而不是 `CGColor`，避免把层实现泄漏到视图 API。
    var gradientBackgroundColors: [UIColor]? {
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
    var imageLoadStatus: HImageLoadStatusBlock?
    
    // MARK: - 背景图片加载相关
    
    /// 背景图片加载错误回调
    var didGetBackgroundError: Callback?
    
    /// 获取背景图片回调
    var didGetBackgroundImage: HWebGetImageBlock?
    
    /// 背景图片加载状态回调
    var backgroundImageLoadStatus: HImageLoadStatusBlock?
    
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
    
    /// 上次加载的图片 URL
    private var lastURLBox = HImageTextURLBox("")
    private var lastBackgroundURLBox = HImageTextURLBox("")
    private var imageLoadGeneration = 0
    private var backgroundLoadGeneration = 0
    private var allowsStateAnimation = true
    private var explicitAccessibilityElement: Bool?

    /// 点击防抖时间戳（单调时钟，避免系统时间跳变）
    private var pressedInterval: TimeInterval = 0.0
    
    /// 标记是否需要更新布局
    private var layoutNeedsUpdate: Bool = true

    /// 进入 loading 前的文本，退出时还原
    private var textBeforeLoading: String?

    /// 未做滤镜处理的原图，供 renderColor / 滤镜变更时重算
    private var originalImage: UIImage?

    /// 长按已识别时吞掉随后的单击
    private var suppressNextTap = false

    /// 触摸高亮，与 selected 正交
    private var isTouchHighlighted = false

    /// 入场动画只播一次
    private var didPlayAppearAnimation = false

    /// 内部 `UIImageView` 的 contentMode。外层是 UIView，必须单独转发，否则 `contentMode` 不会作用到图上。
    private var imageContentMode: UIView.ContentMode = .scaleAspectFill
    
    // MARK: - 子视图
    
    private var _imageView: UIImageView?
    private var _backgroundView: UIImageView?
    private var _titleLabel: UILabel?
    private var _activityIndicator: UIActivityIndicatorView?

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.isAccessibilityElement = false
        // 插在背景之上、已有 overlay / 指示器之下。Tile 的顶栏/底栏会先 `addSubview` 到本视图，
        // 若这里再用 addSubview，stack 会盖住 overlay。
        insertSubview(stack, at: _backgroundView == nil ? 0 : 1)
        if let indicator = _activityIndicator {
            bringSubviewToFront(indicator)
        }
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return stack
    }()
    
    var imageView: UIImageView {
        if let imageView = _imageView { return imageView }
        let view = UIImageView()
        view.contentMode = imageContentMode
        view.layer.masksToBounds = true
        view.layer.cornerRadius = imageCornerRadius
        view.isUserInteractionEnabled = false
        view.isAccessibilityElement = false
        _imageView = view
        setNeedsContentLayout()
        return view
    }
    
    var backgroundView: UIImageView {
        if let backgroundView = _backgroundView { return backgroundView }
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = backgroundImageCornerRadius
        view.isUserInteractionEnabled = false
        view.isAccessibilityElement = false
        insertSubview(view, at: 0)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        _backgroundView = view
        return view
    }
    
    var titleLabel: UILabel {
        if let titleLabel = _titleLabel { return titleLabel }
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.isAccessibilityElement = false
        _titleLabel = label
        setNeedsContentLayout()
        return label
    }
    
    var activityIndicator: UIActivityIndicatorView {
        if let activityIndicator = _activityIndicator { return activityIndicator }
        let indicator = UIActivityIndicatorView(style: activityIndicatorStyle)
        indicator.color = activityIndicatorColor
        indicator.hidesWhenStopped = true
        indicator.isUserInteractionEnabled = false
        indicator.isAccessibilityElement = false
        addSubview(indicator)
        bringSubviewToFront(indicator)
        remakeActivityIndicatorConstraints(indicator)
        _activityIndicator = indicator
        return indicator
    }
    
    // 便捷属性
    var text: String? {
        get { _titleLabel?.text }
        set {
            if let newValue, !newValue.isEmpty {
                titleLabel.text = newValue
            } else {
                _titleLabel?.text = nil
            }
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
            refreshIsAccessibilityElement()
        }
    }
    
    var textFont: UIFont? {
        get { _titleLabel?.font }
        set {
            titleLabel.font = newValue
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
        }
    }
    
    var textColor: UIColor? {
        get { _titleLabel?.textColor }
        set {
            let color = newValue ?? .black
            normalTextColor = color
            if state == .normal || state == .highlighted {
                titleLabel.textColor = color
            }
        }
    }
    
    var textAlignment: NSTextAlignment {
        get { _titleLabel?.textAlignment ?? .center }
        set {
            titleLabel.textAlignment = newValue
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
        }
    }
    
    var image: UIImage? {
        get { _imageView?.image }
        set {
            originalImage = newValue
            applyProcessedImage(newValue)
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
            refreshIsAccessibilityElement()
        }
    }
    
    var backgroundImage: UIImage? {
        get { _backgroundView?.image }
        set {
            if let image = newValue {
                backgroundView.image = processImage(image)
            } else {
                _backgroundView?.image = nil
            }
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
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    deinit {
        _imageView?.kf.cancelDownloadTask()
        _backgroundView?.kf.cancelDownloadTask()
    }
    
    private func setup() {
        backgroundColor = .clear
        contentMode = .scaleAspectFill
        // 与 UIImageView 一致：默认不拦截 cell 点击，有手势回调后再打开。
        refreshUserInteraction()
        refreshIsAccessibilityElement()
    }

    override var contentMode: UIView.ContentMode {
        get { imageContentMode }
        set {
            super.contentMode = newValue
            imageContentMode = newValue
            _imageView?.contentMode = newValue
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            playAppearAnimationIfNeeded()
        }
    }

    private func setNeedsContentLayout() {
        layoutNeedsUpdate = true
        setNeedsLayout()
    }

    private func syncGesture(_ gesture: UIGestureRecognizer, enabled: Bool) {
        if enabled {
            if gesture.view == nil {
                addGestureRecognizer(gesture)
            }
        } else if gesture.view != nil {
            removeGestureRecognizer(gesture)
        }
        refreshGestureDependencies()
        refreshUserInteraction()
    }

    private func refreshUserInteraction() {
        let hasGesture = pressed != nil || longPressed != nil || doubleTapped != nil || swiped != nil || dragged != nil
        isUserInteractionEnabled = hasGesture && state != .disabled && state != .loading
        refreshIsAccessibilityElement()
    }

    private func refreshGestureDependencies() {
        if pressedGesture.view != nil, doubleTapGesture.view != nil {
            pressedGesture.require(toFail: doubleTapGesture)
        }
    }
    
    // 点击响应
    @objc
    private func pressedAction() {
        guard pressed != nil, state != .disabled, state != .loading else { return }
        if suppressNextTap {
            suppressNextTap = false
            return
        }
        let now = CACurrentMediaTime()
        guard now - pressedInterval > 0.5 else { return }
        pressedInterval = now
        if togglesSelectionOnTap {
            switch state {
            case .normal:
                state = .selected
            case .selected:
                state = .normal
            default:
                break
            }
        }
        performTapAnimation()
        pressed?(self, nil)
    }
    
    @objc
    private func longPressAction(_ gesture: UILongPressGestureRecognizer) {
        guard longPressed != nil, state != .disabled, state != .loading else { return }
        
        if gesture.state == .began {
            suppressNextTap = true
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.6
            }
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1.0
            }
            longPressed?(self, nil)
        } else if gesture.state == .cancelled || gesture.state == .failed {
            suppressNextTap = false
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1.0
            }
        }
    }
    
    // 双击响应
    @objc
    private func doubleTapAction() {
        guard let doubleTapped = doubleTapped, state != .disabled, state != .loading else { return }
        
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
    private func updateStateAppearance(animated: Bool = true) {
        let apply: () -> Void = { [weak self] in
            guard let self else { return }
            switch self.state {
            case .normal:
                self.backgroundColor = self.normalBackgroundColor
                self._titleLabel?.textColor = self.normalTextColor
            case .disabled:
                self.backgroundColor = self.disabledBackgroundColor
                self._titleLabel?.textColor = self.disabledTextColor
            case .selected:
                self.backgroundColor = self.selectedBackgroundColor
                self._titleLabel?.textColor = self.selectedTextColor
            case .highlighted:
                self.backgroundColor = self.highlightedBackgroundColor
                self._titleLabel?.textColor = self.highlightedTextColor
            case .loading:
                self.backgroundColor = self.loadingBackgroundColor
                self._titleLabel?.textColor = self.loadingTextColor
                if let loadingText = self.loadingText {
                    if self.textBeforeLoading == nil {
                        self.textBeforeLoading = self._titleLabel?.text
                    }
                    self.titleLabel.text = loadingText
                }
            }
            self.refreshUserInteraction()
            self.updateActivityIndicator(for: self.state)
            self.updateAppearance()
        }

        if animated, animationDuration > 0, window != nil {
            UIView.animate(withDuration: animationDuration, animations: apply)
        } else {
            apply()
        }
    }

    private func restoreTextAfterLoading() {
        if let savedText = textBeforeLoading {
            _titleLabel?.text = savedText
        }
        textBeforeLoading = nil
    }

    private func updateActivityIndicator(for state: State) {
        switch state {
        case .loading:
            activityIndicator.alpha = 0
            activityIndicator.startAnimating()
            UIView.animate(withDuration: activityIndicatorAnimationDuration) {
                self._activityIndicator?.alpha = 1
            }
        default:
            guard let indicator = _activityIndicator else { return }
            UIView.animate(withDuration: activityIndicatorAnimationDuration, animations: {
                indicator.alpha = 0
            }, completion: { _ in
                if self.state != .loading {
                    indicator.stopAnimating()
                }
            })
        }
    }
    
    private func updateAppearance() {
        layer.cornerRadius = viewCornerRadius
        layer.borderWidth = viewBorderWidth
        layer.borderColor = viewBorderColor?.cgColor

        let hasShadow = shadowColor != nil && shadowOpacity > 0
        // masksToBounds 会裁掉阴影；有阴影时只圆角背景，内容由子视图自行裁剪
        layer.masksToBounds = viewCornerRadius > 0 && !hasShadow

        if hasShadow, let color = shadowColor {
            layer.shadowColor = color.cgColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius).cgPath
        } else {
            layer.shadowOpacity = 0
            layer.shadowPath = nil
        }
        
        _imageView?.layer.cornerRadius = imageCornerRadius
        _backgroundView?.layer.cornerRadius = backgroundImageCornerRadius
        
        if let activityIndicator = _activityIndicator {
            activityIndicator.style = activityIndicatorStyle
            activityIndicator.color = activityIndicatorColor
        }
        
        updateGradientBackground()
    }
    
    private func updateGradientBackground() {
        if let colors = gradientBackgroundColors, !colors.isEmpty {
            if gradientLayer == nil {
                let layer = CAGradientLayer()
                layer.frame = bounds
                self.layer.insertSublayer(layer, at: 0)
                gradientLayer = layer
            }

            gradientLayer?.colors = colors.map { $0.cgColor }
            gradientLayer?.startPoint = gradientStartPoint
            gradientLayer?.endPoint = gradientEndPoint
            gradientLayer?.cornerRadius = viewCornerRadius
            
            _backgroundView?.isHidden = true
            backgroundColor = .clear
        } else {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil
            _backgroundView?.isHidden = false
        }
    }

    private func remakeActivityIndicatorConstraints(_ indicator: UIActivityIndicatorView) {
        indicator.snp.remakeConstraints { make in
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

    
    // MARK: - Hit testing / 触摸高亮

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let largerBounds = bounds.inset(by: UIEdgeInsets(
            top: -extraEdgeInsets.top,
            left: -extraEdgeInsets.left,
            bottom: -extraEdgeInsets.bottom,
            right: -extraEdgeInsets.right
        ))
        return largerBounds.contains(point)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        applyTouchHighlight(true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        applyTouchHighlight(false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        applyTouchHighlight(false)
    }

    private func applyTouchHighlight(_ highlighted: Bool) {
        guard state != .disabled, state != .loading else { return }
        isTouchHighlighted = highlighted
        if highlighted {
            backgroundColor = highlightedBackgroundColor
            _titleLabel?.textColor = highlightedTextColor
        } else if state != .highlighted {
            switch state {
            case .selected:
                backgroundColor = selectedBackgroundColor
                _titleLabel?.textColor = selectedTextColor
            default:
                backgroundColor = normalBackgroundColor
                _titleLabel?.textColor = normalTextColor
            }
        }
    }
    
    override var accessibilityLabel: String? {
        get { super.accessibilityLabel ?? _titleLabel?.text }
        set { super.accessibilityLabel = newValue }
    }
    
    override var accessibilityValue: String? {
        get { super.accessibilityValue }
        set { super.accessibilityValue = newValue }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            var traits = super.accessibilityTraits
            let interactive = pressed != nil || longPressed != nil || doubleTapped != nil
            if interactive {
                traits.insert(.button)
            } else if _imageView?.image != nil, _titleLabel?.text?.isEmpty ?? true {
                traits.insert(.image)
            }
            if state == .disabled { traits.insert(.notEnabled) }
            if state == .selected { traits.insert(.selected) }
            if state == .loading { traits.insert(.updatesFrequently) }
            return traits
        }
        set { super.accessibilityTraits = newValue }
    }
    
    override var isAccessibilityElement: Bool {
        get { super.isAccessibilityElement }
        set {
            explicitAccessibilityElement = newValue
            super.isAccessibilityElement = newValue
        }
    }

    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        refreshIsAccessibilityElement()
    }

    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        refreshIsAccessibilityElement(ignoring: subview)
    }

    private func refreshIsAccessibilityElement(ignoring: UIView? = nil) {
        guard explicitAccessibilityElement == nil else { return }
        if hasExternalSubviews(ignoring: ignoring) {
            super.isAccessibilityElement = false
            return
        }
        let hasText = !(_titleLabel?.text?.isEmpty ?? true)
        let hasImage = _imageView?.image != nil
        let interactive = pressed != nil || longPressed != nil || doubleTapped != nil || swiped != nil || dragged != nil
        super.isAccessibilityElement = hasText || hasImage || interactive
    }

    private func hasExternalSubviews(ignoring: UIView? = nil) -> Bool {
        subviews.contains { view in
            if view === ignoring { return false }
            if view === _backgroundView { return false }
            if view === _activityIndicator { return false }
            if view is UIStackView { return false }
            return true
        }
    }

    override func accessibilityActivate() -> Bool {
        guard pressed != nil, state != .disabled, state != .loading else { return false }
        pressedAction()
        return true
    }
    
    func prepareForReuse() {
        imageLoadGeneration += 1
        backgroundLoadGeneration += 1
        allowsStateAnimation = false
        _imageView?.kf.cancelDownloadTask()
        _backgroundView?.kf.cancelDownloadTask()
        _activityIndicator?.stopAnimating()
        originalImage = nil
        textBeforeLoading = nil
        isTouchHighlighted = false
        suppressNextTap = false
        didPlayAppearAnimation = false
        pressedInterval = 0
        lastURLBox.invalidate()
        lastBackgroundURLBox.invalidate()
        _imageView?.image = nil
        _backgroundView?.image = nil
        _titleLabel?.text = nil
        _titleLabel?.font = .systemFont(ofSize: 17)
        _titleLabel?.textAlignment = .center
        _titleLabel?.numberOfLines = 1
        _titleLabel?.textColor = .black
        imageBlurRadius = 0
        imageBrightness = 0
        imageSaturation = 1.0
        imageContrast = 1.0
        transform = .identity
        alpha = 1.0
        layer.removeAllAnimations()
        if state != .normal {
            state = .normal
        }
        pressed = nil
        longPressed = nil
        doubleTapped = nil
        swiped = nil
        dragged = nil
        didGetError = nil
        didGetImage = nil
        didGetBackgroundError = nil
        didGetBackgroundImage = nil
        imageLoadStatus = nil
        backgroundImageLoadStatus = nil
        imageSize = .zero
        imageSpace = 0
        imagePosition = .left
        imageCornerRadius = 0
        backgroundImageCornerRadius = 0
        renderColor = nil
        extraEdgeInsets = .zero
        viewCornerRadius = 0
        viewBorderWidth = 0
        viewBorderColor = nil
        shadowColor = nil
        shadowOffset = .zero
        shadowOpacity = 0
        shadowRadius = 0
        gradientBackgroundColors = nil
        loadingText = nil
        togglesSelectionOnTap = false
        _animationConfig = nil
        contentMode = .scaleAspectFill
        normalBackgroundColor = .clear
        disabledBackgroundColor = .lightGray.withAlphaComponent(0.3)
        selectedBackgroundColor = .blue.withAlphaComponent(0.1)
        highlightedBackgroundColor = .gray.withAlphaComponent(0.1)
        loadingBackgroundColor = .clear
        normalTextColor = .black
        disabledTextColor = .gray
        selectedTextColor = .blue
        highlightedTextColor = .black
        loadingTextColor = .black
        backgroundColor = .clear
        explicitAccessibilityElement = nil
        layoutNeedsUpdate = true
        allowsStateAnimation = true
        refreshIsAccessibilityElement()
    }

    /// 与 `HWebImageView` / `HWebButtonView` 对齐的复用入口。
    func resetForReuse() {
        prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
        if shadowColor != nil, shadowOpacity > 0 {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius).cgPath
        }
        updateSubviewsIfNeeded()
    }
    
    private func updateSubviewsIfNeeded() {
        guard layoutNeedsUpdate else { return }
        updateSubviews()
        layoutNeedsUpdate = false
    }
    
    private func updateSubviews() {
        _ = contentStack
        HImageTextLayout.apply(
            stackView: contentStack,
            imageView: _imageView,
            titleLabel: _titleLabel,
            imageSize: imageSize,
            imageSpace: imageSpace,
            imagePosition: imagePosition
        )
        remakeContentStackConstraints()
        invalidateIntrinsicContentSize()
    }

    private func remakeContentStackConstraints() {
        contentStack.snp.remakeConstraints { make in
            if imagePosition == .center {
                make.center.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
                make.top.greaterThanOrEqualToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    // 链式调用API
    @discardableResult
    func text(_ text: String) -> HImageTextView {
        self.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> HImageTextView {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func textFont(_ font: UIFont) -> HImageTextView {
        self.textFont = font
        return self
    }
    
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> HImageTextView {
        self.textAlignment = alignment
        return self
    }

    @discardableResult
    func textNumberOfLines(_ lines: Int) -> HImageTextView {
        titleLabel.numberOfLines = lines
        return self
    }

    @discardableResult
    func image(_ image: UIImage) -> HImageTextView {
        self.image = image
        return self
    }
    
    @discardableResult
    func imageUrl(_ url: URL, placeholder: UIImage? = nil) -> HImageTextView {
        self.setImageUrl(url, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func imageUrlString(_ urlString: String, placeholder: UIImage? = nil) -> HImageTextView {
        self.setImageUrlString(urlString, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func imageSize(_ size: CGSize) -> HImageTextView {
        self.imageSize = size
        return self
    }
    
    @discardableResult
    func imageSpace(_ space: CGFloat) -> HImageTextView {
        self.imageSpace = space
        return self
    }
    
    @discardableResult
    func imagePosition(_ position: HImageTextPosition) -> HImageTextView {
        self.imagePosition = position
        return self
    }

    @discardableResult
    func renderColor(_ color: UIColor?) -> HImageTextView {
        self.renderColor = color
        return self
    }
    
    @discardableResult
    func backgroundImage(_ image: UIImage) -> HImageTextView {
        self.backgroundImage = image
        return self
    }
    
    @discardableResult
    func backgroundImageUrl(_ url: URL, placeholder: UIImage? = nil) -> HImageTextView {
        self.setBackgroundImageUrl(url, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func backgroundImageUrlString(_ urlString: String, placeholder: UIImage? = nil) -> HImageTextView {
        self.setBackgroundImageUrlString(urlString, placeholder: placeholder)
        return self
    }
    
    @discardableResult
    func extraEdgeInsets(_ insets: UIEdgeInsets) -> HImageTextView {
        self.extraEdgeInsets = insets
        return self
    }
    
    @discardableResult
    func pressed(_ action: @escaping Callback) -> HImageTextView {
        self.pressed = action
        return self
    }
    
    @discardableResult
    func longPressed(_ action: @escaping Callback) -> HImageTextView {
        self.longPressed = action
        return self
    }
    
    @discardableResult
    func doubleTapped(_ action: @escaping Callback) -> HImageTextView {
        self.doubleTapped = action
        return self
    }
    
    @discardableResult
    func imageLoadStatus(_ status: @escaping HImageLoadStatusBlock) -> HImageTextView {
        self.imageLoadStatus = status
        return self
    }
    
    @discardableResult
    func backgroundImageLoadStatus(_ status: @escaping HImageLoadStatusBlock) -> HImageTextView {
        self.backgroundImageLoadStatus = status
        return self
    }
    
    @discardableResult
    func state(_ state: State) -> HImageTextView {
        self.state = state
        return self
    }

    @discardableResult
    func togglesSelectionOnTap(_ toggles: Bool) -> HImageTextView {
        self.togglesSelectionOnTap = toggles
        return self
    }

    @discardableResult
    func loadingText(_ text: String?) -> HImageTextView {
        self.loadingText = text
        return self
    }
    
    @discardableResult
    func animationDuration(_ duration: TimeInterval) -> HImageTextView {
        self.animationDuration = duration
        return self
    }
    
    @discardableResult
    func normalBackgroundColor(_ color: UIColor) -> HImageTextView {
        self.normalBackgroundColor = color
        if state == .normal {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func disabledBackgroundColor(_ color: UIColor) -> HImageTextView {
        self.disabledBackgroundColor = color
        if state == .disabled {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func selectedBackgroundColor(_ color: UIColor) -> HImageTextView {
        self.selectedBackgroundColor = color
        if state == .selected {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func normalTextColor(_ color: UIColor) -> HImageTextView {
        self.normalTextColor = color
        if state == .normal {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    @discardableResult
    func disabledTextColor(_ color: UIColor) -> HImageTextView {
        self.disabledTextColor = color
        if state == .disabled {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    @discardableResult
    func selectedTextColor(_ color: UIColor) -> HImageTextView {
        self.selectedTextColor = color
        if state == .selected {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    // 高亮状态外观链式调用
    @discardableResult
    func highlightedBackgroundColor(_ color: UIColor) -> HImageTextView {
        self.highlightedBackgroundColor = color
        if state == .highlighted {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func highlightedTextColor(_ color: UIColor) -> HImageTextView {
        self.highlightedTextColor = color
        if state == .highlighted {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    // 加载中状态外观链式调用
    @discardableResult
    func loadingBackgroundColor(_ color: UIColor) -> HImageTextView {
        self.loadingBackgroundColor = color
        if state == .loading {
            self.backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func loadingTextColor(_ color: UIColor) -> HImageTextView {
        self.loadingTextColor = color
        if state == .loading {
            self.titleLabel.textColor = color
        }
        return self
    }
    
    // 动画相关链式调用
    @discardableResult
    func useTapAnimation(_ use: Bool) -> HImageTextView {
        self.useTapAnimation = use
        return self
    }
    
    @discardableResult
    func useReducedAnimation(_ use: Bool) -> HImageTextView {
        self.useReducedAnimation = use
        if use {
            animationDuration = 0.2
        }
        return self
    }

    @discardableResult
    func useFadeAnimation(_ use: Bool) -> HImageTextView {
        self.useFadeAnimation = use
        return self
    }
    
    @discardableResult
    func fadeAnimationDuration(_ duration: TimeInterval) -> HImageTextView {
        self.fadeAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useScaleAnimation(_ use: Bool) -> HImageTextView {
        self.useScaleAnimation = use
        return self
    }
    
    @discardableResult
    func scaleAnimationFrom(_ from: CGFloat) -> HImageTextView {
        self.scaleAnimationFrom = from
        return self
    }
    
    @discardableResult
    func scaleAnimationTo(_ to: CGFloat) -> HImageTextView {
        self.scaleAnimationTo = to
        return self
    }
    
    @discardableResult
    func scaleAnimationDuration(_ duration: TimeInterval) -> HImageTextView {
        self.scaleAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useRotateAnimation(_ use: Bool) -> HImageTextView {
        self.useRotateAnimation = use
        return self
    }
    
    @discardableResult
    func rotateAnimationFrom(_ from: CGFloat) -> HImageTextView {
        self.rotateAnimationFrom = from
        return self
    }
    
    @discardableResult
    func rotateAnimationTo(_ to: CGFloat) -> HImageTextView {
        self.rotateAnimationTo = to
        return self
    }
    
    @discardableResult
    func rotateAnimationDuration(_ duration: TimeInterval) -> HImageTextView {
        self.rotateAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useTranslateAnimation(_ use: Bool) -> HImageTextView {
        self.useTranslateAnimation = use
        return self
    }
    
    @discardableResult
    func translateAnimationFrom(_ from: CGPoint) -> HImageTextView {
        self.translateAnimationFrom = from
        return self
    }
    
    @discardableResult
    func translateAnimationTo(_ to: CGPoint) -> HImageTextView {
        self.translateAnimationTo = to
        return self
    }
    
    @discardableResult
    func translateAnimationDuration(_ duration: TimeInterval) -> HImageTextView {
        self.translateAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func useSpringAnimation(_ use: Bool) -> HImageTextView {
        self.useSpringAnimation = use
        return self
    }
    
    @discardableResult
    func springAnimationDamping(_ damping: CGFloat) -> HImageTextView {
        self.springAnimationDamping = damping
        return self
    }
    
    @discardableResult
    func springAnimationVelocity(_ velocity: CGFloat) -> HImageTextView {
        self.springAnimationVelocity = velocity
        return self
    }
    
    @discardableResult
    func springAnimationDuration(_ duration: TimeInterval) -> HImageTextView {
        self.springAnimationDuration = duration
        return self
    }
    
    @discardableResult
    func tapAnimationScale(_ scale: CGFloat) -> HImageTextView {
        self.tapAnimationScale = scale
        return self
    }
    
    @discardableResult
    func tapAnimationAlpha(_ alpha: CGFloat) -> HImageTextView {
        self.tapAnimationAlpha = alpha
        return self
    }
    
    // 加载指示器相关链式调用
    @discardableResult
    func activityIndicatorStyle(_ style: UIActivityIndicatorView.Style) -> HImageTextView {
        self.activityIndicatorStyle = style
        updateAppearance()
        return self
    }
    
    @discardableResult
    func activityIndicatorColor(_ color: UIColor) -> HImageTextView {
        self.activityIndicatorColor = color
        updateAppearance()
        return self
    }
    
    // 外观相关链式调用
    @discardableResult
    func imageCornerRadius(_ radius: CGFloat) -> HImageTextView {
        self.imageCornerRadius = radius
        updateAppearance()
        return self
    }
    
    @discardableResult
    func backgroundImageCornerRadius(_ radius: CGFloat) -> HImageTextView {
        self.backgroundImageCornerRadius = radius
        updateAppearance()
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> HImageTextView {
        viewCornerRadius = radius
        return self
    }

    @discardableResult
    func borderWidth(_ width: CGFloat) -> HImageTextView {
        viewBorderWidth = width
        return self
    }

    @discardableResult
    func borderColor(_ color: UIColor) -> HImageTextView {
        viewBorderColor = color
        return self
    }
    
    @discardableResult
    func shadowColor(_ color: UIColor) -> HImageTextView {
        self.shadowColor = color
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> HImageTextView {
        self.shadowOffset = offset
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> HImageTextView {
        self.shadowOpacity = opacity
        updateAppearance()
        return self
    }
    
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> HImageTextView {
        self.shadowRadius = radius
        updateAppearance()
        return self
    }
    
    // 可访问性相关链式调用
    @discardableResult
    func accessibilityLabel(_ label: String) -> HImageTextView {
        self.accessibilityLabel = label
        return self
    }

    @discardableResult
    func accessibilityHint(_ hint: String) -> HImageTextView {
        self.accessibilityHint = hint
        return self
    }

    @discardableResult
    func accessibilityValue(_ value: String) -> HImageTextView {
        self.accessibilityValue = value
        return self
    }

    @discardableResult
    func isAccessibilityElement(_ isElement: Bool) -> HImageTextView {
        self.isAccessibilityElement = isElement
        return self
    }
    
    @discardableResult
    func accessibilityTraits(_ traits: UIAccessibilityTraits) -> HImageTextView {
        self.accessibilityTraits = traits
        return self
    }
    
    @discardableResult
    func accessibilityElementsHidden(_ hidden: Bool) -> HImageTextView {
        self.accessibilityElementsHidden = hidden
        return self
    }
}



// 图片处理扩展
extension HImageTextView {
    private static let sharedCIContext = CIContext(options: [.useSoftwareRenderer: false])

    private var needsImageProcessing: Bool {
        imageBlurRadius > 0 || imageBrightness != 0 || imageSaturation != 1.0 || imageContrast != 1.0
    }

    private func processImage(_ image: UIImage) -> UIImage? {
        guard needsImageProcessing else { return image }
        guard let ciImage = CIImage(image: image) else { return image }
        var outputImage = ciImage
        let originalExtent = ciImage.extent

        if imageBlurRadius > 0, let blurFilter = CIFilter(name: "CIGaussianBlur") {
            blurFilter.setValue(outputImage, forKey: kCIInputImageKey)
            blurFilter.setValue(imageBlurRadius, forKey: kCIInputRadiusKey)
            if let blurred = blurFilter.outputImage {
                outputImage = blurred
            }
        }

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

        // 高斯模糊会把 extent 扩到极大，必须裁回原图范围，否则内存爆炸。
        let cropRect = originalExtent.insetBy(dx: -imageBlurRadius * 2, dy: -imageBlurRadius * 2)
        guard let cgImage = Self.sharedCIContext.createCGImage(outputImage, from: cropRect) else { return image }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    private func applyProcessedImage(_ image: UIImage?) {
        guard let image else {
            _imageView?.image = nil
            return
        }
        let processed = processImage(image) ?? image
        if let color = renderColor {
            imageView.tintColor = color
            imageView.image = processed.withRenderingMode(.alwaysTemplate)
        } else {
            imageView.tintColor = nil
            imageView.image = processed
        }
    }

    fileprivate func applyRenderColorToCurrentImage() {
        applyProcessedImage(originalImage ?? _imageView?.image)
    }

    fileprivate func reprocessCurrentImage() {
        applyProcessedImage(originalImage ?? _imageView?.image)
    }
}

extension HImageTextView {
    
    static func preloadImage(with url: URL) {
        HImageTextLoader.preloadImage(with: url)
    }
    
    static func preloadImages(with urls: [URL]) {
        HImageTextLoader.preloadImages(with: urls)
    }
    
    static func preloadImage(with urlString: String) {
        HImageTextLoader.preloadImage(with: urlString)
    }
    
    static func preloadImages(with urlStrings: [String]) {
        HImageTextLoader.preloadImages(with: urlStrings)
    }

    private func mapImageStyle(_ source: HImageSource) -> HWebGetImageStyle {
        switch source {
        case .local: return .local
        case .network: return .network
        case .origin: return .origin
        case .cache: return .cache
        }
    }
    
    func setImage(_ image: UIImage?) {
        self.image = image
    }

    func setImage(named fileName: String) {
        do {
            try HImageTextLoader.loadAssetImage(with: fileName, imageView: imageView)
            originalImage = imageView.image
            applyProcessedImage(originalImage)
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
            imageLoadStatus?(self, .success, nil)
            didGetImage?(self, originalImage, .local)
        } catch {
            didGetError?(self, error as AnyObject)
            imageLoadStatus?(self, .failure, error)
        }
    }

    func setImage(fileName: String) {
        do {
            try HImageTextLoader.loadLocalImage(with: fileName, imageView: imageView)
            originalImage = imageView.image
            applyProcessedImage(originalImage)
            setNeedsContentLayout()
            updateSubviewsIfNeeded()
            imageLoadStatus?(self, .success, nil)
            didGetImage?(self, originalImage, .local)
        } catch {
            didGetError?(self, error as AnyObject)
            imageLoadStatus?(self, .failure, error)
        }
    }
    
    func setImageUrl(_ url: URL, placeholder: UIImage? = nil, syncLoadCache cache: Bool = false) {
        setImageUrlString(url.absoluteString, placeholder: placeholder, syncLoadCache: cache)
    }
    
    func setImageUrlString(_ urlString: String, placeholder: UIImage? = nil, syncLoadCache cache: Bool = false, cropSize: CGSize = .zero) {
        imageLoadGeneration += 1
        let generation = imageLoadGeneration
        if urlString.isEmpty {
            originalImage = placeholder
        }
        imageLoadStatus?(self, .loading, nil)

        _ = HImageTextLoader.loadImage(
            with: urlString,
            imageView: imageView,
            placeholder: placeholder,
            cropSize: cropSize,
            syncLoadCache: cache,
            loadStatus: { [weak self] (_, status, error) in
                guard let self, self.imageLoadGeneration == generation else { return }
                if status != .loading {
                    self._activityIndicator?.stopAnimating()
                }
                self.imageLoadStatus?(self, status, error)
            },
            getImage: { [weak self] (_, image, source) in
                guard let self, self.imageLoadGeneration == generation else { return }
                self.originalImage = image
                if self.needsImageProcessing || self.renderColor != nil {
                    self.applyProcessedImage(image)
                }
                self.setNeedsContentLayout()
                self.updateSubviewsIfNeeded()
                self.refreshIsAccessibilityElement()
                self.didGetImage?(self, image, self.mapImageStyle(source))
            },
            getError: { [weak self] (_, error) in
                guard let self, self.imageLoadGeneration == generation else { return }
                if urlString.isEmpty {
                    self.originalImage = placeholder
                }
                self.didGetError?(self, error)
            },
            lastURLBox: lastURLBox
        )
    }
    
    func setBackgroundImage(fileName: String) {
        do {
            try HImageTextLoader.loadLocalImage(with: fileName, imageView: backgroundView)
            backgroundImageLoadStatus?(self, .success, nil)
            didGetBackgroundImage?(self, backgroundView.image, .local)
        } catch {
            didGetBackgroundError?(self, error as AnyObject)
            backgroundImageLoadStatus?(self, .failure, error)
        }
    }
    
    func setBackgroundImage(named fileName: String) {
        do {
            try HImageTextLoader.loadAssetImage(with: fileName, imageView: backgroundView)
            backgroundImageLoadStatus?(self, .success, nil)
            didGetBackgroundImage?(self, backgroundView.image, .local)
        } catch {
            didGetBackgroundError?(self, error as AnyObject)
            backgroundImageLoadStatus?(self, .failure, error)
        }
    }
    
    func setBackgroundImageUrl(_ url: URL, placeholder: UIImage? = nil) {
        setBackgroundImageUrlString(url.absoluteString, placeholder: placeholder)
    }
    
    func setBackgroundImageUrlString(_ urlString: String, placeholder: UIImage? = nil) {
        backgroundLoadGeneration += 1
        let generation = backgroundLoadGeneration
        backgroundImageLoadStatus?(self, .loading, nil)

        _ = HImageTextLoader.loadImage(
            with: urlString,
            imageView: backgroundView,
            placeholder: placeholder,
            cropSize: .zero,
            loadStatus: { [weak self] (_, status, error) in
                guard let self, self.backgroundLoadGeneration == generation else { return }
                self.backgroundImageLoadStatus?(self, status, error)
            },
            getImage: { [weak self] (_, image, source) in
                guard let self, self.backgroundLoadGeneration == generation else { return }
                if let image {
                    self.backgroundView.image = self.processImage(image)
                }
                self.didGetBackgroundImage?(self, image, self.mapImageStyle(source))
            },
            getError: { [weak self] (_, error) in
                guard let self, self.backgroundLoadGeneration == generation else { return }
                self.didGetBackgroundError?(self, error)
            },
            lastURLBox: lastBackgroundURLBox
        )
    }
}

// 动画：点击反馈 + 入场。各效果合成一次 transform/alpha，避免互相覆盖。
extension HImageTextView {

    func playAppearAnimation() {
        didPlayAppearAnimation = false
        playAppearAnimationIfNeeded()
    }

    fileprivate func playAppearAnimationIfNeeded() {
        guard window != nil, !didPlayAppearAnimation else { return }
        guard _animationConfig != nil, hasAppearAnimation else { return }
        didPlayAppearAnimation = true

        if useReducedAnimation {
            alpha = 1
            transform = .identity
            return
        }

        var start = CGAffineTransform.identity
        if useScaleAnimation {
            start = start.scaledBy(x: scaleAnimationFrom, y: scaleAnimationFrom)
        }
        if useRotateAnimation {
            start = start.rotated(by: rotateAnimationFrom)
        }
        if useTranslateAnimation {
            start = start.translatedBy(x: translateAnimationFrom.x, y: translateAnimationFrom.y)
        }

        var end = CGAffineTransform.identity
        if useScaleAnimation {
            end = end.scaledBy(x: scaleAnimationTo, y: scaleAnimationTo)
        }
        if useRotateAnimation {
            end = end.rotated(by: rotateAnimationTo)
        }
        if useTranslateAnimation {
            end = end.translatedBy(x: translateAnimationTo.x, y: translateAnimationTo.y)
        }

        let startAlpha: CGFloat = useFadeAnimation ? 0 : 1
        alpha = startAlpha
        transform = start

        let duration = appearAnimationDuration
        let animations = {
            self.alpha = 1
            self.transform = end
        }

        if useSpringAnimation {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: springAnimationDamping,
                initialSpringVelocity: springAnimationVelocity,
                options: [.curveEaseOut, .allowUserInteraction],
                animations: animations
            )
        } else {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.curveEaseOut, .allowUserInteraction],
                animations: animations
            )
        }
    }

    private var hasAppearAnimation: Bool {
        useFadeAnimation || useScaleAnimation || useRotateAnimation || useTranslateAnimation || useSpringAnimation
    }

    private var appearAnimationDuration: TimeInterval {
        var duration: TimeInterval = animationDuration
        if useFadeAnimation { duration = max(duration, fadeAnimationDuration) }
        if useScaleAnimation { duration = max(duration, scaleAnimationDuration) }
        if useRotateAnimation { duration = max(duration, rotateAnimationDuration) }
        if useTranslateAnimation { duration = max(duration, translateAnimationDuration) }
        if useSpringAnimation { duration = max(duration, springAnimationDuration) }
        return duration
    }

    func startLoadingAnimation() {
        activityIndicator.startAnimating()
    }

    func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
    }
}
