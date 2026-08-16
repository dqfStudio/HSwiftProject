import UIKit
import SnapKit

/// 图文相对位置
enum HImageTextPosition {
    /// 上图下文
    case top
    /// 左图右文
    case left
    /// 下文上图
    case bottom
    /// 左文右图
    case right
    /// 图上文下，作为一组在容器中居中
    case center
    /// 左上图、右侧顶对齐多行文本
    case leadingTop
}

enum HImageTextLayout {

    static func apply(
        stackView: UIStackView,
        imageView: UIImageView?,
        titleLabel: UILabel?,
        imageSize: CGSize,
        imageSpace: CGFloat,
        imagePosition: HImageTextPosition
    ) {
        stackView.spacing = imageSpace
        stackView.distribution = .fill

        switch imagePosition {
        case .left, .right, .leadingTop:
            stackView.axis = .horizontal
        case .top, .bottom, .center:
            stackView.axis = .vertical
        }

        switch imagePosition {
        case .leadingTop:
            stackView.alignment = .top
        case .left, .right, .top, .bottom:
            stackView.alignment = .center
        case .center:
            stackView.alignment = .center
        }

        let visibleLabel = Self.visibleLabel(titleLabel)
        var ordered: [UIView] = []
        switch imagePosition {
        case .left, .top, .center, .leadingTop:
            if let imageView { ordered.append(imageView) }
            if let visibleLabel { ordered.append(visibleLabel) }
        case .right, .bottom:
            if let visibleLabel { ordered.append(visibleLabel) }
            if let imageView { ordered.append(imageView) }
        }

        for view in stackView.arrangedSubviews where !ordered.contains(view) {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for (index, view) in ordered.enumerated() {
            if let current = stackView.arrangedSubviews.firstIndex(of: view) {
                if current != index {
                    stackView.removeArrangedSubview(view)
                    stackView.insertArrangedSubview(view, at: index)
                }
            } else {
                stackView.insertArrangedSubview(view, at: min(index, stackView.arrangedSubviews.count))
            }
        }

        if let imageView {
            imageView.snp.remakeConstraints { make in
                if imageSize.width > 0 {
                    make.width.equalTo(imageSize.width)
                }
                if imageSize.height > 0 {
                    make.height.equalTo(imageSize.height)
                }
            }
            let fillsContainer = visibleLabel == nil && imageSize == .zero && imagePosition != .center
            let hug: UILayoutPriority = fillsContainer ? .defaultLow : .required
            let resist: UILayoutPriority = fillsContainer ? .defaultLow : .required
            imageView.setContentHuggingPriority(hug, for: .horizontal)
            imageView.setContentHuggingPriority(hug, for: .vertical)
            imageView.setContentCompressionResistancePriority(resist, for: .horizontal)
            imageView.setContentCompressionResistancePriority(resist, for: .vertical)
            if fillsContainer {
                stackView.alignment = .fill
            }
        }

        if let visibleLabel {
            let hug: UILayoutPriority = imagePosition == .center ? .required : .defaultLow
            visibleLabel.setContentHuggingPriority(hug, for: .horizontal)
            visibleLabel.setContentHuggingPriority(hug, for: .vertical)
            visibleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            if imagePosition == .leadingTop {
                visibleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
            }
        }
    }

    static func visibleLabel(_ label: UILabel?) -> UILabel? {
        guard let label, let text = label.text, !text.isEmpty else { return nil }
        return label
    }
}
