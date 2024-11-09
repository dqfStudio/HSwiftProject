//
//  HFlowViewCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/12/4.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

class HFlowCellValue1: HFlowBaseCell {
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

class HFlowCellValue2: HFlowBaseCell {
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

class HFlowCellSubtitle: HFlowBaseCell {
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

class HFlowLabelCell: HFlowBaseCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.label)
    }
}

class HFlowTextCell: HFlowBaseCell {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.textView)
    }
}

class HFlowButtonCell: HFlowBaseCell {
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    
    override func relayoutSubviews() {
        HLayoutTableCell(self.buttonView)
    }
}

class HFlowImageCell: HFlowBaseCell {
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

class HFlowFieldCell: HFlowBaseCell {
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

class HFlowViewCell: HFlowBaseCell {
    
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
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()
    lazy var accsryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(label)
        return label
    }()

    
    ///textView
    lazy var textView: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var detailText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()
    lazy var accsryText: HTextView = {
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14.0)
        self.layoutView.addSubview(textView)
        return textView
    }()

    
    ///button
    lazy var buttonView: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var detailButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
    }()
    lazy var accsryButton: HWebButtonView = {
        let buttonView = HWebButtonView()
        self.layoutView.addSubview(buttonView)
        return buttonView
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
    lazy var detailView: HWebImageView = {
        let _imageView = HWebImageView()
        self.layoutView.addSubview(_imageView)
        return _imageView
    }()
    lazy var accsryView: HWebImageView = {
        let _imageView = HWebImageView()
        self.layoutView.addSubview(_imageView)
        return _imageView
    }()

    
    ///textField
    lazy var textField: HTextField = {
        let textField = HTextField()
        HLayoutTableCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var detailField: HTextField = {
        let textField = HTextField()
        HLayoutTableCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()
    lazy var accsryField: HTextField = {
        let textField = HTextField()
        HLayoutTableCell(textField)
        self.layoutView.addSubview(textField)
        return textField
    }()

}
