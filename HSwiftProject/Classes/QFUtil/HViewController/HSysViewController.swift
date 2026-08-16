//
//  HSysViewController.swift
//  HSwiftProject
//
//  Created by owner on 2023/7/17.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HSysViewController<VM: DPMBaseViewModel>: HBaseController {
    
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

    // MARK: - Navigation Bar
    
    override var managesSystemNavigationBar: Bool {
        true
    }
    
    override var prefersSystemNavigationBarHidden: Bool {
        prefersNavigationBarHidden
    }
    
    override var title: String? {
        didSet {
            guard isViewLoaded else { return }
            navigationItem.title = title
        }
    }

    /// 导航栏
    var navigationBar: UINavigationBar? {
        navigationController?.navigationBar
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
        if let title = title, !title.isEmpty {
            navigationItem.title = title
        }
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // viewDidLoad 时可能尚未加入 UINavigationController，需在此补应用外观
        if let navigationBar = navigationBar {
            applyNavigationBarAppearance(navigationBar, style: navShowStyle)
        }
    }
    
    override func vcWillDisappear(_ type: HVCDisappearType) {
        super.vcWillDisappear(type)
        if type == .pop || type == .dismiss {
            destroy()
        }
    }
    
    // MARK: - Navigation Bar
    
    /// Navigation bar status control
    override func setNeedsNavigationBarAppearanceUpdate() {
        navigationController?.setNavigationBarHidden(prefersNavigationBarHidden, animated: false)
        if let navigationBar = navigationBar {
            applyNavigationBarAppearance(navigationBar, style: navShowStyle)
        }
        configureBackItem(navigationItem.leftItem, style: navShowStyle)
        navigationItem.leftItem.isHidden = prefersNavigationLeftItemHidden
    }
    
    // MARK: - View Setup
    
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
