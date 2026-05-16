import UIKit
import SnapKit

/// 图片位置枚举
enum HImagePosition {
    case top    // 图片在上，文字在下
    case left   // 图片在左，文字在右
    case bottom // 图片在下，文字在上
    case right  // 图片在右，文字在左
    case center // 图片居中
    case textWrap // 文字环绕图片
}

/// 布局管理器类
class HWebLayoutManager {
    
    /// 布局类型
    enum LayoutType {
        case topImage
        case leftImage
        case bottomImage
        case rightImage
    }
    
    /// 布局参数
    struct LayoutParams {
        let imageView: UIImageView?
        let titleLabel: UILabel?
        let imageSize: CGSize
        let imageSpace: CGFloat
        let imagePosition: HImagePosition
    }
    
    /// 执行布局
    /// - Parameter params: 布局参数
    static func performLayout(with params: LayoutParams) {
        guard params.imageView != nil || params.titleLabel != nil else { return }
        
        // 移除旧的约束
        params.imageView?.snp.removeConstraints()
        params.titleLabel?.snp.removeConstraints()
        
        // 计算尺寸
        let imageWidth = params.imageSize.width > 0 ? params.imageSize.width : (params.imageView?.image?.size.width ?? 0)
        let imageHeight = params.imageSize.height > 0 ? params.imageSize.height : (params.imageView?.image?.size.height ?? 0)
        
        // 根据位置布局
        switch params.imagePosition {
        case .top:
            layoutTopPosition(imageView: params.imageView, titleLabel: params.titleLabel, imageWidth: imageWidth, imageHeight: imageHeight, imageSpace: params.imageSpace)
        case .left:
            layoutLeftPosition(imageView: params.imageView, titleLabel: params.titleLabel, imageWidth: imageWidth, imageHeight: imageHeight, imageSpace: params.imageSpace)
        case .bottom:
            layoutBottomPosition(imageView: params.imageView, titleLabel: params.titleLabel, imageWidth: imageWidth, imageHeight: imageHeight, imageSpace: params.imageSpace)
        case .right:
            layoutRightPosition(imageView: params.imageView, titleLabel: params.titleLabel, imageWidth: imageWidth, imageHeight: imageHeight, imageSpace: params.imageSpace)
        case .center:
            layoutCenterPosition(imageView: params.imageView, titleLabel: params.titleLabel, imageWidth: imageWidth, imageHeight: imageHeight)
        case .textWrap:
            layoutTextWrapPosition(imageView: params.imageView, titleLabel: params.titleLabel, imageWidth: imageWidth, imageHeight: imageHeight, imageSpace: params.imageSpace)
        }
    }
    
    /// 布局：图片在上，文字在下
    private static func layoutTopPosition(imageView: UIImageView?, titleLabel: UILabel?, imageWidth: CGFloat, imageHeight: CGFloat, imageSpace: CGFloat) {
        if let imageView = imageView {
            imageView.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
            }
        }
        
        if let titleLabel = titleLabel {
            if let imageView = imageView {
                titleLabel.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom).offset(imageSpace)
                    make.centerX.equalToSuperview()
                    make.width.lessThanOrEqualToSuperview()
                }
            } else {
                centerTitleLabel(titleLabel)
            }
        }
    }
    
    /// 布局：图片在左，文字在右
    private static func layoutLeftPosition(imageView: UIImageView?, titleLabel: UILabel?, imageWidth: CGFloat, imageHeight: CGFloat, imageSpace: CGFloat) {
        if let imageView = imageView {
            imageView.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
            }
        }
        
        if let titleLabel = titleLabel {
            if let imageView = imageView {
                titleLabel.snp.makeConstraints { make in
                    make.left.equalTo(imageView.snp.right).offset(imageSpace)
                    make.centerY.equalToSuperview()
                    make.right.lessThanOrEqualToSuperview()
                }
            } else {
                centerTitleLabel(titleLabel)
            }
        }
    }
    
    /// 布局：图片在下，文字在上
    private static func layoutBottomPosition(imageView: UIImageView?, titleLabel: UILabel?, imageWidth: CGFloat, imageHeight: CGFloat, imageSpace: CGFloat) {
        if let titleLabel = titleLabel {
            titleLabel.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.width.lessThanOrEqualToSuperview()
            }
        }
        
        if let imageView = imageView {
            if let titleLabel = titleLabel {
                imageView.snp.makeConstraints { make in
                    make.top.equalTo(titleLabel.snp.bottom).offset(imageSpace)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(imageWidth)
                    make.height.equalTo(imageHeight)
                }
            } else {
                centerImageView(imageView, imageWidth: imageWidth, imageHeight: imageHeight)
            }
        }
    }
    
    /// 布局：图片在右，文字在左
    private static func layoutRightPosition(imageView: UIImageView?, titleLabel: UILabel?, imageWidth: CGFloat, imageHeight: CGFloat, imageSpace: CGFloat) {
        if let titleLabel = titleLabel {
            titleLabel.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
                make.width.lessThanOrEqualToSuperview()
            }
        }
        
        if let imageView = imageView {
            if let titleLabel = titleLabel {
                imageView.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(imageSpace)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(imageWidth)
                    make.height.equalTo(imageHeight)
                }
            } else {
                centerImageView(imageView, imageWidth: imageWidth, imageHeight: imageHeight)
            }
        }
    }
    
    /// 居中显示文字
    private static func centerTitleLabel(_ titleLabel: UILabel) {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
    /// 居中显示图片
    private static func centerImageView(_ imageView: UIImageView, imageWidth: CGFloat, imageHeight: CGFloat) {
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(imageWidth)
            make.height.equalTo(imageHeight)
        }
    }
    
    /// 布局：图片居中
    private static func layoutCenterPosition(imageView: UIImageView?, titleLabel: UILabel?, imageWidth: CGFloat, imageHeight: CGFloat) {
        if let imageView = imageView {
            centerImageView(imageView, imageWidth: imageWidth, imageHeight: imageHeight)
        }
        
        if let titleLabel = titleLabel {
            centerTitleLabel(titleLabel)
        }
    }
    
    /// 布局：文字环绕图片
    private static func layoutTextWrapPosition(imageView: UIImageView?, titleLabel: UILabel?, imageWidth: CGFloat, imageHeight: CGFloat, imageSpace: CGFloat) {
        if let imageView = imageView {
            imageView.snp.makeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
            }
        }
        
        if let titleLabel = titleLabel {
            if let imageView = imageView {
                titleLabel.snp.makeConstraints { make in
                    make.left.equalTo(imageView.snp.right).offset(imageSpace)
                    make.right.equalToSuperview()
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            } else {
                centerTitleLabel(titleLabel)
            }
        }
    }
}
