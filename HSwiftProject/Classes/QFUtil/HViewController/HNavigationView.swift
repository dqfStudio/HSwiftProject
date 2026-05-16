//
//  HNavigationView.swift
//  HSwiftProject
//
//  Created by ower on 2025/4/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

// MARK: - HNavigationView

/// 自定义导航栏视图
class HNavigationView: UIView {
    
    // MARK: - Properties
    
    /// 导航项
    lazy var navigationItem: UINavigationItem = {
        UINavigationItem()
    }()
    
    /// 导航栏
    lazy var navigationBar: UINavigationBar = {
        let naviBar = UINavigationBar(frame: .zero)
        naviBar.pushItem(navigationItem, animated: false)
        naviBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        naviBar.shadowImage = UIImage()
        naviBar.isTranslucent = false
        naviBar.barTintColor = .white
        naviBar.barStyle = .default
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 1
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        naviBar.titleTextAttributes = attributes
        return naviBar
    }()
    
    /// 导航栏分割线
    lazy var navigationLine: UIView = {
        let naviLine = UIView(frame: .zero)
        naviLine.isHidden = true
        return naviLine
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not available")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        addSubview(navigationBar)
        addSubview(navigationLine)
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.naviBarHeight)
        }
        
        navigationLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        super.updateConstraints()
    }
}
