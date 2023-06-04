//
//  HTableViewCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HTableCellValue1 : HTableBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func initUI() {
        self.selectionStyle = .none
    }
}

class HTableCellValue2 : HTableBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func initUI() {
        self.selectionStyle = .none
    }
}

class HTableCellSubtitle : HTableBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func initUI() {
        self.selectionStyle = .none
    }
}

class HTableLabelCell : HTableBaseCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.label)
    }
}

class HTableTextCell : HTableBaseCell {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(textView)
        return textView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.textView)
    }
}

class HTableButtonCell : HTableBaseCell {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.buttonView)
    }
}

class HTableImageCell : HTableBaseCell {
    private var _imageView: HWebImageView?
    override var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
            self.layoutView.addSubview(_imageView!)
        }
        return _imageView!
    }
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.imageView)
    }
}

class HTableTextFieldCell : HTableBaseCell {
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTableCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.textField)
    }
}

class HTableViewCell : HTableBaseCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func initUI() {
        self.selectionStyle = .none
    }
    
    ///label
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var accessoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(label)
        return label
    }()

    
    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var detailTextView: HTextView = {
        let detailTextView = HTextView()
        detailTextView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(detailTextView)
        return detailTextView
    }()
    lazy var accessoryTextView: HTextView = {
        let accessoryTextView = HTextView()
        accessoryTextView.font = UIFont.systemFont(ofSize: 14)
        self.layoutView.addSubview(accessoryTextView)
        return accessoryTextView
    }()

    
    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var detailButtonView: HWebButtonView = {
        let detailButtonView = HWebButtonView()
        self.layoutView.addSubview(detailButtonView)
        return detailButtonView
    }()
    lazy var accessoryButtonView: HWebButtonView = {
        let accessoryButtonView = HWebButtonView()
        self.layoutView.addSubview(accessoryButtonView)
        return accessoryButtonView
    }()

    
    ///imageView
    private var _imageView: HWebImageView?
    override var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
            self.layoutView.addSubview(_imageView!)
        }
        return _imageView!
    }
    lazy var detailImageView: HWebImageView = {
        let detailImageView = HWebImageView()
        self.layoutView.addSubview(detailImageView)
        return detailImageView
    }()
    lazy var accessoryImageView: HWebImageView = {
        let accessoryImageView = HWebImageView()
        self.layoutView.addSubview(accessoryImageView)
        return accessoryImageView
    }()

    
    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTableCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var detailTextField: HTextField = {
        let detailTextField = HTextField()
        HLayoutTableCell(detailTextField)
        self.layoutView.addSubview(detailTextField)
        return detailTextField
    }()
    lazy var accessoryTextField: HTextField = {
        let accessoryTextField = HTextField()
        HLayoutTableCell(accessoryTextField)
        self.layoutView.addSubview(accessoryTextField)
        return accessoryTextField
    }()

}
