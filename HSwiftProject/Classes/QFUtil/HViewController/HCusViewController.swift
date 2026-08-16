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
    
    /// 导航栏的样式。默认值不会触发 didSet，真正应用发生在 viewDidLoad。
    var navShowStyle: HNaviShowStyle = .normal {
        didSet {
            guard isViewLoaded, oldValue != navShowStyle else { return }
            setNeedsNavigationBarAppearanceUpdate()
        }
    }
    
    override var managesSystemNavigationBar: Bool {
        true
    }
    
    override var prefersSystemNavigationBarHidden: Bool {
        true
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
    
    override var title: String? {
        didSet {
            guard isViewLoaded else { return }
            navigationItem.title = title
        }
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
        setupNavigationLayout()
        if let title = title, !title.isEmpty {
            navigationItem.title = title
        }
        addSubviews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 系统导航栏也会占用 navigationItem；隐藏系统栏后把 item 抢回自定义栏
        if navigationBar.topItem !== navigationItem {
            navigationBar.setItems([navigationItem], animated: false)
        }
        view.bringSubviewToFront(navigationView)
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        super.vcWillDisappear(type)
        if type == .pop || type == .dismiss {
            destroy()
        }
    }
    
    // MARK: - Navigation Bar
    
    /// 设置导航栏布局
    private func setupNavigationLayout() {
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.naviBarHeight)
        }
    }
    
    /// Navigation bar status control
    override func setNeedsNavigationBarAppearanceUpdate() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationView.isHidden = prefersNavigationBarHidden
        let colors = applyNavigationBarAppearance(navigationBar, style: navShowStyle)
        navigationView.backgroundColor = colors.backgroundColor
        navigationLine.backgroundColor = preferredNavigationLineBarColor
        navigationLine.isHidden = prefersNavigationLineBarHidden
        configureBackItem(navigationItem.leftItem, style: navShowStyle)
        navigationItem.leftItem.isHidden = prefersNavigationLeftItemHidden
    }
    
    // MARK: - View Setup
    
    /// 添加子视图
    func addSubviews() {
        
    }
    
    /// 绑定视图模型
    func bindViewModel() {
        viewModel.naviTitleRelay
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] title in
                self?.title = title
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
