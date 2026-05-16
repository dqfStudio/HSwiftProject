//
//  HTupleViewApexHoriValue.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

///三个label横向从左向右抱紧显示
class HTupleViewApexHoriValue1: HTupleTmplApex {

    // 用于imageView布局
    private lazy var imageLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }

    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()

    ///label的宽度
    var labelWidth: CGFloat = 0.0

    ///detailLabel的宽度
    var detailWidth: CGFloat = 0.0

    ///显示文字内容
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()

    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _detailLabel!
    }

    private var _accsryLabel: UILabel?
    ///显示文字内容附加信息
    var accsryLabel: UILabel {
        if _accsryLabel == nil {
            _accsryLabel = UILabel()
            _accsryLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _accsryLabel!
    }

    // 用于detailView布局
    private lazy var detailLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
        }
        return _detailView!
    }

    // 用于arrow布局
    private lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    // arrow
    private lazy var accsryView: UIImageView = {
        let accsryView = UIImageView()
        accsryView.image = UIImage(named: "icon_tuple_arrow_right")
        accsryView.contentMode = .scaleAspectFill
        return accsryView
    }()

    ///是否显示右边箭头
    var isShowAccsryArrow: Bool = false

    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 10.0

    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0

    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0

    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0

    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 5.0

    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0

    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0

    private var didSetupLayout = false
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var labelWidthConstraint: NSLayoutConstraint?
    private var detailLabelWidthConstraint: NSLayoutConstraint?
    private var detailWidthConstraint: NSLayoutConstraint?
    private var detailHeightConstraint: NSLayoutConstraint?
    private var accsryWidthConstraint: NSLayoutConstraint?
    private var accsryHeightConstraint: NSLayoutConstraint?

    override func relayoutSubviews() {

        let frame = self.bounds.inset(by: self.edgeInsets)

        // 重设frame
        layoutView.frame = frame
        layoutView.spacing = layoutSpacing

        // imageView
        if let imageView = _imageView {

            var imageFrame = frame
            if imageView.imageSize != .zero {
                imageFrame.size = imageView.imageSize
            } else {
                imageFrame.width = frame.height
                imageFrame = imageFrame.inset(by: imageView.edgeInsets)
            }

            updateTupleApexConstraint(&imageWidthConstraint, on: imageView, attr: .width, constant: imageFrame.width)
            updateTupleApexConstraint(&imageHeightConstraint, on: imageView, attr: .height, constant: imageFrame.height)

            if !didSetupLayout {
                imageLayoutView.addArrangedSubview(imageView)
                layoutView.addArrangedSubview(imageLayoutView)
            }

            if layoutFirstSpacing > 0 {
                layoutView.setCustomSpacing(layoutFirstSpacing, after: imageLayoutView)
            }
        }

        // textLayoutView
        if !didSetupLayout {
            layoutView.addArrangedSubview(textLayoutView)
        }
        textLayoutView.spacing = textSpacing
        if layoutSecondSpacing > 0 {
            layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        }

        // label
        let actualLabelWidth = labelWidth == 0 ? label.intrinsicContentSize.width : labelWidth
        updateTupleApexConstraint(&labelWidthConstraint, on: label, attr: .width, constant: actualLabelWidth)
        if !didSetupLayout {
            textLayoutView.addArrangedSubview(label)
        }
        if firstTextSpacing > 0 {
            textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        }

        if let accsryLabel = _accsryLabel {
            let actualDetailWidth = detailWidth == 0 ? detailLabel.intrinsicContentSize.width : detailWidth
            updateTupleApexConstraint(&detailLabelWidthConstraint, on: detailLabel, attr: .width, constant: actualDetailWidth)
            if !didSetupLayout {
                textLayoutView.addArrangedSubview(detailLabel)
                textLayoutView.addArrangedSubview(accsryLabel)
            }
            if secondTextSpacing > 0 {
                textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
            }
        } else {
            if let detailLabel = _detailLabel, !didSetupLayout {
                textLayoutView.addArrangedSubview(detailLabel)
            }
        }

        // detailView
        if let detailView = _detailView {

            var detailFrame = frame
            if detailView.imageSize != .zero {
                detailFrame.size = detailView.imageSize
            } else {
                detailFrame.width = frame.height
                detailFrame = detailFrame.inset(by: detailView.edgeInsets)
            }

            updateTupleApexConstraint(&detailWidthConstraint, on: detailView, attr: .width, constant: detailFrame.width)
            updateTupleApexConstraint(&detailHeightConstraint, on: detailView, attr: .height, constant: detailFrame.height)

            if !didSetupLayout {
                detailLayoutView.addArrangedSubview(detailView)
                layoutView.addArrangedSubview(detailLayoutView)
            }

            if layoutThirdSpacing > 0 {
                layoutView.setCustomSpacing(layoutThirdSpacing, after: detailLayoutView)
            }
        }

        // accsryView
        if isShowAccsryArrow {
            if !didSetupLayout {
                layoutView.addArrangedSubview(arrowLayoutView)
                arrowLayoutView.addArrangedSubview(accsryView)
            }
            updateTupleApexConstraint(&accsryWidthConstraint, on: accsryView, attr: .width, constant: 7)
            updateTupleApexConstraint(&accsryHeightConstraint, on: accsryView, attr: .height, constant: 13)
        }

        didSetupLayout = true
    }
}

///三个label横向从右向左抱紧显示
class HTupleViewApexHoriValue2: HTupleTmplApex {

    // 用于imageView布局
    private lazy var imageLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }

    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()

    ///detailLabel的宽度
    var detailWidth: CGFloat = 0.0

    ///accsryLabel的宽度
    var accsryWidth: CGFloat = 0.0

    ///显示文字内容
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()

    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _detailLabel!
    }

    private var _accsryLabel: UILabel?
    ///显示文字内容附加信息
    var accsryLabel: UILabel {
        if _accsryLabel == nil {
            _accsryLabel = UILabel()
            _accsryLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _accsryLabel!
    }

    // 用于detailView布局
    private lazy var detailLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private var _detailView: HWebImageView?
    ///右边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
        }
        return _detailView!
    }

    // 用于arrow布局
    private lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    // arrow
    private lazy var accsryView: UIImageView = {
        let accsryView = UIImageView()
        accsryView.image = UIImage(named: "icon_tuple_arrow_right")
        accsryView.contentMode = .scaleAspectFill
        return accsryView
    }()

    ///是否显示右边箭头
    var isShowAccsryArrow: Bool = false

    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 10.0

    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0

    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0

    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0

    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 5.0

    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0

    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0

    private var didSetupLayout = false
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var detailLabelWidthConstraint: NSLayoutConstraint?
    private var accsryLabelWidthConstraint: NSLayoutConstraint?
    private var detailWidthConstraint: NSLayoutConstraint?
    private var detailHeightConstraint: NSLayoutConstraint?
    private var accsryWidthConstraint: NSLayoutConstraint?
    private var accsryHeightConstraint: NSLayoutConstraint?

    override func relayoutSubviews() {

        let frame = self.bounds.inset(by: self.edgeInsets)

        // 重设frame
        layoutView.frame = frame
        layoutView.spacing = layoutSpacing

        // imageView
        if let imageView = _imageView {

            var imageFrame = frame
            if imageView.imageSize != .zero {
                imageFrame.size = imageView.imageSize
            } else {
                imageFrame.width = frame.height
                imageFrame = imageFrame.inset(by: imageView.edgeInsets)
            }

            updateTupleApexConstraint(&imageWidthConstraint, on: imageView, attr: .width, constant: imageFrame.width)
            updateTupleApexConstraint(&imageHeightConstraint, on: imageView, attr: .height, constant: imageFrame.height)

            if !didSetupLayout {
                imageLayoutView.addArrangedSubview(imageView)
                layoutView.addArrangedSubview(imageLayoutView)
            }

            if layoutFirstSpacing > 0 {
                layoutView.setCustomSpacing(layoutFirstSpacing, after: imageLayoutView)
            }
        }

        // textLayoutView
        if !didSetupLayout {
            layoutView.addArrangedSubview(textLayoutView)
        }
        textLayoutView.spacing = textSpacing
        if layoutSecondSpacing > 0 {
            layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        }

        // label
        if !didSetupLayout {
            textLayoutView.addArrangedSubview(label)
        }
        if firstTextSpacing > 0 {
            textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        }

        if let detailLabel = _detailLabel {
            if detailWidth > 0 {
                updateTupleApexConstraint(&detailLabelWidthConstraint, on: detailLabel, attr: .width, constant: detailWidth)
            }
            if !didSetupLayout {
                textLayoutView.addArrangedSubview(detailLabel)
            }
            if secondTextSpacing > 0 {
                textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
            }
        }
        if let accsryLabel = _accsryLabel {
            if accsryWidth > 0 {
                updateTupleApexConstraint(&accsryLabelWidthConstraint, on: accsryLabel, attr: .width, constant: accsryWidth)
            }
            if !didSetupLayout {
                textLayoutView.addArrangedSubview(accsryLabel)
            }
        }

        // detailView
        if let detailView = _detailView {

            var detailFrame = frame
            if detailView.imageSize != .zero {
                detailFrame.size = detailView.imageSize
            } else {
                detailFrame.width = frame.height
                detailFrame = detailFrame.inset(by: detailView.edgeInsets)
            }

            updateTupleApexConstraint(&detailWidthConstraint, on: detailView, attr: .width, constant: detailFrame.width)
            updateTupleApexConstraint(&detailHeightConstraint, on: detailView, attr: .height, constant: detailFrame.height)

            if !didSetupLayout {
                detailLayoutView.addArrangedSubview(detailView)
                layoutView.addArrangedSubview(detailLayoutView)
            }

            if layoutThirdSpacing > 0 {
                layoutView.setCustomSpacing(layoutThirdSpacing, after: detailLayoutView)
            }
        }

        // accsryView
        if isShowAccsryArrow {
            if !didSetupLayout {
                layoutView.addArrangedSubview(arrowLayoutView)
                arrowLayoutView.addArrangedSubview(accsryView)
            }
            updateTupleApexConstraint(&accsryWidthConstraint, on: accsryView, attr: .width, constant: 7)
            updateTupleApexConstraint(&accsryHeightConstraint, on: accsryView, attr: .height, constant: 13)
        }

        didSetupLayout = true
    }
}

///三个label纵向显示
class HTupleViewApexHoriValue3: HTupleTmplApex {

    // 用于imageView布局
    private lazy var imageLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private var _imageView: HWebImageView?
    ///左边显示图片
    var imageView: HWebImageView {
        if _imageView == nil {
            _imageView = HWebImageView()
        }
        return _imageView!
    }

    // 用于text布局
    lazy var textLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    ///显示文字内容
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()

    private var _detailLabel: UILabel?
    ///显示文字内容详情
    var detailLabel: UILabel {
        if _detailLabel == nil {
            _detailLabel = UILabel()
            _detailLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _detailLabel!
    }

    private var _accsryLabel: UILabel?
    ///显示文字内容附加信息
    var accsryLabel: UILabel {
        if _accsryLabel == nil {
            _accsryLabel = UILabel()
            _accsryLabel!.font = .systemFont(ofSize: 14.0)
        }
        return _accsryLabel!
    }

    // 用于detailView布局
    private lazy var detailLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private var _detailView: HWebImageView?
    ///文字右边，箭头左边显示图片
    var detailView: HWebImageView {
        if _detailView == nil {
            _detailView = HWebImageView()
        }
        return _detailView!
    }

    // 用于arrow布局
    private lazy var arrowLayoutView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    // arrow
    private lazy var accsryView: UIImageView = {
        let accsryView = UIImageView()
        accsryView.image = UIImage(named: "icon_tuple_arrow_right")
        accsryView.contentMode = .scaleAspectFill
        return accsryView
    }()

    ///是否显示右边箭头
    var isShowAccsryArrow: Bool = false

    // 设置layoutView通用间隔
    var layoutSpacing: CGFloat = 10.0

    // 在imageView后面添加自定义间隔
    var layoutFirstSpacing: CGFloat = 0.0

    // 在textLayoutView后面添加自定义间隔
    var layoutSecondSpacing: CGFloat = 0.0

    // 在detailView后面添加自定义间隔
    var layoutThirdSpacing: CGFloat = 0.0

    // 设置textLayoutView通用间隔
    var textSpacing: CGFloat = 0.0

    // 在label后面添加自定义间隔
    var firstTextSpacing: CGFloat = 0.0

    // 在detailLabel后面添加自定义间隔
    var secondTextSpacing: CGFloat = 0.0

    private var didSetupLayout = false
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?
    private var detailWidthConstraint: NSLayoutConstraint?
    private var detailHeightConstraint: NSLayoutConstraint?
    private var accsryWidthConstraint: NSLayoutConstraint?
    private var accsryHeightConstraint: NSLayoutConstraint?

    override func relayoutSubviews() {

        let frame = self.bounds.inset(by: self.edgeInsets)

        // 重设frame
        layoutView.frame = frame
        layoutView.spacing = layoutSpacing

        // imageView
        if let imageView = _imageView {

            var imageFrame = frame
            if imageView.imageSize != .zero {
                imageFrame.size = imageView.imageSize
            } else {
                imageFrame.width = frame.height
                imageFrame = imageFrame.inset(by: imageView.edgeInsets)
            }

            updateTupleApexConstraint(&imageWidthConstraint, on: imageView, attr: .width, constant: imageFrame.width)
            updateTupleApexConstraint(&imageHeightConstraint, on: imageView, attr: .height, constant: imageFrame.height)

            if !didSetupLayout {
                imageLayoutView.addArrangedSubview(imageView)
                layoutView.addArrangedSubview(imageLayoutView)
            }

            if layoutFirstSpacing > 0 {
                layoutView.setCustomSpacing(layoutFirstSpacing, after: imageLayoutView)
            }
        }

        // textLayoutView
        if !didSetupLayout {
            layoutView.addArrangedSubview(textLayoutView)
        }
        textLayoutView.spacing = textSpacing
        if layoutSecondSpacing > 0 {
            layoutView.setCustomSpacing(layoutSecondSpacing, after: textLayoutView)
        }

        // label
        if !didSetupLayout {
            textLayoutView.addArrangedSubview(label)
        }
        if firstTextSpacing > 0 {
            textLayoutView.setCustomSpacing(firstTextSpacing, after: label)
        }

        if let detailLabel = _detailLabel, !didSetupLayout {
            textLayoutView.addArrangedSubview(detailLabel)
            if secondTextSpacing > 0 {
                textLayoutView.setCustomSpacing(secondTextSpacing, after: detailLabel)
            }
        }
        if let accsryLabel = _accsryLabel, !didSetupLayout {
            textLayoutView.addArrangedSubview(accsryLabel)
        }

        // detailView
        if let detailView = _detailView {

            var detailFrame = frame
            if detailView.imageSize != .zero {
                detailFrame.size = detailView.imageSize
            } else {
                detailFrame.width = frame.height
                detailFrame = detailFrame.inset(by: detailView.edgeInsets)
            }

            updateTupleApexConstraint(&detailWidthConstraint, on: detailView, attr: .width, constant: detailFrame.width)
            updateTupleApexConstraint(&detailHeightConstraint, on: detailView, attr: .height, constant: detailFrame.height)

            if !didSetupLayout {
                detailLayoutView.addArrangedSubview(detailView)
                layoutView.addArrangedSubview(detailLayoutView)
            }

            if layoutThirdSpacing > 0 {
                layoutView.setCustomSpacing(layoutThirdSpacing, after: detailLayoutView)
            }
        }

        // accsryView
        if isShowAccsryArrow {
            if !didSetupLayout {
                layoutView.addArrangedSubview(arrowLayoutView)
                arrowLayoutView.addArrangedSubview(accsryView)
            }
            updateTupleApexConstraint(&accsryWidthConstraint, on: accsryView, attr: .width, constant: 7)
            updateTupleApexConstraint(&accsryHeightConstraint, on: accsryView, attr: .height, constant: 13)
        }

        didSetupLayout = true
    }
}

private func updateTupleApexConstraint(_ constraint: inout NSLayoutConstraint?, on view: UIView, attr: NSLayoutConstraint.Attribute, constant: CGFloat) {
    if let existing = constraint, existing.firstAttribute == attr {
        existing.constant = constant
    } else {
        constraint?.isActive = false
        let newConstraint = NSLayoutConstraint(
            item: view, attribute: attr,
            relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute,
            multiplier: 1, constant: constant
        )
        newConstraint.isActive = true
        constraint = newConstraint
    }
}
