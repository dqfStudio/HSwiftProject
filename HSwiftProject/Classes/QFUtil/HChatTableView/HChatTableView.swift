//
//  HChatTableView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/12.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

/// Table header & Footer & Item block
typealias HChatTableHeader = (_ cls: AnyClass) -> AnyObject
typealias HChatTableFooter = (_ cls: AnyClass) -> AnyObject
typealias HChatTableRow = (_ cls: AnyClass) -> AnyObject

@objc protocol HChatTableViewDelegate : UITableViewDelegate {
    @objc
    optional func numberOfSectionsInTableView() -> Any
    @objc
    optional func numberOfRowsInSection(_ section: Any) -> Any

    @objc
    optional func heightForHeaderInSection(_ section: Any) -> Any
    @objc
    optional func heightForFooterInSection(_ section: Any) -> Any
    @objc
    optional func heightForRowAtIndexPath(_ indexPath: IndexPath) -> Any

    @objc
    optional func tableHeader(_ headerBlock: Any, inSection section: Any)
    @objc
    optional func tableFooter(_ footerBlock: Any, inSection section: Any)
    @objc
    optional func tableRow(_ itemBlock: Any, atIndexPath indexPath: IndexPath)

    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectRowAtIndexPath(_ indexPath: IndexPath)
}

class HChatTableView : UITableView, UITableViewDelegate, UITableViewDataSource {

     private var allReuseIdentifiers: NSMutableSet = NSMutableSet()
     private var allReuseCells   = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
     private var allReuseHeaders = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
     private var allReuseFooters = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setup()
    }
    
    private weak var tableDelegate: HChatTableViewDelegate?
    override weak var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set { tableDelegate = newValue as? HChatTableViewDelegate }
    }
    override weak var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set { _ = newValue }
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            let frame = UIRectIntegral(newValue)
            if frame != super.frame {
                super.frame = frame
                self.reloadData()
            }
        }
    }
    
    private func setup() {
        
        self.alwaysBounceVertical = true
        self.backgroundColor = UIColor.clear
        self.keyboardDismissMode = .onDrag
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        
        self.estimatedRowHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        
        self.tableFooterView = UIView()
        super.delegate = self
        super.dataSource = self
    }
    
    
    // Hide the system UITableViewCell's separator style
    override var separatorStyle: UITableViewCell.SeparatorStyle {
        get { return super.separatorStyle }
        set { super.separatorStyle = newValue }
    }
    
    @objc
    func reloadTableData() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }

    /// Release method
    @objc
    func releaseTableBlock() {
        DispatchQueue.global().async {
            self.tableDelegate = nil
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Register class
    func dequeueReusableHeaderWithClass(_ cls: AnyClass, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        // Unique identifier
        let identifier = "HeaderCell" + NSStringFromClass(cls) + self.addressValue + "\(section)"
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
            // Save cell
            self.allReuseHeaders.setObject(cell, forKey: "\(section)" as NSString)
        }else {
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
        }
        return cell
    }
    
    func dequeueReusableFooterWithClass(_ cls: AnyClass, section: Int) -> AnyObject {
        var cell: HTableBaseApex
        // Unique identifier
        let identifier = "FooterCell" + NSStringFromClass(cls) + self.addressValue + "\(section)"
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forHeaderFooterViewReuseIdentifier: identifier)
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
            // Save cell
            self.allReuseFooters.setObject(cell, forKey: "\(section)" as NSString)
        }else {
            cell = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! HTableBaseApex
        }
        return cell
    }

    func dequeueReusableCellWithClass(_ cls: AnyClass, idxPath: IndexPath) -> AnyObject {
        var cell: HTableBaseCell
        // Unique identifier
        let identifier = "ItemCell" + NSStringFromClass(cls) + self.addressValue + idxPath.stringValue
        // Determine whether it has been loaded
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellReuseIdentifier: identifier)
            cell = self.dequeueReusableCell(withIdentifier: identifier, for: idxPath) as! HTableBaseCell
            // Save cell
            self.allReuseCells.setObject(cell, forKey: idxPath.nsStringValue)
        }else {
            cell = self.dequeueReusableCell(withIdentifier: identifier, for: idxPath) as! HTableBaseCell
        }
        return cell
    }
    
    /// The following are the delegate methods for UITableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 1
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.numberOfSectionsInTableView)
            if delegate.responds(to: selector) {
                sections = delegate.performWithUnretainedValue(selector) as! Int
            }
            // Prevents quantity from being less than 1
            sections = max(sections, 1)
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var items = 0
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.numberOfRowsInSection(_:))
            if delegate.responds(to: selector) {
                items = delegate.performWithUnretainedValue(selector, with: section) as! Int
            }
            // Prevent negative size
            items = max(items, 0)
        }
        return items
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.heightForHeaderInSection(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.heightForFooterInSection(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: section) as! CGFloat
            }
            // Prevent negative size
            height = max(height, 0.0)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 1.0 // The row height cannot be 0, otherwise it will crash.
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.heightForRowAtIndexPath(_:))
            if delegate.responds(to: selector) {
                height = delegate.performWithUnretainedValue(selector, with: indexPath) as! CGFloat
            }
            // Prevent negative size
            if height <= 0 { height = 1.0 }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Call delegate method
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.tableRow(_:atIndexPath:))
            let itemBlock = { (_ cls: AnyClass) in
                return self.dequeueReusableCellWithClass(cls, idxPath: indexPath)
            }
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: itemBlock, with: indexPath)
            }
        }
        // Call cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? UITableViewCell
        // Prevent crashes
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.tableHeader(_:inSection:))
            let headerBlock = { (_ cls: AnyClass) -> AnyObject in
                return self.dequeueReusableHeaderWithClass(cls, section: section)
            }
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: headerBlock, with: section)
            }
        }
        // Update layout
        let cell = self.allReuseHeaders.object(forKey: "\(section)" as NSString) as? UITableViewHeaderFooterView
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Call delegate method
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.tableFooter(_:inSection:))
            let footerBlock = { (_ cls: AnyClass) -> AnyObject in
                return self.dequeueReusableFooterWithClass(cls, section: section)
            }
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: footerBlock, with: section)
            }
        }
        // Update layout
        let cell = self.allReuseFooters.object(forKey: "\(section)" as NSString) as? UITableViewHeaderFooterView
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        let selector = #selector(delegate.willDisplayCell(_:atIndexPath:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: cell, with: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        let selector = #selector(delegate.didSelectRowAtIndexPath(_:))
        if delegate.responds(to: selector) {
            delegate.perform(selector, with: indexPath)
        }
    }
    
}
