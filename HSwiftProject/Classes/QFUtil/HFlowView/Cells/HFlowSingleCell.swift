//
//  HFlowSingleCell.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/21.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// 系统 `.value1` 样式薄封装。
class HFlowCellValue1: HFlowBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// 系统 `.value2` 样式薄封装。
class HFlowCellValue2: HFlowBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// 系统 `.subtitle` 样式薄封装。
class HFlowCellSubtitle: HFlowBaseCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// 单 Label，铺满内容区；访问 `label` 时才创建。
class HFlowLabelCell: HFlowBaseCell {
    private var _label: UILabel?
    var label: UILabel {
        if let label = _label { return label }
        let label = HCollMakeLabel()
        contentView.addSubview(label)
        _label = label
        setNeedsLayout()
        return label
    }

    override func relayoutSubviews() {
        if let label = _label {
            fillContent(label)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetLabel(_label)
    }
}

/// 单 HTextView，铺满内容区。
class HFlowTextViewCell: HFlowBaseCell {
    private var _textView: HTextView?
    var textView: HTextView {
        if let textView = _textView { return textView }
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14)
        contentView.addSubview(textView)
        _textView = textView
        setNeedsLayout()
        return textView
    }

    override func relayoutSubviews() {
        if let textView = _textView {
            fillContent(textView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetTextView(_textView)
    }
}

/// 单 HImageTextView 按钮区，铺满内容区。
class HFlowButtonCell: HFlowBaseCell {
    private var _buttonView: HImageTextView?
    var buttonView: HImageTextView {
        if let buttonView = _buttonView { return buttonView }
        let buttonView = HImageTextView()
        contentView.addSubview(buttonView)
        _buttonView = buttonView
        setNeedsLayout()
        return buttonView
    }

    override func relayoutSubviews() {
        if let buttonView = _buttonView {
            fillContent(buttonView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _buttonView?.resetForReuse()
    }
}

/// 单图 cell。用 `webImageView` 避开 UITableViewCell.imageView。
class HFlowImageCell: HFlowBaseCell {
    private var _webImageView: HImageTextView?
    var webImageView: HImageTextView {
        if let imageView = _webImageView { return imageView }
        let imageView = HImageTextView()
        contentView.addSubview(imageView)
        _webImageView = imageView
        setNeedsLayout()
        return imageView
    }

    override func relayoutSubviews() {
        if let imageView = _webImageView {
            fillContent(imageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _webImageView?.resetForReuse()
    }
}

/// 单 HTextFieldView，铺满内容区。
class HFlowTextFieldCell: HFlowBaseCell {
    private var _textField: HTextFieldView?
    var textField: HTextFieldView {
        if let textField = _textField { return textField }
        let textField = HTextFieldView()
        contentView.addSubview(textField)
        _textField = textField
        setNeedsLayout()
        return textField
    }

    override func relayoutSubviews() {
        if let textField = _textField {
            fillContent(textField)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        HCollResetTextField(_textField)
    }
}
