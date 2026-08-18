//
//  HFlowFreeCell.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

/// 自由组合：访问哪个控件就创建哪个，调用方自己设 frame。
class HFlowFreeCell: HFlowBaseCell {

    private var _label: UILabel?
    var label: UILabel { makeLabel(&_label) }
    private var _detailLabel: UILabel?
    var detailLabel: UILabel { makeLabel(&_detailLabel) }
    private var _accessoryLabel: UILabel?
    var accessoryLabel: UILabel { makeLabel(&_accessoryLabel) }

    private var _textView: HTextView?
    var textView: HTextView { makeTextView(&_textView) }
    private var _detailText: HTextView?
    var detailText: HTextView { makeTextView(&_detailText) }
    private var _accessoryText: HTextView?
    var accessoryText: HTextView { makeTextView(&_accessoryText) }

    private var _buttonView: HImageTextView?
    var buttonView: HImageTextView { makeImageText(&_buttonView) }
    private var _detailButton: HImageTextView?
    var detailButton: HImageTextView { makeImageText(&_detailButton) }
    private var _accessoryButton: HImageTextView?
    var accessoryButton: HImageTextView { makeImageText(&_accessoryButton) }

    private var _contentImageView: HImageTextView?
    /// 对应 HCollFreeCell.imageView。避开 UITableViewCell.imageView。
    var contentImageView: HImageTextView { makeImageText(&_contentImageView) }
    private var _detailImageView: HImageTextView?
    var detailImageView: HImageTextView { makeImageText(&_detailImageView) }
    private var _accessoryImageView: HImageTextView?
    var accessoryImageView: HImageTextView { makeImageText(&_accessoryImageView) }

    private var _textField: HTextFieldView?
    var textField: HTextFieldView { makeField(&_textField) }
    private var _detailField: HTextFieldView?
    var detailField: HTextFieldView { makeField(&_detailField) }
    private var _accessoryField: HTextFieldView?
    var accessoryField: HTextFieldView { makeField(&_accessoryField) }

    override func prepareForReuse() {
        super.prepareForReuse()
        [_label, _detailLabel, _accessoryLabel].forEach {
            HCollResetLabel($0)
            $0?.isHidden = true
        }
        [_textView, _detailText, _accessoryText].forEach {
            HCollResetTextView($0)
            $0?.isHidden = true
        }
        [_textField, _detailField, _accessoryField].forEach {
            HCollResetTextField($0)
            $0?.isHidden = true
        }
        [_buttonView, _detailButton, _accessoryButton].forEach {
            $0?.resetForReuse()
            $0?.isHidden = true
        }
        [_contentImageView, _detailImageView, _accessoryImageView].forEach {
            $0?.resetForReuse()
            $0?.isHidden = true
        }
    }

    private func makeLabel(_ storage: inout UILabel?) -> UILabel {
        if let label = storage {
            label.isHidden = false
            return label
        }
        let label = HCollMakeLabel()
        contentView.addSubview(label)
        storage = label
        return label
    }

    private func makeTextView(_ storage: inout HTextView?) -> HTextView {
        if let textView = storage {
            textView.isHidden = false
            return textView
        }
        let textView = HTextView()
        textView.font = .systemFont(ofSize: 14)
        contentView.addSubview(textView)
        storage = textView
        return textView
    }

    private func makeImageText(_ storage: inout HImageTextView?) -> HImageTextView {
        if let view = storage {
            view.isHidden = false
            return view
        }
        let view = HImageTextView()
        contentView.addSubview(view)
        storage = view
        return view
    }

    private func makeField(_ storage: inout HTextFieldView?) -> HTextFieldView {
        if let field = storage {
            field.isHidden = false
            return field
        }
        let field = HTextFieldView()
        contentView.addSubview(field)
        storage = field
        return field
    }
}
