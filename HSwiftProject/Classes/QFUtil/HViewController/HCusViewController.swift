//
//  HCusViewController.swift
//  HSwiftProject
//
//  Created by owner on 2025/6/29.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HCusViewController<VM: DPMBaseViewModel>: HBaseController {
    
    // MARK: - Properties
    
    let viewModel: VM
    
    var disposeBag: DisposeBag? = DisposeBag()
    
    /// 导航栏的样式
    var navShowStyle: HNaviShowStyle = .normal {
        didSet {
            updateNavigationBarAppearance()
            setupBackButton()
        }
    }
    
    // MARK: - UI Components
    
    /// 导航栏视图
    private lazy var navigationView: HNavigationView = {
        HNavigationView(frame: .zero)
    }()
    
    /// 导航栏
    var navigationBar: UINavigationBar {
        navigationView.navigationBar
    }
    
    override var navigationItem: UINavigationItem {
        navigationView.navigationItem
    }
    
    /// 导航栏分割线
    var navigationLine: UIView {
        navigationView.navigationLine
    }
    
    // MARK: - Initialization
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navShowStyle = .normal
        setupNavigationLayout()
        addSubviews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.bringSubviewToFront(navigationView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Navigation Bar
    
    /// 设置导航栏布局
    private func setupNavigationLayout() {
        view.addSubview(navigationView)
        
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.topBarHeight)
        }
    }
    
    /// 更新导航栏外观
    private func updateNavigationBarAppearance() {
        let (titleColor, backgroundColor) = getNavigationBarColors(for: navShowStyle)
        let attributes = createTitleAttributes(with: titleColor)
        
        if #available(iOS 15.0, *) {
            let barApp = UINavigationBarAppearance()
            barApp.titleTextAttributes = attributes
            barApp.backgroundColor = backgroundColor
            barApp.backgroundEffect = nil
            barApp.shadowColor = nil
            navigationBar.scrollEdgeAppearance = barApp
            navigationBar.standardAppearance = barApp
        } else {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.titleTextAttributes = attributes
        }
        
        navigationView.backgroundColor = backgroundColor
        navigationBar.backgroundColor = backgroundColor
        navigationBar.isTranslucent = backgroundColor == .clear
    }
    
    /// 获取导航栏颜色
    private func getNavigationBarColors(for style: HNaviShowStyle) -> (titleColor: UIColor, backgroundColor: UIColor) {
        switch style {
        case .grey:
            return (.black, UIColor(hex: "#F8F9FE"))
        case .clearBgWhiteBackArrow:
            return (.white, .clear)
        case .clearBgBlackBackArrow:
            return (.black, .clear)
        default:
            return (.black, .white)
        }
    }
    
    /// 创建标题属性
    private func createTitleAttributes(with color: UIColor) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 1
        
        return [
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    /// 设置返回按钮
    private func setupBackButton() {
        navigationItem.leftItem.image = UIImage(named: "hvc_back_icon")
        navigationItem.leftItem.pressed = { [weak self] in
            self?.naviBack()
        }
    }
    
    /// Navigation bar status control
    override func setNeedsNavigationBarAppearanceUpdate() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationView.isHidden = prefersNavigationBarHidden
        navigationView.backgroundColor = preferredNavigationBarColor
        navigationLine.backgroundColor = preferredNavigationLineBarColor
        navigationLine.isHidden = prefersNavigationLineBarHidden
        navigationItem.leftItem.isHidden = prefersNavigationLeftItemHidden
    }
    
    // MARK: - View Setup
    
    /// 添加子视图
    func addSubviews() {
        
    }
    
    /// 绑定视图模型
    func bindViewModel() {
        viewModel.naviTitleRelay
            .subscribe(onNext: { [weak self] title in
                guard let self = self, let title = title, !title.isEmpty else { return }
                self.navigationItem.title = title
            })
            => disposeBag
    }
    
    // MARK: - Cleanup
    
    /// 销毁资源
    func destroy() {
        disposeBag = DisposeBag()
        viewModel.destroy()
    }

}
