//
//  HViewController.swift
//  HSwiftProject
//
//  Created by wind on 2019/11/16.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
//import SwizzleSwift

var HNavTitleButtonWidth: CGFloat = 70
var HNavTitleButtonMargin: CGFloat = 10

private var sourceArrKey = "sourceArrKey"
private var sourceDictKey = "sourceDictKey"

class HVCAppearance: NSObject {
    static let barColor: UIColor = UIColor.white
    static let bgColor: UIColor = UIColor.white
    static let textColor: UIColor = UIColor.black
    static let lightTextColor: UIColor = UIColor.lightGray
}

//extension UIView {
//
//    @objc static func swizzle() {
//        Swizzle(UIView.self) {
//            #selector(willMove(toSuperview:)) <-> #selector(pvc_willMove(toSuperview:))
//        }
//    }
//
//    @objc func pvc_willMove(toSuperview newSuperview: UIView?) {
//        //关闭暗黑模式
//        if #available(iOS 13.0, *) {
//            self.overrideUserInterfaceStyle = .light
//        }
//        self.pvc_willMove(toSuperview: newSuperview)
//    }
//}

class HViewController: UIViewController {
    
    private var controllableRequests: NSMutableArray = NSMutableArray()
    private var statusBarPadding: CGFloat = 0
    private var orientation: UIDeviceOrientation = UIDevice.current.orientation
        
    //一般情况下调用 init 方法或者调用 initWithNibName 方法实例化 UIViewController, 不管调用哪个方法都为调用 initWithNibName
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.pvc_initialize()
    }

    //使用storeBoard初始化的
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.pvc_initialize()
    }

    private func pvc_initialize() {
        //modalPresentationStyle 设置默认样式为 UIModalPresentationFullScreen
        self.modalPresentationStyle = .fullScreen
        //只有statusBar没有系统导航栏的情况下,statusBar背景色是透明的需要自定义的导航栏多增加一点高度来伪造statusBar的背景
        if self.prefersStatusBarHidden == false && self.prefersNavigationBarHidden == false {
            statusBarPadding = UIScreen.statusBarHeight
        }
    }

    //loadView 从nib载入视图 ，通常这一步不需要去干涉。除非你没有使用xib文件创建视图,即用代码创建的UI
    override func loadView() {
        super.loadView()
        self.pvc_initView()
    }

    private func pvc_initView() {
        self.setNeedsNavigationBarAppearanceUpdate()
        self.setLeftNaviImage(UIImage(named: "hvc_back_icon"))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if controllableRequests.count > 0 {
            controllableRequests.enumerateObjects { (obj, idx, stop) in
                //let net = obj as! HNetworkDAO
                //net.cancel()
            }
            controllableRequests.removeAllObjects()
        }
        #if DEBUG
//        NSString *message = [NSStringFromClass(self.class) stringByAppendingString:@"--释放内存"]
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert]
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了"
//                                                               style:UIAlertActionStyleCancel
//                                                             handler:^(UIAlertAction * _Nonnull action) {}]
//        [alertController addAction:cancelAction]
//        UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController
//        [rootController presentViewController:alertController animated:YES completion:nil]
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title?.isEmpty != false {
            self.titleLabel.text = self.title
        }
        self.view.backgroundColor = HVCAppearance.bgColor
        self.view.addSubview(self.topBar)
        self.view.isExclusiveTouch = true
        //关闭暗黑模式
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.bringSubviewToFront(self.topBar)
        //要更新statusbar状态的需要调用下这个方法,最好与viewWillDisappear对应
        self.setNeedsStatusBarAppearanceUpdate()
        //根据导航栏的颜色动态设置状态栏样式
        //if self.preferredStatusBarColor != nil {
        //    UIApplication.setStatusBarStyleWithColor(self.preferredStatusBarColor ?? UIColor.white)
        //}else if self.autoAdjustStatusBarStyle && self.topBar.isHidden == false {
        //    UIApplication.setStatusBarStyleWithColor(self.topBar.backgroundColor ?? UIColor.white)
        //}
        if #available(iOS 11.0, *) {
            if self.view.isKind(of: UIScrollView.self) {
                let scrollView: UIScrollView = self.view as! UIScrollView
                scrollView.contentInsetAdjustmentBehavior = .never
            }
            for view in self.view.subviews {
                if view.isKind(of: UIScrollView.self) {
                    let scrollView: UIScrollView = view as! UIScrollView
                    scrollView.contentInsetAdjustmentBehavior = .never
                }
            }
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //重新设置topbar的frame
        if self.orientation != UIDevice.current.orientation {
            self.orientation = UIDevice.current.orientation
            self.resetTopbarFrame()
        }
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        if (type == .pop || type == .dismiss) {
            //tupleView default tag 1213141516
            let tupleView = self.view.viewWithTag(1213141516)
            if tupleView?.isKind(of: NSClassFromString("HTupleView") ?? UIView.self) ?? false {
                let selector = NSSelectorFromString("releaseTupleBlock")
                if tupleView?.responds(to: selector) ?? false {
                    tupleView?.perform(selector)
                }
            }
            //tableView default tag 1615141312
            let tableView = self.view.viewWithTag(1615141312)
            if tableView?.isKind(of: NSClassFromString("HTableView") ?? UIView.self) ?? false {
                let selector = NSSelectorFromString("releaseTableBlock")
                if tableView?.responds(to: selector) ?? false {
                    tableView?.perform(selector)
                }
            }
        }
    }

    /// 事件处理
    func back() {
        let viewcontrollers = self.navigationController?.viewControllers
        let topViewController = self.navigationController?.topViewController
        if viewcontrollers?.count ?? 0 > 1 && topViewController == self {
            self.navigationController?.popViewController(animated: true)//push方式
        }else {
            self.dismiss(animated: true, completion: nil)//present方式
        }
    }

    func leftNaviButtonPressed() {
        self.back()
    }

    func rightNaviButtonPressed() {
        
    }

    /// 各个视图
    private var _topBar: UIView?
    private var _topBarLine: UIView?
    
    var topBar: UIView {
        if _topBar == nil { _topBar = UIView() }
        //topBar = [[UIButton alloc] init]
        //[topBar setAdjustsImageWhenHighlighted:NO]
        //没有系统导航栏的时候,status背景色是透明的,用自定义导航栏去伪造一个status背景区域
        if self.prefersNavigationBarHidden {
            _topBar!.frame = CGRect(x: 0, y: statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight)
        }else {
            _topBar!.frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
            _topBar!.bounds = CGRect(x: 0, y: -statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
        }
        _topBar!.autoresizingMask = .flexibleWidth
        if _topBarLine == nil {
            _topBarLine = UIView()
            _topBar!.addSubview(_topBarLine!)
        }
        _topBarLine!.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: _topBar!.width, height: 1)
        _topBarLine!.isHidden = self.prefersTopBarLineHidden
        return _topBar!
    }

    var topBarHeight: CGFloat {
        return (self.prefersStatusBarHidden ? 0:UIScreen.statusBarHeight) + (self.prefersNavigationBarHidden ? 0:UIScreen.naviBarHeight)
    }
    
    private var _titleLabel: UILabel?
    var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel!.frame = CGRect(x: 54, y: 5, width: self.view.width - 54 * 2, height: UIScreen.naviBarHeight - 5)
            _titleLabel!.textAlignment = .center
            _titleLabel!.textColor = UIColor.black
            _titleLabel!.font = UIFont.systemFont(ofSize: 18)
            self.topBar.addSubview(_titleLabel!)
        }
        return _titleLabel!
    }

    private var _leftNaviButton: HWebButtonView?
    var leftNaviButton: HWebButtonView {
        if _leftNaviButton == nil {
            _leftNaviButton = HWebButtonView()
            _leftNaviButton!.backgroundColor = nil
            _leftNaviButton!.frame = CGRect(x: 10, y: 5, width: UIScreen.naviBarHeight, height: UIScreen.naviBarHeight - 5)
            _leftNaviButton!.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            _leftNaviButton!.contentHorizontalAlignment = .left
            _leftNaviButton!.pressed = { [weak self] (_ sender: Any?, _ data: Any?) -> Void in
                self!.leftNaviButtonPressed()
            }
            _leftNaviButton!.imageView?.contentMode = .scaleAspectFit
            self.topBar.addSubview(_leftNaviButton!)
        }
        return _leftNaviButton!
    }
    
    private var _rightNaviButton: HWebButtonView?
    var rightNaviButton: HWebButtonView {
        if _rightNaviButton == nil {
            _rightNaviButton = HWebButtonView()
            _rightNaviButton!.backgroundColor = nil
            _rightNaviButton!.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            _rightNaviButton!.frame = CGRect(x: self.topBar.width - UIScreen.naviBarHeight - 10, y: 5, width: UIScreen.naviBarHeight, height: UIScreen.naviBarHeight - 5)
            _rightNaviButton!.autoresizingMask = .flexibleLeftMargin
            _rightNaviButton!.contentHorizontalAlignment = .center
            _rightNaviButton!.pressed = { [weak self] (_ sender: Any?, _ data: Any?) -> Void in
                self!.rightNaviButtonPressed()
            }
            self.topBar.addSubview(_rightNaviButton!)
        }
        return _rightNaviButton!
    }

    //重新设置topbar的frame
    private func resetTopbarFrame() {
        statusBarPadding = 0
        if self.prefersStatusBarHidden == false && self.prefersNavigationBarHidden == false {
            statusBarPadding = UIScreen.statusBarHeight
        }
        //reset topBar
        if(self.prefersNavigationBarHidden) {
            self.topBar.frame = CGRect(x: 0, y: statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight)
        }else {
            self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
            self.topBar.bounds = CGRect(x: 0, y: -statusBarPadding, width: self.view.width, height: UIScreen.naviBarHeight + statusBarPadding)
        }
        //reset topBar line
        _topBarLine!.frame = CGRect(x: 0, y: UIScreen.naviBarHeight - 1, width: topBar.width, height: 1)
        //reset title label
        if _rightNaviButton != nil {
            //reset right button
            _rightNaviButton!.frame = CGRect(x: topBar.width - _rightNaviButton!.width - 10, y: _rightNaviButton!.y, width: _rightNaviButton!.width, height: _rightNaviButton!.height)
            var minX: CGFloat = 0.0
            let width: CGFloat = max(_leftNaviButton!.width, _rightNaviButton!.width)
            if _leftNaviButton!.width == width {
                minX = _leftNaviButton!.minX
            }else {
                minX = self.view.width - _rightNaviButton!.maxX
            }
            self.titleLabel.frame = CGRect(x: minX + width, y: 0, width: self.view.width - 2 * (minX + width), height: UIScreen.naviBarHeight)
        }else {
            let width: CGFloat = _leftNaviButton!.width
            self.titleLabel.frame = CGRect(x: _leftNaviButton!.minX + width, y: 0, width: self.view.width - 2 * (_leftNaviButton!.minX + width), height: UIScreen.naviBarHeight)
        }
    }

    /// 设置视图
    override var title: String? {
        get {
            return super.title
        }
        set {
            super.title = newValue
            if self.isViewLoaded {
                self.titleLabel.text = newValue
            }
        }
    }

    func setLeftNaviImage(_ image: UIImage?) {
        self.leftNaviButton.setTitle("", for: .normal)
        self.leftNaviButton.setTitle("", for: .highlighted)
        self.leftNaviButton.setImage(image, for: .normal)
        self.leftNaviButton.setImage(image, for: .highlighted)
    }
    func setLeftNaviImageURL(_ imageURL: String) {
        self.leftNaviButton.setTitle("", for: .normal)
        self.leftNaviButton.setTitle("", for: .highlighted)
        self.leftNaviButton.setImage(nil, for: .normal)
        self.leftNaviButton.setImage(nil, for: .highlighted)
        self.leftNaviButton.setImageUrlString(imageURL)
    }
    func setNaviLeftImage(_ normal: UIImage?, highlight: UIImage?) {
        self.leftNaviButton.setTitle("", for: .normal)
        self.leftNaviButton.setTitle("", for: .highlighted)
        self.leftNaviButton.setImage(normal, for: .normal)
        self.leftNaviButton.setImage(highlight, for: .highlighted)
    }
    func setRightNaviImage(_ image: UIImage?) {
        self.rightNaviButton.setTitle("", for: .normal)
        self.rightNaviButton.setTitle("", for: .highlighted)
        self.rightNaviButton.setImage(image, for: .normal)
        self.rightNaviButton.setImage(image, for: .highlighted)
    }
    func setRightNaviImageURL(_ imageURL: String) {
        self.rightNaviButton.setTitle("", for: .normal)
        self.rightNaviButton.setTitle("", for: .highlighted)
        self.rightNaviButton.setImage(nil, for: .normal)
        self.rightNaviButton.setImage(nil, for: .highlighted)
        self.rightNaviButton.setImageUrlString(imageURL)
    }
    func setNaviRightImage(_ normal: UIImage?, highlight: UIImage?) {
        self.rightNaviButton.setTitle("", for: .normal)
        self.rightNaviButton.setTitle("", for: .highlighted)
        self.rightNaviButton.setImage(normal, for: .normal)
        self.rightNaviButton.setImage(highlight, for: .highlighted)
    }
    func setLeftNaviTitle(_ title: String) {
        self.leftNaviButton.setTitle(title, for: .normal)
        self.leftNaviButton.setTitle(title, for: .highlighted)
        self.leftNaviButton.setImage(nil, for: .normal)
        self.leftNaviButton.setImage(nil, for: .highlighted)
    }
    func setLeftNaviTitle(_ imageURL: String, titleColor: UIColor, highlightcolor: UIColor) {
        self.leftNaviButton.setTitle(title, for: .normal)
        self.leftNaviButton.setTitle(title, for: .highlighted)
        self.leftNaviButton.setTitleColor(titleColor, for: .normal)
        self.leftNaviButton.setTitleColor(highlightcolor, for: .highlighted)
        self.leftNaviButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.leftNaviButton.frame = CGRect(x: HNavTitleButtonMargin, y: self.rightNaviButton.y, width: HNavTitleButtonWidth, height: self.rightNaviButton.height)
        self.leftNaviButton.setImage(nil, for: .normal)
        self.leftNaviButton.setImage(nil, for: .highlighted)
    }
    func setRightNaviTitle(_ title: String) {
        self.rightNaviButton.setTitle(title, for: .normal)
        self.rightNaviButton.setTitle(title, for: .highlighted)
        self.rightNaviButton.setImage(nil, for: .normal)
        self.rightNaviButton.setImage(nil, for: .highlighted)
    }
    func setRightNaviTitle(_ imageURL: String, titleColor: UIColor, highlightcolor: UIColor) {
        self.rightNaviButton.setTitle(title, for: .normal)
        self.rightNaviButton.setTitle(title, for: .highlighted)
        self.rightNaviButton.setTitleColor(titleColor, for: .normal)
        self.rightNaviButton.setTitleColor(highlightcolor, for: .highlighted)
        self.rightNaviButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.rightNaviButton.frame = CGRect(x: self.topBar.width - HNavTitleButtonWidth - HNavTitleButtonMargin, y: self.rightNaviButton.y, width: HNavTitleButtonWidth, height: self.rightNaviButton.height)
        self.rightNaviButton.setImage(nil, for: .normal)
        self.rightNaviButton.setImage(nil, for: .highlighted)
    }
    
    /// 导航栏状态控制
    func setNeedsNavigationBarAppearanceUpdate() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.topBar.isHidden = self.prefersNavigationBarHidden
        self.topBar.backgroundColor = self.preferredNaviBarColor
        _topBarLine!.backgroundColor = self.preferredNaviShadowColor
    }

    var autoAdjustStatusBarStyle: Bool {
        if self.prefersStatusBarHidden {
            return false
        }
        return true
    }

    var preferredStatusBarColor: UIColor? {
        return nil
    }
    
    var prefersTopBarLineHidden: Bool {
        return false
    }

    var prefersNavigationBarHidden: Bool {
        return false
    }

    var preferredNaviBarColor: UIColor {
        return HVCAppearance.barColor
    }

    var preferredNaviShadowColor: UIColor {
        return UIColor(hex: 0xe5e5e5)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        let preferredStatusBarColor: UIColor? = self.preferredStatusBarColor
        if preferredStatusBarColor !== nil && preferredStatusBarColor?.isLighterColor ?? false {
            if #available(iOS 13.0, *) {
                return .darkContent
            }else {
                return .default
            }
        }else if _topBar != nil && _topBar!.backgroundColor?.isLighterColor ?? false {
            if #available(iOS 13.0, *) {
                return .darkContent
            }else {
                return .default
            }
        }else {
            return .lightContent
        }
    }

    override var prefersStatusBarHidden: Bool {
        if UIApplication.statusBarOrientation()?.isLandscape ?? false {
            return true
        }
        return false
    }

    // Controls the application's preferred home indicator auto-hiding when this view controller is shown.
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    /// 旋转支持
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        //return [.portrait, .landscapeLeft, .landscapeRight]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        let orientation = UIDevice.current.orientation
//        if orientation == .landscapeLeft || orientation == .landscapeRight {
//            switch orientation {
//            case .landscapeLeft:
//                return UIInterfaceOrientation.landscapeLeft
//            case .landscapeRight:
//                return UIInterfaceOrientation.landscapeRight
//            default:
//                return UIInterfaceOrientation.landscapeRight
//            }
//        }
//        return UIInterfaceOrientation.landscapeRight
//    }
        
//    func controlRequest(_ request: HNetworkDAO) {
//        if ([request isKindOfClass:[HNetworkDAO class]]) {
//            [self.controllableRequests addObject:request]
//        }
//    }

    func refresh() {
        
    }
    ///需要释放内存
    func needReleaseMemory() {
        
    }
    func popGestureEnabled() -> Bool {
        return true
    }

}

extension UIViewController {
    func transitionChildViewControllerWithIndex(_ index: Int) {
        let count: Int = self.children.count
        if index >= 0 && index < count {
            for i in 0 ..< count {
                let vc = self.children[i]
                if vc.view.superview != nil && index != i {
                    vc.view.removeFromSuperview()
                }
            }
            let vc = self.children[index]
            if vc.view.superview == nil {
                self.view.addSubview(vc.view)
            }
        }
    }
    func pushChildViewController(_ viewController: UIViewController) {
        if self.children.count == 0 {
            self.view.addSubview(viewController.view)
            self.addChild(viewController)
        }else if self.children.count >= 1 {
            let vc = self.children.last!
            self.transition(from: vc, to: viewController, duration: 0.25, options: .curveEaseInOut, animations: nil, completion: nil)
        }
    }
    func popChildViewController() {
        if self.children.count == 1 {
            let vc = self.children.last!
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }else if self.children.count >= 2 {
            let vc1 = self.children[self.children.count - 1]
            let vc2 = self.children[self.children.count - 2]
            self.transition(from: vc1, to: vc2, duration: 0.25, options: .curveEaseInOut, animations: nil) { finished in
                if finished {
                    vc1.view.removeFromSuperview()
                    vc1.removeFromParent()
                }
            }
        }
    }
}

extension HViewController {
    var window: UIWindow? {
        return UIApplication.shared.delegate?.window as? UIWindow
    }
    var screen: UIScreen {
        return UIScreen.main
    }
    var sourceArr: NSMutableArray {
        get {
            var array = self.getAssociatedValueForKey(&sourceArrKey)
            if array == nil {
                array = NSMutableArray()
                self.setAssociateValue(array, key: &sourceArrKey)
            }
            return array as! NSMutableArray
        }
    }
    var sourceDict: NSMutableDictionary {
        get {
            var dictionary = self.getAssociatedValueForKey(&sourceDictKey)
            if dictionary == nil {
                dictionary = NSMutableDictionary()
                self.setAssociateValue(dictionary, key: &sourceDictKey)
            }
            return dictionary as! NSMutableDictionary
        }
    }
}
