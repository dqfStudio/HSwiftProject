//
//  HNavigationBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/2.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit
import Foundation

class HNavigationBar: UIStackView {
    
    // Spacing between left and right buttons of the navigation bar and the screen
    var edgeSpace: CGFloat = 10.0
    // Spacing between left button and middle title of the navigation bar
    var titleSpace: CGFloat = 5.0


    // Width of the left button of the navigation bar
    var leftItemWidth: CGFloat = 70.0
    // Width of the right button of the navigation bar
    var rightItemWidth: CGFloat = 70.0


    // Left button of the navigation bar
    lazy var leftItem: HNavigationItem = {
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .medium)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .left
        buttonView.backgroundColor = UIColor.clear
        buttonView.hiddenBlock = {
            self.setup()
        }
        buttonView.addTarget(self, action: #selector(leftItemPressed))
        return buttonView
    }()
    
    @objc
    func leftItemPressed() {
        leftItem.pressedBlock?()
    }

    
    // Middle title of the navigation bar
    lazy var titleItem: UILabel = {
        let labelView = UILabel(frame: .zero)
        labelView.font = UIFont.font(ofSize: 16, weight: .medium)
        labelView.textColor = UIColor.black
        labelView.textAlignment = .center
        return labelView
    }()
    
    // Right button of the navigation bar
    lazy var rightItem: HNavigationItem = {
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .medium)
        buttonView.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonView.imageView?.contentMode = .scaleAspectFit
        buttonView.contentHorizontalAlignment = .right
        buttonView.backgroundColor = UIColor.clear
        buttonView.isHidden = true
        buttonView.hiddenBlock = {
            self.setup()
        }
        buttonView.addTarget(self, action: #selector(rightItemPressed))
        return buttonView
    }()
    
    @objc
    func rightItemPressed() {
        rightItem.pressedBlock?()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 状态栏
    lazy var statusBar: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: UIScreen.statusBarHeight).isActive = true
        return view
    }()
    
    // 导航栏
    private lazy var navigationBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    // 间隔线
    lazy var lineBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe5e5e5)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.isHidden = true
        return view
    }()
    
    // 左边间隔
    private lazy var leftEdge: UIView = {
        return UIView()
    }()
    
    // 右边间隔
    private lazy var rightEdge: UIView = {
        return UIView()
    }()
    
    
    private func setup() {
        
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        // 根据导航栏项的可见性和宽度调整其间距和宽度
        if !leftItem.isHidden, !rightItem.isHidden {
            
            // 添加最左边间隔
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
            let itemWidth = leftItemWidth - rightItemWidth
            if itemWidth > 0 {// 如果左侧项比右侧项宽
                
                // 添加左边按钮
                navigationBar.addArrangedSubview(leftItem)
                leftItem.widthAnchor.constraint(equalToConstant: leftItemWidth).isActive = true // 设置左侧项宽度
                navigationBar.setCustomSpacing(titleSpace, after: leftItem) // 在左侧项后添加间距
                
                // 添加中间标题
                navigationBar.addArrangedSubview(titleItem)
                navigationBar.setCustomSpacing(abs(itemWidth) + titleSpace, after: titleItem) // 在标题项后添加间距
                
                // 添加右边按钮
                navigationBar.addArrangedSubview(rightItem)
                rightItem.widthAnchor.constraint(equalToConstant: rightItemWidth).isActive = true // 设置右侧项宽度
                
            } else {// 如果右侧项比左侧项宽
                
                // 添加左边按钮
                navigationBar.addArrangedSubview(leftItem)
                leftItem.widthAnchor.constraint(equalToConstant: leftItemWidth).isActive = true // 设置左侧项宽度
                navigationBar.setCustomSpacing(abs(itemWidth) + titleSpace, after: leftItem) // 在左侧项后添加间距
                
                // 添加中间标题
                navigationBar.addArrangedSubview(titleItem)
                navigationBar.setCustomSpacing(titleSpace, after: titleItem) // 在标题项后添加间距
                
                // 添加右边按钮
                navigationBar.addArrangedSubview(rightItem)
                rightItem.widthAnchor.constraint(equalToConstant: rightItemWidth).isActive = true // 设置右侧项宽度
            }
            
            // 添加最右边间隔
            rightEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            navigationBar.addArrangedSubview(rightEdge)
            
        } else if !leftItem.isHidden {// 如果只有左侧项可见
            
            // 添加最左边间隔
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
            // 添加左边按钮
            navigationBar.addArrangedSubview(leftItem)
            leftItem.widthAnchor.constraint(equalToConstant: leftItemWidth).isActive = true // 设置左侧项宽度
            navigationBar.setCustomSpacing(titleSpace, after: leftItem) // 在左侧项后添加间距
            
            // 添加中间标题
            navigationBar.addArrangedSubview(titleItem)
            
            // 添加最右边间隔
            navigationBar.addArrangedSubview(rightEdge)
            rightEdge.widthAnchor.constraint(equalToConstant: leftItemWidth + titleSpace + edgeSpace).isActive = true
            
        } else if !rightItem.isHidden {// 如果只有右侧项可见
            
            // 添加最左边间隔
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: rightItemWidth + titleSpace + edgeSpace).isActive = true
            
            // 添加中间标题
            navigationBar.addArrangedSubview(titleItem)
            navigationBar.setCustomSpacing(titleSpace, after: titleItem) // 在标题项后添加间距
            
            // 添加右边按钮
            navigationBar.addArrangedSubview(rightItem)
            rightItem.widthAnchor.constraint(equalToConstant: rightItemWidth).isActive = true // 设置右侧项宽度
            
            // 添加最右边间隔
            navigationBar.addArrangedSubview(rightEdge)
            rightEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
        } else {
            
            // 添加最左边间隔
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
            // 添加中间标题
            navigationBar.addArrangedSubview(titleItem)
            
            // 添加最右边间隔
            navigationBar.addArrangedSubview(rightEdge)
            rightEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
        }
        
        // 添加状态栏
        self.addArrangedSubview(statusBar)
        // 添加导航栏
        self.addArrangedSubview(navigationBar)
        // 添加间隔线
        self.addArrangedSubview(lineBar)
        
    }
    
}

typealias HNavigationItemBlock = () -> Void

class HNavigationItem: UIButton {
    var hiddenBlock: HNavigationItemBlock?
    var pressedBlock: HNavigationItemBlock?
    override var isHidden: Bool {
        didSet {
            if isHidden != oldValue {
                hiddenBlock?()
            }
        }
    }
}
