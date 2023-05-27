//
//  HNavigationBar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/2.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

class HNavigationBar: UIStackView {
    
    // Spacing between left and right buttons of the navigation bar and the screen
    var edgeSpace: CGFloat = 16.0
    // Spacing between left button and middle title of the navigation bar
    var titleSpace: CGFloat = 5.0


    // Width of the left button of the navigation bar
    var leftItemWidth: CGFloat = 60.0
    // Width of the right button of the navigation bar
    var rightItemWidth: CGFloat = 60.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Status bar
    lazy var statusBar: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: UIScreen.statusBarHeight).isActive = true
        return view
    }()
    
    // Navigation bar
    private lazy var navigationBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    // Separator line
    lazy var lineBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe5e5e5)
        view.heightAnchor.constraint(equalToConstant: UIScreen.onePixel).isActive = true
        view.isHidden = true
        return view
    }()
    
    // Left edge
    private lazy var leftEdge: UIView = {
        return UIView()
    }()
    
    // Right edge
    private lazy var rightEdge: UIView = {
        return UIView()
    }()
    
    // Left button of the navigation bar
    lazy var leftItem: HNavigationItem = {
        let buttonView = HNavigationItem(frame: .zero)
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
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
    private func leftItemPressed() {
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
        buttonView.titleLabel?.font = UIFont.font(ofSize: 16, weight: .regular)
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
    private func rightItemPressed() {
        rightItem.pressedBlock?()
    }
    
    private func setup() {
        
        self.backgroundColor = .white
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        
        // Adjust the spacing and width of navigation bar items based on the visibility and width of navigation bar items.
        if !leftItem.isHidden, !rightItem.isHidden {
            
            // Add the leftmost spacing
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
            let itemWidth = leftItemWidth - rightItemWidth
            if itemWidth > 0 {// If the left item is wider than the right item
                
                // Add the left button
                navigationBar.addArrangedSubview(leftItem)
                leftItem.widthAnchor.constraint(equalToConstant: leftItemWidth).isActive = true // Set the width of the left item
                navigationBar.setCustomSpacing(titleSpace, after: leftItem) // Add spacing after the left item
                
                // Add the middle title
                navigationBar.addArrangedSubview(titleItem)
                navigationBar.setCustomSpacing(abs(itemWidth) + titleSpace, after: titleItem) // Add spacing after the title item
                
                // Add the right button
                navigationBar.addArrangedSubview(rightItem)
                rightItem.widthAnchor.constraint(equalToConstant: rightItemWidth).isActive = true // Set the width of the right item
                
            } else {// If the right item is wider than the left item
                
                // Add the left button
                navigationBar.addArrangedSubview(leftItem)
                leftItem.widthAnchor.constraint(equalToConstant: leftItemWidth).isActive = true // Set the width of the left item
                navigationBar.setCustomSpacing(abs(itemWidth) + titleSpace, after: leftItem) // Add spacing after the left item
                
                // Add the middle title
                navigationBar.addArrangedSubview(titleItem)
                navigationBar.setCustomSpacing(titleSpace, after: titleItem) // Add spacing after the title item
                
                // Add the right button
                navigationBar.addArrangedSubview(rightItem)
                rightItem.widthAnchor.constraint(equalToConstant: rightItemWidth).isActive = true // Set the width of the right item
            }
            
            // Add the rightmost spacing
            rightEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            navigationBar.addArrangedSubview(rightEdge)
            
        } else if !leftItem.isHidden {// If only the left item is visible
            
            // Add the leftmost spacing
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
            // Add the left button
            navigationBar.addArrangedSubview(leftItem)
            leftItem.widthAnchor.constraint(equalToConstant: leftItemWidth).isActive = true // Set the width of the left item
            navigationBar.setCustomSpacing(titleSpace, after: leftItem) // Add spacing after the left item
            
            // Add the middle title
            navigationBar.addArrangedSubview(titleItem)
            
            // Add the rightmost spacing
            navigationBar.addArrangedSubview(rightEdge)
            rightEdge.widthAnchor.constraint(equalToConstant: leftItemWidth + titleSpace + edgeSpace).isActive = true
            
        } else if !rightItem.isHidden {// If only the right item is visible
            
            // Add the leftmost spacing
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: rightItemWidth + titleSpace + edgeSpace).isActive = true
            
            // Add the middle title
            navigationBar.addArrangedSubview(titleItem)
            navigationBar.setCustomSpacing(titleSpace, after: titleItem) // Add spacing after the title item
            
            // Add the right button
            navigationBar.addArrangedSubview(rightItem)
            rightItem.widthAnchor.constraint(equalToConstant: rightItemWidth).isActive = true // Set the width of the right item
            
            // Add the rightmost spacing
            navigationBar.addArrangedSubview(rightEdge)
            rightEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
        } else {
            
            // Add the leftmost spacing
            navigationBar.addArrangedSubview(leftEdge)
            leftEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
            
            // Add the middle title
            navigationBar.addArrangedSubview(titleItem)
            
            // Add the rightmost spacing
            navigationBar.addArrangedSubview(rightEdge)
            rightEdge.widthAnchor.constraint(equalToConstant: edgeSpace).isActive = true
        }
        
        // Add the status bar
        self.addArrangedSubview(statusBar)
        // Add the navigation bar
        self.addArrangedSubview(navigationBar)
        // Add the spacing line
        self.addArrangedSubview(lineBar)
        
    }
    
}


// This is a custom UIButton class that is used as a navigation item
// It has two blocks that can be set to be executed when the button is pressed or hidden
// It also has a disableColor property that can be set to change the background color when the button is disabled

typealias HNavigationItemBlock = () -> Void

// This is a custom UIButton class that is used as a navigation item
class HNavigationItem: UIButton {
    // It has two blocks that can be set to be executed when the button is pressed or hidden
    var hiddenBlock: HNavigationItemBlock?
    var pressedBlock: HNavigationItemBlock?

    // It also has a disableColor property that can be set to change the background color when the button is disabled
    var disableColor: UIColor?
    
    var title: String? {
        get { return self.title(for: .normal) }
        set {
            self.setTitle(newValue, for: .normal)
            self.setTitle(newValue, for: .highlighted)
        }
    }
    
    override var image: UIImage? {
        get { return self.image(for: .normal) }
        set {
            self.setImage(newValue, for: .normal)
            self.setImage(newValue, for: .highlighted)
        }
    }
    
    // If the button is disabled, change the background color to the disableColor property
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? backgroundColor : disableColor ?? backgroundColor
            isUserInteractionEnabled = isEnabled
        }
    }

    // If the button is hidden, execute the hiddenBlock
    override var isHidden: Bool {
        didSet {
            if isHidden != oldValue {
                hiddenBlock?()
            }
        }
    }
}


