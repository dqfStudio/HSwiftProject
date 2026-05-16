//
//  HCollViewCellHoriValue.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/25.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

/// 横向列表单元格 - 支持三种布局模式
/// 
/// 功能说明：
/// 1. 左侧可选图片（imageView）
/// 2. 中间文本区域（label + detailLabel + accsryLabel）
/// 3. 右侧可选图片（detailView）
/// 4. 右侧可选箭头（accsryView）
/// 5. 支持三种文本排列方式：横向左到右、横向右到左、纵向
class HCollViewCellHoriValue: HCollTmplCell {
    
    // MARK: - 布局类型枚举
    
    /// 文本布局类型
    enum TextLayoutType {
        case horizontalLeftToRight   // 从左到右横向排列（原 HCollViewCellHoriValue1）
        case horizontalRightToLeft   // 从右到左横向排列（原 HCollViewCellHoriValue2）
        case vertical                // 垂直排列（原 HCollViewCellHoriValue3）
    }
    
    // MARK: - UI 组件
    
    /// 左侧图片视图
    private let imageView = HWebImageView()
    
    /// 主标题标签
    private let label = UILabel()
    
    /// 详情标签
    private let detailLabel = UILabel()
    
    /// 附加信息标签
    private let accsryLabel = UILabel()
    
    /// 右侧图片视图
    private let detailView = HWebImageView()
    
    /// 右侧箭头视图
    private let arrowView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_tuple_arrow_right"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - 配置属性
    
    /// 文本布局类型
    var textLayoutType: TextLayoutType = .horizontalLeftToRight
    
    /// layoutView 中各元素之间的间距
    var layoutSpacing: CGFloat = 10.0
    
    /// 文本区域内各元素之间的间距
    var textSpacing: CGFloat = 5.0
    
    /// 是否显示右侧箭头
    var isShowAccsryArrow: Bool = false
    
    /// label 的固定宽度（0 表示自适应）
    var labelWidth: CGFloat = 0.0
    
    /// detailLabel 的固定宽度（0 表示自适应）
    var detailWidth: CGFloat = 0.0
    
    /// accsryLabel 的固定宽度（0 表示自适应）
    var accsryWidth: CGFloat = 0.0
    
    /// imageView 后面的自定义间距
    var layoutFirstSpacing: CGFloat = 0.0
    
    /// textLayoutView 后面的自定义间距
    var layoutSecondSpacing: CGFloat = 0.0
    
    /// detailView 后面的自定义间距
    var layoutThirdSpacing: CGFloat = 0.0
    
    /// label 后面的自定义间距
    var firstTextSpacing: CGFloat = 0.0
    
    /// detailLabel 后面的自定义间距
    var secondTextSpacing: CGFloat = 0.0
    
    // MARK: - 初始化
    
    override func initUI() {
        super.initUI()
        setupLabels()
    }
    
    /// 设置标签样式
    private func setupLabels() {
        [label, detailLabel, accsryLabel].forEach {
            $0.font = .systemFont(ofSize: 14.0)
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
    }
    
    // MARK: - 布局
    
    override func relayoutSubviews() {
        super.relayoutSubviews()
        
        // 使用 FlexLayout 进行声明式布局
        contentView.flex
            .padding(edgeInsets)
            .direction(.row)
            .alignItems(.center)
            .justifyContent(.flexStart)
            .define { flex in
                
                // 1. 左侧图片
                if hasImage(imageView) {
                    flex.addItem(imageView)
                        .width(calculateImageSize().width)
                        .height(calculateImageSize().height)
                        .marginRight(layoutFirstSpacing > 0 ? layoutFirstSpacing : layoutSpacing)
                }
                
                // 2. 文本区域容器
                flex.addItem()
                    .grow(1)
                    .shrink(1)
                    .define { textFlex in
                        
                        // 根据布局类型设置方向
                        switch textLayoutType {
                        case .horizontalLeftToRight, .horizontalRightToLeft:
                            textFlex.direction(.row)
                            textFlex.alignItems(.center)
                        case .vertical:
                            textFlex.direction(.column)
                            textFlex.alignItems(.stretch)
                        }
                        
                        textFlex.spacing(textSpacing)
                        
                        // 添加 label
                        addLabelToFlex(textFlex, label)
                        
                        // 添加 detailLabel
                        if hasText(detailLabel) {
                            addLabelToFlex(textFlex, detailLabel, width: detailWidth)
                            
                            // detailLabel 后的间距
                            if secondTextSpacing > 0 && textLayoutType != .vertical {
                                textFlex.addItem().width(secondTextSpacing)
                            }
                        }
                        
                        // 添加 accsryLabel
                        if hasText(accsryLabel) {
                            addLabelToFlex(textFlex, accsryLabel, width: accsryWidth)
                        }
                    }
                
                // textLayoutView 后的间距
                if layoutSecondSpacing > 0 {
                    flex.addItem().width(layoutSecondSpacing)
                }
                
                // 3. 右侧图片
                if hasImage(detailView) {
                    flex.addItem(detailView)
                        .width(calculateDetailImageSize().width)
                        .height(calculateDetailImageSize().height)
                        .marginLeft(layoutThirdSpacing > 0 ? layoutThirdSpacing : layoutSpacing)
                }
                
                // 4. 右侧箭头
                if isShowAccsryArrow {
                    flex.addItem(arrowView)
                        .width(7)
                        .height(13)
                        .marginLeft(layoutSpacing)
                }
            }
        
        // 应用布局
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    // MARK: - 辅助方法
    
    /// 检查图片是否有内容
    private func hasImage(_ imageView: HWebImageView) -> Bool {
        return imageView.image != nil || imageView.kf.imageURL != nil
    }
    
    /// 检查标签是否有文本
    private func hasText(_ label: UILabel) -> Bool {
        return !(label.text?.isEmpty ?? true)
    }
    
    /// 计算 imageView 的尺寸
    private func calculateImageSize() -> CGSize {
        if imageView.imageSize != .zero {
            return imageView.imageSize
        } else {
            let height = bounds.height
            let insetFrame = bounds.inset(by: imageView.edgeInsets)
            return CGSize(width: height, height: height)
        }
    }
    
    /// 计算 detailView 的尺寸
    private func calculateDetailImageSize() -> CGSize {
        if detailView.imageSize != .zero {
            return detailView.imageSize
        } else {
            let height = bounds.height
            let insetFrame = bounds.inset(by: detailView.edgeInsets)
            return CGSize(width: height, height: height)
        }
    }
    
    /// 添加标签到 Flex 容器
    private func addLabelToFlex(_ flex: Flex, _ label: UILabel, width: CGFloat = 0) {
        let item = flex.addItem(label)
        
        if width > 0 {
            item.width(width)
        } else {
            // 如果没有指定宽度，允许自适应
            item.grow(0).shrink(0)
        }
        
        // label 后的间距（仅在横向布局时有效）
        if label == self.label && firstTextSpacing > 0 && textLayoutType != .vertical {
            flex.addItem().width(firstTextSpacing)
        }
    }
}

// MARK: - 兼容性扩展

/// 三个label横向从左向右抱紧显示（兼容旧代码）
@available(*, deprecated, message: "请使用 HCollViewCellHoriValue 并设置 textLayoutType = .horizontalLeftToRight")
class HCollViewCellHoriValue1: HCollViewCellHoriValue {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textLayoutType = .horizontalLeftToRight
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textLayoutType = .horizontalLeftToRight
    }
}

/// 三个label横向从右向左抱紧显示（兼容旧代码）
@available(*, deprecated, message: "请使用 HCollViewCellHoriValue 并设置 textLayoutType = .horizontalRightToLeft")
class HCollViewCellHoriValue2: HCollViewCellHoriValue {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textLayoutType = .horizontalRightToLeft
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textLayoutType = .horizontalRightToLeft
    }
}

/// 三个label纵向显示（兼容旧代码）
@available(*, deprecated, message: "请使用 HCollViewCellHoriValue 并设置 textLayoutType = .vertical")
class HCollViewCellHoriValue3: HCollViewCellHoriValue {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textLayoutType = .vertical
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textLayoutType = .vertical
    }
}
