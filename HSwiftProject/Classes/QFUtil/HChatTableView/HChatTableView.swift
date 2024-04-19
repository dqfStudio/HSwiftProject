//
//  HChatTableView.swift
//  HSwiftProject
//
//  Created by owner on 2023/5/12.
//  Copyright © 2023 wind. All rights reserved.
//

import UIKit

/// Table header & Footer & Item block
typealias HChatTableRow = (_ cls: AnyClass, _ idx: Bool) -> AnyObject

@objc protocol HChatTableViewDelegate: UITableViewDelegate {
    @objc
    optional func numberOfSectionsInTableView() -> Any
    @objc
    optional func numberOfRowsInSection(_ section: Any) -> Any

    @objc
    optional func tableRow(_ table: HChatTableView, atIndexPath indexPath: IndexPath)
    @objc
    optional func willDisplayCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath)
    @objc
    optional func didSelectRowAtIndexPath(_ indexPath: IndexPath)
}

class HChatTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    private var allReuseIdentifiers = NSMutableSet()
    private var allReuseCells = NSMapTable<NSString, AnyObject>.strongToWeakObjects()
    private var allCellHeightTable = NSMapTable<NSString, AnyObject>.strongToStrongObjects()
    
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
        
        self.backgroundColor = .clear
        self.alwaysBounceVertical = true
        self.keyboardDismissMode = .onDrag
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false

        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
        
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
        DispatchQueue.global().async { [weak self] in
            self?.tableDelegate = nil
        }
    }

    private var addressValue: String {
        return String(format: "%p", self)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func cell(_ cls: AnyClass, _ idx: Bool, _ indexPath: IndexPath) -> AnyObject {
        // Unique identifier
        var identifier = "ItemCell" + NSStringFromClass(cls) + self.addressValue
        // Determine whether it contains an index
        identifier += idx ? indexPath.stringValue : ""
        // Register cell if not already registered
        if !self.allReuseIdentifiers.contains(identifier) {
            self.allReuseIdentifiers.add(identifier)
            self.register(cls, forCellReuseIdentifier: identifier)
        }
        // Dequeue cell
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        // Save cell
        self.allReuseCells.setObject(cell, forKey: indexPath.nsStringValue)
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.allCellHeightTable.object(forKey: indexPath.nsStringValue) as? NSNumber
        if let height = height {
            return height.doubleValue
        } else {
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Call delegate method
        if let delegate = self.tableDelegate {
            let selector = #selector(delegate.tableRow(_:atIndexPath:))
            if delegate.responds(to: selector) {
                delegate.perform(selector, with: self, with: indexPath)
            }
        }
        // Call cell
        let cell = self.allReuseCells.object(forKey: indexPath.nsStringValue) as? UITableViewCell
        // Prevent crashes
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = self.tableDelegate else { return }
        // Save cell height
        let height = NSNumber(value: cell.frame.size.height)
        self.allCellHeightTable.setObject(height, forKey: indexPath.nsStringValue)
        // Call delegate method
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
