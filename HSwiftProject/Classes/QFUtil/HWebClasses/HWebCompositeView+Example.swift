//
//  HWebCompositeView+Example.swift
//  FreeChat
//
//  Created by Wind on 2026-04-16.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// HWebCompositeView 使用示例
extension HWebCompositeView {
    
    /// 创建一个默认的图文组合视图
    static func createDefaultCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.text = "示例文本"
        view.textColor = .black
        view.textFont = .systemFont(ofSize: 16)
        view.imageSize = CGSize(width: 44, height: 44)
        view.imageSpace = 10
        view.imagePosition = .left
        return view
    }
    
    /// 创建一个带网络图片的图文组合视图
    static func createNetworkImageCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.text = "网络图片示例"
        view.textColor = .black
        view.imageSize = CGSize(width: 44, height: 44)
        view.imageSpace = 10
        view.imagePosition = .left
        
        // 设置网络图片
        if let url = URL(string: "https://via.placeholder.com/44") {
            view.setImageUrl(url, placeholder: UIImage(named: "placeholder"))
            
            // 设置图片加载状态回调
            view.imageLoadStatus = { sender, status, error in
                switch status {
                case .loading:
                    print("图片加载中...")
                case .success:
                    print("图片加载成功")
                case .failure:
                    print("图片加载失败: \(error?.localizedDescription ?? "未知错误")")
                }
            }
        }
        
        return view
    }
    
    /// 创建一个带背景图片的图文组合视图
    static func createBackgroundImageCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.text = "背景图片示例"
        view.textColor = .white
        view.textFont = .systemFont(ofSize: 16)
        view.imageSize = CGSize(width: 44, height: 44)
        view.imageSpace = 10
        view.imagePosition = .left
        
        // 设置背景图片
        if let url = URL(string: "https://via.placeholder.com/200x100") {
            view.setBackgroundImageUrl(url, placeholder: UIImage(named: "background_placeholder"))
        }
        
        return view
    }
    
    /// 创建一个图片在上、文字在下的图文组合视图
    static func createImageTopCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
        view.text = "图片在上"
        view.textColor = .black
        view.textFont = .systemFont(ofSize: 14)
        view.imageSize = CGSize(width: 60, height: 60)
        view.imageSpace = 8
        view.imagePosition = .top
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        return view
    }
    
    /// 创建一个图片在下、文字在上的图文组合视图
    static func createImageBottomCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
        view.text = "图片在下"
        view.textColor = .black
        view.textFont = .systemFont(ofSize: 14)
        view.imageSize = CGSize(width: 60, height: 60)
        view.imageSpace = 8
        view.imagePosition = .bottom
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        return view
    }
    
    /// 创建一个图片在右、文字在左的图文组合视图
    static func createImageRightCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.text = "图片在右"
        view.textColor = .black
        view.textFont = .systemFont(ofSize: 16)
        view.imageSize = CGSize(width: 44, height: 44)
        view.imageSpace = 10
        view.imagePosition = .right
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        return view
    }
    
    /// 创建一个带点击事件的图文组合视图
    static func createClickableCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        view.text = "点击我"
        view.textColor = .black
        view.textFont = .systemFont(ofSize: 16)
        view.imageSize = CGSize(width: 44, height: 44)
        view.imageSpace = 10
        view.imagePosition = .left
        view.extraEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        // 设置点击事件
        view.pressed = { sender, data in
            print("点击了图文组合视图")
        }
        
        return view
    }
    
    /// 使用链式调用创建图文组合视图
    static func createCompositeViewWithChainSyntax() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            .text("链式调用示例")
            .textColor(.black)
            .textFont(.systemFont(ofSize: 16))
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
            .extraEdgeInsets(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            .pressed { sender, data in
                print("点击了链式调用创建的视图")
            }
        
        // 设置网络图片
        if let url = URL(string: "https://via.placeholder.com/44") {
            view.imageUrl(url)
        }
        
        return view
    }
    
    /// 创建带状态管理的图文组合视图
    static func createStatefulCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            .text("状态管理示例")
            .textColor(.black)
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
            .normalBackgroundColor(.clear)
            .disabledBackgroundColor(.lightGray.withAlphaComponent(0.3))
            .selectedBackgroundColor(.blue.withAlphaComponent(0.1))
            .highlightedBackgroundColor(.gray.withAlphaComponent(0.1))
            .loadingBackgroundColor(.clear)
            .normalTextColor(.black)
            .disabledTextColor(.gray)
            .selectedTextColor(.blue)
            .highlightedTextColor(.black)
            .loadingTextColor(.black)
            .animationDuration(0.2)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        // 点击事件：只需处理业务逻辑，状态切换由内部自动完成
        view.pressed = { sender, data in
            guard let compositeView = sender as? HWebCompositeView else { return }
            print("点击了视图，当前状态：\(compositeView.state)")
        }
        
        return view
    }
    
    /// 创建带手势支持的图文组合视图
    static func createGestureCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            .text("手势支持示例")
            .textColor(.black)
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
            .viewCornerRadius(8)
            .viewBorderWidth(1)
            .viewBorderColor(.lightGray)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        // 设置点击事件
        view.pressed = { sender, data in
            print("点击了视图")
        }
        
        // 设置长按事件
        view.longPressed = { sender, data in
            print("长按了视图")
        }
        
        // 设置双击事件
        view.doubleTapped = { sender, data in
            print("双击了视图")
        }
        
        return view
    }
    
    /// 创建带可访问性设置的图文组合视图
    static func createAccessibleCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            .text("可访问性示例")
            .textColor(.black)
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        // 设置可访问性属性
        view.accessibilityLabel = "可访问性示例"
        view.accessibilityHint = "点击以查看详细信息"
        view.accessibilityTraits = .button
        
        return view
    }
    
    /// 创建带滑动和拖拽手势的图文组合视图
    static func createGestureAdvancedCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            .text("手势高级示例")
            .textColor(.black)
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
            .viewCornerRadius(8)
            .viewBorderWidth(1)
            .viewBorderColor(.lightGray)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        // 设置点击事件
        view.pressed = { sender, data in
            print("点击了视图")
        }
        
        // 设置滑动事件
        view.swiped = { sender, direction in
            switch direction {
            case .right:
                print("向右滑动")
            case .left:
                print("向左滑动")
            case .up:
                print("向上滑动")
            case .down:
                print("向下滑动")
            default:
                break
            }
        }
        
        // 设置拖拽事件
        view.dragged = { sender, translation, velocity in
            print("拖拽位置: \(translation), 速度: \(velocity)")
        }
        
        return view
    }
    
    /// 创建图片居中布局的图文组合视图
    static func createImageCenterCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            .text("图片居中")
            .textColor(.black)
            .textFont(.systemFont(ofSize: 14))
            .imageSize(CGSize(width: 80, height: 80))
            .imagePosition(.center)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        return view
    }
    
    /// 创建文字环绕布局的图文组合视图
    static func createTextWrapCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
            .text("这是一个文字环绕图片的示例，文字会显示在图片的右侧，形成环绕效果。")
            .textColor(.black)
            .textFont(.systemFont(ofSize: 14))
            .textNumberOfLines(0)
            .imageSize(CGSize(width: 60, height: 60))
            .imageSpace(10)
            .imagePosition(.textWrap)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        return view
    }
    
    /// 创建带渐变背景的图文组合视图
    static func createGradientBackgroundCompositeView() -> HWebCompositeView {
        let view = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
            .text("渐变背景")
            .textColor(.white)
            .textFont(.systemFont(ofSize: 16))
            .imageSize(CGSize(width: 44, height: 44))
            .imageSpace(10)
            .imagePosition(.left)
            .viewCornerRadius(8)
        
        // 设置本地图片
        view.setImage(named: "icon")
        
        // 设置渐变背景
        view.gradientBackgroundColors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        view.gradientStartPoint = CGPoint(x: 0, y: 0)
        view.gradientEndPoint = CGPoint(x: 1, y: 1)
        
        return view
    }
}
