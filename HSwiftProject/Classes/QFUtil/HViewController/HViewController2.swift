//
//  HViewController2.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/2.
//  Copyright © 2023 wind. All rights reserved.
//

//import UIKit
//
//var HNavTitleButtonWidth: CGFloat = 70
//var HNavTitleButtonMargin: CGFloat = 10
//
//class HVCAppearance {
//    static let barColor: UIColor = .white
//    static let bgColor: UIColor = .white
//    static let textColor: UIColor = .black
//    static let lightTextColor: UIColor = .lightGray
//}
//
//class HViewController: UIViewController, HNavigationBarProtocol {
//
//    private var statusBarPadding: CGFloat = 0
//    private var orientation: UIDeviceOrientation = UIDevice.current.orientation
//
//    // Generally, call the init method or the initWithNibName method to instantiate a UIViewController, regardless of which method is called, it is calling initWithNibName
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.pvc_initialize()
//    }
//
//    // Initialized using storeBoard
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.pvc_initialize()
//    }
//
//    private func pvc_initialize() {
//        // modalPresentationStyle sets the default style to UIModalPresentationFullScreen
//        self.modalPresentationStyle = .fullScreen
//        // If there is only a statusBar and no system navigation bar, the statusBar background color is transparent and you need to add a little more height to the custom navigation bar to fake the statusBar background
//        if !self.prefersStatusBarHidden && !self.prefersNavigationBarHidden {
//            statusBarPadding = UIScreen.statusBarHeight
//        }
//    }
//
//    // loadView loads the view from the nib, usually this step does not need to be interfered with. Unless you are not using a xib file to create the view, that is, you are using code to create the UI
//    override func loadView() {
//        self.pvc_initView()
//    }
//
//    private func pvc_initView() {
//        self.setNeedsNavigationBarAppearanceUpdate()
//        self.setLeftNaviImage(UIImage(named: "arrow_left"))
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.titleLabel.text = self.title
//        self.view.backgroundColor = HVCAppearance.bgColor
//        self.view.addSubview(self.topBar)
//        self.view.isExclusiveTouch = true
//        //Disable dark mode
//        if #available(iOS 13.0, *) {
//            self.overrideUserInterfaceStyle = .light
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.becomeFirstResponder()
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.view.bringSubviewToFront(self.topBar)
//        // Call this method to update the status bar status. It is best to correspond with viewWillDisappear
//        self.setNeedsStatusBarAppearanceUpdate()
//        // Dynamically set the status bar style based on the color of the navigation bar
//        //if self.preferredStatusBarColor != nil {
//        //    UIApplication.setStatusBarStyleWithColor(self.preferredStatusBarColor ?? UIColor.white)
//        //}else if self.autoAdjustStatusBarStyle && self.topBar.isHidden == false {
//        //    UIApplication.setStatusBarStyleWithColor(self.topBar.backgroundColor ?? UIColor.white)
//        //}
//        if #available(iOS 11.0, *) {
//            if let scrollView = self.view as? UIScrollView {
//                scrollView.contentInsetAdjustmentBehavior = .never
//            }
//            self.view.subviews.forEach { view in
//                if let scrollView = view as? UIScrollView {
//                    scrollView.contentInsetAdjustmentBehavior = .never
//                }
//            }
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.setNeedsStatusBarAppearanceUpdate()
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        //Reset the frame of the top bar
//        if self.orientation != UIDevice.current.orientation {
//            self.orientation = UIDevice.current.orientation
//            self.resetTopbarFrame()
//        }
//    }
//
//    override func vcWillDisappear(_ type: HVCDisappearType) {
//        if type == .pop || type == .dismiss {
//            //tupleView default tag 1213141516
//            if let tupleView = self.view.viewWithTag(1213141516) as? HTupleView {
//                tupleView.releaseTupleBlock()
//            }
//            //tableView default tag 1615141312
//            if let flowView = self.view.viewWithTag(1615141312) as? HFlowView {
//                flowView.releaseTableBlock()
//            }
//        }
//    }
//
//    /// Return event processing
//    func back() {
////        let viewcontrollers = self.navigationController?.viewControllers
////        let topViewController = self.navigationController?.topViewController
////        if viewcontrollers?.count ?? 0 > 1 && topViewController == self {
////            // dismiss with present animation
////            self.navigationController?.popViewController(animated: true)
////        }else {
////            // pop view controller with push animation
////            self.dismiss(animated: true, completion: nil)
////        }
//        switch (self.appearType) {
//        case .undefine, .present:
//            // dismiss with present animation
//            self.dismiss(animated: true, completion: nil)
//        case .push:
//            // pop view controller with push animation
//            self.navigationController?.popViewController(animated: true)
//        default:
//            break
//        }
//    }
//
//    func leftNaviButtonPressed() {
//        self.back()
//    }
//
//    func rightNaviButtonPressed() {
//
//    }
//
//    private var _topBar = UIView()
//    private var _topBarLine = UIView()
//
//    var topBar: UIView {
//        // When there is no system navigation bar, the status background color is transparent. Use a custom navigation bar to create a fake status background area.
//        if self.prefersNavigationBarHidden {
//            _topBar.frame = CGRect(x: 0, y: statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight)
//        }else {
//            _topBar.frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//            _topBar.bounds = CGRect(x: 0, y: -statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//        }
//        _topBar.autoresizingMask = .flexibleWidth
//        if _topBarLine.superview == nil {
//            _topBar.addSubview(_topBarLine)
//        }
//        _topBarLine.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: _topBar.width, height: 1)
//        _topBarLine.isHidden = self.prefersTopBarLineHidden
//        return _topBar
//    }
//
//
//    var topBarHeight: CGFloat {
//        return (self.prefersStatusBarHidden ? 0:UIScreen.statusBarHeight) + (self.prefersNavigationBarHidden ? 0:UIScreen.naviBarHeight)
//    }
//
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(x: 54, y: 0, width: self.view.width - 54 * 2, height: UIScreen.naviBarHeight)
//        label.textAlignment = .center
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 16)
//        self.topBar.addSubview(label)
//        return label
//    }()
//
//    lazy var leftNaviButton: HWebButtonView = {
//        let button = HWebButtonView()
//        button.frame = CGRect(x: 15, y: 0, width: UIScreen.naviBarHeight, height: UIScreen.naviBarHeight)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        button.contentHorizontalAlignment = .left
//        button.backgroundColor = UIColor.clear
//        button.pressed = { [weak self] (sender, data) in
//            guard let self = self else { return }
//            self.leftNaviButtonPressed()
//        }
//        button.imageView?.contentMode = .scaleAspectFit
//        self.topBar.addSubview(button)
//        return button
//    }()
//
//    private var _rightNaviButton: HWebButtonView?
//    var rightNaviButton: HWebButtonView {
//        if _rightNaviButton == nil {
//            _rightNaviButton = HWebButtonView()
//            _rightNaviButton!.backgroundColor = nil
//            _rightNaviButton!.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//            _rightNaviButton!.frame = CGRect(x: self.topBar.width - UIScreen.naviBarHeight - 10, y: 0, width: UIScreen.naviBarHeight, height: UIScreen.naviBarHeight)
//            _rightNaviButton!.autoresizingMask = .flexibleLeftMargin
//            _rightNaviButton!.contentHorizontalAlignment = .center
//            _rightNaviButton!.titleLabel?.adjustsFontSizeToFitWidth = true
//            _rightNaviButton!.pressed = { [weak self] (sender, data) in
//                guard let self = self else { return }
//                self.rightNaviButtonPressed()
//            }
//            self.topBar.addSubview(_rightNaviButton!)
//        }
//        return _rightNaviButton!
//    }
//
//    //Reset the frame of the top bar
//    private func resetTopbarFrame() {
//        statusBarPadding = 0
//        if !self.prefersStatusBarHidden && !self.prefersNavigationBarHidden {
//            statusBarPadding = UIScreen.statusBarHeight
//        }
//        //reset topBar
//        if (self.prefersNavigationBarHidden) {
//            self.topBar.frame = CGRect(x: 0, y: statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight)
//        } else {
//            self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//            self.topBar.bounds = CGRect(x: 0, y: -statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//        }
//        //reset topBar line
//        _topBarLine.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: topBar.width, height: 1)
//        //reset title label
//        if let rightNaviButton = _rightNaviButton {
//            //reset right button
//            rightNaviButton.frame = CGRect(x: topBar.width - rightNaviButton.width - 10, y: rightNaviButton.y, width: rightNaviButton.width, height: rightNaviButton.height)
//            var minX: CGFloat = 0.0
//            let width: CGFloat = max(self.leftNaviButton.width, rightNaviButton.width)
//            if self.leftNaviButton.width == width {
//                minX = self.leftNaviButton.minX
//            } else {
//                minX = self.view.width - rightNaviButton.maxX
//            }
//            self.titleLabel.frame = CGRect(x: minX + width, y: 0, width: self.view.width - 2 * (minX + width), height: UIScreen.naviBarHeight)
//        } else {
//            let width: CGFloat = self.leftNaviButton.width
//            self.titleLabel.frame = CGRect(x: self.leftNaviButton.minX + width, y: 0, width: self.view.width - 2 * (self.leftNaviButton.minX + width), height: UIScreen.naviBarHeight)
//        }
//    }
//
//    override var title: String? {
//        didSet {
//            guard self.isViewLoaded else { return }
//            self.titleLabel.text = title
//        }
//    }
//
//    lazy var navigationBar: HNavigationBar = {
//        let frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
//        let navigationBar = HNavigationBar(frame: frame)
//        navigationBar.delegate = self
//        self.view.addSubview(navigationBar)
//        return navigationBar
//    }()
//
//    func navigationBarLeftItemPressed(_ leftItem: HWebButtonView?) {
//        self.leftNaviButtonPressed()
//    }
//
//    func navigationBarRightItemPressed(_ rightItem: HWebButtonView?) {
//        self.rightNaviButtonPressed()
//    }
//
//    func setLeftNaviImage(_ image: UIImage?) {
//        self.leftNaviButton.setTitle("", for: [.normal, .highlighted])
//        self.leftNaviButton.setImage(image, for: [.normal, .highlighted])
//    }
//    func setLeftNaviImageURL(_ imageURL: String) {
//        self.leftNaviButton.setTitle("", for: [.normal, .highlighted])
//        self.leftNaviButton.setImage(nil, for: [.normal, .highlighted])
//        self.leftNaviButton.setImageUrlString(imageURL)
//    }
//    func setNaviLeftImage(_ normal: UIImage?, highlight: UIImage?) {
//        self.leftNaviButton.setTitle("", for: [.normal, .highlighted])
//        self.leftNaviButton.setImage(normal, for: .normal)
//        self.leftNaviButton.setImage(highlight, for: .highlighted)
//    }
//    func setRightNaviImage(_ image: UIImage?) {
//        self.rightNaviButton.setTitle("", for: [.normal, .highlighted])
//        self.rightNaviButton.setImage(image, for: [.normal, .highlighted])
//    }
//    func setRightNaviImageURL(_ imageURL: String) {
//        self.rightNaviButton.setTitle("", for: [.normal, .highlighted])
//        self.rightNaviButton.setImage(nil, for: [.normal, .highlighted])
//        self.rightNaviButton.setImageUrlString(imageURL)
//    }
//    func setNaviRightImage(_ normal: UIImage?, highlight: UIImage?) {
//        self.rightNaviButton.setTitle("", for: [.normal, .highlighted])
//        self.rightNaviButton.setImage(normal, for: .normal)
//        self.rightNaviButton.setImage(highlight, for: .highlighted)
//    }
//    func setLeftNaviTitle(_ title: String) {
//        self.leftNaviButton.setTitle(title, for: [.normal, .highlighted])
//        self.leftNaviButton.setImage(nil, for: [.normal, .highlighted])
//    }
//    func setLeftNaviTitle(_ imageURL: String, titleColor: UIColor, highlightcolor: UIColor) {
//        self.leftNaviButton.setTitle(title, for: [.normal, .highlighted])
//        self.leftNaviButton.setTitleColor(titleColor, for: .normal)
//        self.leftNaviButton.setTitleColor(highlightcolor, for: .highlighted)
//        self.leftNaviButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.leftNaviButton.frame = CGRect(x: HNavTitleButtonMargin, y: self.rightNaviButton.y, width: HNavTitleButtonWidth, height: self.rightNaviButton.height)
//        self.leftNaviButton.setImage(nil, for: [.normal, .highlighted])
//    }
//    func setRightNaviTitle(_ title: String) {
//        self.rightNaviButton.setTitle(title, for: [.normal, .highlighted])
//        self.rightNaviButton.setImage(nil, for: [.normal, .highlighted])
//    }
//    func setRightNaviTitle(_ imageURL: String, titleColor: UIColor, highlightcolor: UIColor) {
//        self.rightNaviButton.setTitle(title, for: [.normal, .highlighted])
//        self.rightNaviButton.setTitleColor(titleColor, for: .normal)
//        self.rightNaviButton.setTitleColor(highlightcolor, for: .highlighted)
//        self.rightNaviButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.rightNaviButton.frame = CGRect(x: self.topBar.width - HNavTitleButtonWidth - HNavTitleButtonMargin, y: self.rightNaviButton.y, width: HNavTitleButtonWidth, height: self.rightNaviButton.height)
//        self.rightNaviButton.setImage(nil, for: [.normal, .highlighted])
//    }
//
//    /// Navigation bar status control
//    func setNeedsNavigationBarAppearanceUpdate() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.topBar.isHidden = self.prefersNavigationBarHidden
//        self.topBar.backgroundColor = self.preferredNaviBarColor
//        _topBarLine.backgroundColor = self.preferredNaviShadowColor
//    }
//
//    var autoAdjustStatusBarStyle: Bool {
//        if self.prefersStatusBarHidden {
//            return false
//        }
//        return true
//    }
//
//    var preferredStatusBarColor: UIColor? {
//        return nil
//    }
//
//    var prefersTopBarLineHidden: Bool {
//        return false
//    }
//
//    var prefersNavigationBarHidden: Bool {
//        return false
//    }
//
//    var preferredNaviBarColor: UIColor {
//        return HVCAppearance.barColor
//    }
//
//    var preferredNaviShadowColor: UIColor {
//        return UIColor(hex: 0xe5e5e5)
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        // Dynamically set the status bar style based on the color of the navigation bar
//        let statusBarColor = self.preferredStatusBarColor?.isLighterColor ?? false
//        let topColor = _topBar.backgroundColor?.isLighterColor ?? false
//        if statusBarColor || topColor {
//            if #available(iOS 13.0, *) {
//                return .darkContent
//            } else {
//                return .default
//            }
//        }
//        return .lightContent
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return UIApplication.statusBarOrientation()?.isLandscape ?? false
//    }
//
//    // Controls the application's preferred home indicator auto-hiding when this view controller is shown.
//    override var prefersHomeIndicatorAutoHidden: Bool {
//        return true
//    }
//
////    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
////        let orientation = UIScreen.current.orientation
////        if orientation == .landscapeLeft || orientation == .landscapeRight {
////            switch orientation {
////            case .landscapeLeft:
////                return UIInterfaceOrientation.landscapeLeft
////            case .landscapeRight:
////                return UIInterfaceOrientation.landscapeRight
////            default:
////                return UIInterfaceOrientation.landscapeRight
////            }
////        }
////        return UIInterfaceOrientation.landscapeRight
////    }
//
//}
//
///// Landscape and portrait
//extension HViewController {
//    /// Rotation support
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//        //return [.portrait, .landscapeLeft, .landscapeRight]
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .portrait
//    }
//}
//
//extension UIViewController {
//    func transitionChildViewControllerWithIndex(_ index: Int) {
//        guard index >= 0 && index < children.count else { return }
//
//        for i in 0..<children.count {
//            let vc = children[i]
//            if vc.view.superview != nil && index != i {
//                vc.view.removeFromSuperview()
//            }
//        }
//
//        let vc = children[index]
//        if vc.view.superview == nil {
//            view.addSubview(vc.view)
//        }
//    }
//
//    func pushChildViewController(_ viewController: UIViewController) {
//        if children.isEmpty {
//            view.addSubview(viewController.view)
//            addChild(viewController)
//        } else if let lastVC = children.last {
//            transition(from: lastVC, to: viewController, duration: 0.25, options: .curveEaseInOut, animations: nil, completion: nil)
//        }
//    }
//
//    func popChildViewController() {
//        if children.count == 1 {
//            let vc = children.last!
//            vc.view.removeFromSuperview()
//            vc.removeFromParent()
//        } else if children.count >= 2 {
//            let vc1 = children[children.count - 1]
//            let vc2 = children[children.count - 2]
//            transition(from: vc1, to: vc2, duration: 0.25, options: .curveEaseInOut, animations: nil) { finished in
//                if finished {
//                    vc1.view.removeFromSuperview()
//                    vc1.removeFromParent()
//                }
//            }
//        }
//    }
//
//    func addChildViewController(_ viewController: UIViewController) {
//        addChild(viewController)
//        view.addSubview(viewController.view)
//        viewController.didMove(toParent: self)
//    }
//
//    func removeChildViewController(_ viewController: UIViewController) {
//        viewController.willMove(toParent: nil)
//        viewController.view.removeFromSuperview()
//        viewController.removeFromParent()
//    }
//}
//
