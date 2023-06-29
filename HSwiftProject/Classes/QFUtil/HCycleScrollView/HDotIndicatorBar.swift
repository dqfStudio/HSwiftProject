//
//  HBannerDotView.swift
//  HSwiftProject
//
//  Created by owner on 2023/6/29.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HDotIndicatorBarBlock = (_ index: Int) -> Void

// A custom UIStackView that displays a horizontal list of items with a selected item indicator
class HDotIndicatorBar: UIStackView, HTupleViewDelegate {
    
    // A lazy-loaded HTupleView instance
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero, scrollDirection: .horizontal)
        tupleView.isScrollEnabled = false
        tupleView.tupleStatus = .block
        return tupleView
    }()
    
    // The index of the currently selected item
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                self.selectedBlock?(selectedIndex)
                self.tupleView.reloadTupleData()
            }
        }
    }
    
    // Define a variable to hold the selected block in the toolbar
    var selectedBlock: HDotIndicatorBarBlock?
    
    // An array of strings representing the items to be displayed
    var items: Int = 0
    var itemSpace: CGFloat = 0.0
    
    var itemColor: UIColor = .green
    var itemSelectedColor: UIColor = .yellow
    var itemSelectedWidth: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Set the stack view properties
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .fill
        
        // Set the delegate of the tuple view to self and add it as a subview
        self.tupleView.delegate = self
        self.addArrangedSubview(tupleView)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTupleView() -> Any {
        return items > 1 ? items: 1
    }
    
    // Returns the number of items in the section
    func numberOfItemsInSection(_ section: Any) -> Any {
        return items > 1 ? 1: 0
    }
    
    func minimumFooterSpacingForSectionAt(_ section: Any) -> Any {
        return itemSpace
    }

    // Configures the tuple item at the specified index path
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(nil, HTupleBaseCell.self, nil, true) as! HTupleBaseCell
        cell.sizeBlock = {
            if self.selectedIndex == indexPath.section {
                return CGSize(width: self.itemSelectedWidth, height: self.height)
            } else {
                return CGSize(width: self.height, height: self.height)
            }
        }
        cell.cellBlock = {
            cell.cornerRadius = self.height / 2
            // Set the color of the title based on whether it is selected or not
            if self.selectedIndex == indexPath.section {
                cell.backgroundColor = self.itemSelectedColor
            } else {
                cell.backgroundColor = self.itemColor
            }
        }
        cell.selectBlock = {
            self.selectedIndex = indexPath.section
        }

    }
    
}

