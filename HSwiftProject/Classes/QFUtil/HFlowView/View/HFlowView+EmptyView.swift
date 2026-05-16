//
//  HFlowView+EmptyView.swift
//  HSwiftProject
//
//  Created by Wind on 2019/11/22.
//  Copyright © 2019 wind. All rights reserved.
//

import UIKit

// 关联对象键
private var emptyViewEnabledKey: UInt8 = 0

// MARK: - Empty View Support
///
/// 空视图支持扩展，提供 HFlowView 的空状态显示功能
///
/// 本扩展提供了以下功能：
/// - 空视图的设置和管理
/// - 空视图的显示和隐藏控制
/// - 空视图的默认配置
extension HFlowView {
    
    /// 空视图是否启用
    public var emptyViewEnabled: Bool {
        get {
            if let enabled = objc_getAssociatedObject(self, &emptyViewEnabledKey) as? Bool {
                return enabled
            } else {
                let enabled = true
                objc_setAssociatedObject(self, &emptyViewEnabledKey, enabled, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return enabled
            }
        }
        set {
            objc_setAssociatedObject(self, &emptyViewEnabledKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 自定义空视图
    public var emptyView: UIView? {
        get {
            return subviews.first { $0.tag == Constants.emptyViewTag }
        }
        set {
            // 移除旧的空视图
            subviews.forEach { view in
                if view.tag == Constants.emptyViewTag {
                    view.removeFromSuperview()
                }
            }
            
            // 添加新的空视图
            if let newView = newValue {
                newView.tag = Constants.emptyViewTag
                newView.frame = bounds
                insertSubview(newView, at: 0)
                newView.isHidden = true
            }
        }
    }
    
    /// 更新空视图状态
    internal func updateEmptyView() {
        guard emptyViewEnabled, let emptyView = emptyView else { return }
        
        let sections = numberOfSections
        var hasData = false
        
        for section in 0..<sections {
            if numberOfRows(inSection: section) > 0 {
                hasData = true
                break
            }
        }
        
        emptyView.isHidden = hasData
    }
    
    /// 设置默认空视图
    /// - Parameters:
    ///   - title: 空视图标题
    ///   - message: 空视图消息
    ///   - image: 空视图图片
    func setDefaultEmptyView(title: String = "暂无数据", message: String = "下拉刷新重试", image: UIImage? = nil) {
        let emptyView = UIView()
        emptyView.backgroundColor = .clear
        
        // 图片视图
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            emptyView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(100)
                make.width.height.equalTo(100)
            }
        }
        
        // 标题标签
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        emptyView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            if let imageView = emptyView.subviews.first as? UIImageView {
                make.top.equalTo(imageView.snp.bottom).offset(20)
            } else {
                make.top.equalToSuperview().offset(100)
            }
            make.centerX.equalToSuperview()
        }
        
        // 消息标签
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        emptyView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.emptyView = emptyView
    }
}
