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
    
    /// 导航栏的样式
    var navShowStyle: HNaviShowStyle = .normal {
        didSet {
            updateNavigationBarAppearance()
            setupBackButton()
        }
    }

    // MARK: - Navigation Bar
    
    override var title: String? {
        didSet {
            guard isViewLoaded else { return }
            navigationItem.titleItem.text = title
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
    
    // MARK: - Navigation Bar
    
    /// 更新导航栏外观
    private func updateNavigationBarAppearance() {
        guard let navigationBar = navigationBar else { return }
        
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
        navigationBar?.isHidden = prefersNavigationBarHidden
        navigationBar?.backgroundColor = preferredNavigationBarColor
        navigationItem.leftItem.isHidden = prefersNavigationLeftItemHidden
    }
    
    // MARK: - Cleanup
    
    /// 销毁资源
    func destroy() {
        disposeBag = DisposeBag()
        viewModel.destroy()
    }
    
}
