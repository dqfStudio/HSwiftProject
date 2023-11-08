//
//  HToolbar.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/14.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

typealias HToolbarBlock = (_ index: Int) -> Void

// A custom UIStackView that displays a horizontal list of items with a selected item indicator
class HToolbar: UIStackView, HTupleViewDelegate {
    
    // A lazy-loaded HTupleView instance
    private lazy var tupleView: HTupleView = {
        let tupleView = HTupleView(frame: .zero, scrollDirection: .horizontal)
        tupleView.isScrollEnabled = false
        tupleView.tupleStatus = .block
        return tupleView
    }()
    
    // The index of the currently selected item
    var selectedIndex: Int = 0
    
    // Define a variable to hold the selected block in the toolbar
    var selectedBlock: HToolbarBlock?
    
    // An array of strings representing the items to be displayed
    var items: [String]?
    
    // The font and color of the unselected item titles
    var titleFont: UIFont?
    var titleColor: UIColor?
    var titleBGColor: UIColor?
    
    // The font and color of the selected item title
    var titleSelectedFont: UIFont?
    var titleSelectedColor: UIColor?
    var titleSelectedBGColor: UIColor?
    
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
    
    // Returns the number of items in the section
    func numberOfItemsInSection(_ section: Any) -> Any {
        return items?.count ?? 0
    }

    // Configures the tuple item at the specified index path
    func tupleItem(_ itemBlock: Any, atIndexPath indexPath: IndexPath) {
        let itemBlock = itemBlock as! HTupleItem
        let cell = itemBlock(HTupleLabelCell.self, nil, true) as! HTupleLabelCell
        cell.sizeBlock = {
            return CGSize(width: self.width / CGFloat((self.items?.count ?? 1)), height: self.height)
        }
        cell.cellBlock = {
            let item = self.items?[indexPath.row]
            cell.label.textAlignment = .center
            cell.label.text = item
            
            // Set the font and color of the title based on whether it is selected or not
            if self.selectedIndex == indexPath.row {
                cell.label.font = self.titleSelectedFont
                cell.label.textColor = self.titleSelectedColor
                cell.label.backgroundColor = self.titleSelectedBGColor
            } else {
                cell.label.font = self.titleFont
                cell.label.textColor = self.titleColor
                cell.label.backgroundColor = self.titleBGColor
            }
        }
        cell.selectBlock = {
            self.selectedIndex = indexPath.row
            self.selectedBlock?(indexPath.row)
            self.tupleView.reloadTupleData()
        }

    }
    
}

