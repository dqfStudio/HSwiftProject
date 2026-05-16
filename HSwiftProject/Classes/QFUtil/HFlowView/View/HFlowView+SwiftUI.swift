//
//  HFlowView+SwiftUI.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit
import SwiftUI

/// HFlowView 的 SwiftUI 包装器
///
/// 用于在 SwiftUI 中使用 HFlowView
@available(iOS 13.0, *)
struct HFlowViewRepresentable: UIViewRepresentable {
    /// 数据源
    var dataSource: [Any]
    /// 配置闭包
    var configuration: (HFlowView) -> Void
    /// 选择回调
    var onSelection: (IndexPath) -> Void
    
    /// 创建 UIView
    /// - Parameter context: 上下文
    /// - Returns: HFlowView 实例
    func makeUIView(context: Context) -> HFlowView {
        let flowView = HFlowView(frame: .zero)
        flowView.delegate = context.coordinator
        configuration(flowView)
        return flowView
    }
    
    /// 更新 UIView
    /// - Parameters:
    ///   - uiView: HFlowView 实例
    ///   - context: 上下文
    func updateUIView(_ uiView: HFlowView, context: Context) {
        uiView.reloadData()
    }
    
    /// 创建协调器
    /// - Returns: 协调器实例
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// 协调器，用于处理 HFlowView 的代理方法
    class Coordinator: NSObject, HFlowViewDelegate {
        /// 父视图
        let parent: HFlowViewRepresentable
        
        /// 初始化协调器
        /// - Parameter parent: 父视图
        init(_ parent: HFlowViewRepresentable) {
            self.parent = parent
        }
        
        /// 返回 section 数量
        /// - Returns: section 数量
        func numberOfSectionsInFlowView() -> Int {
            return 1
        }
        
        /// 返回指定 section 的 row 数量
        /// - Parameter section: section 索引
        /// - Returns: row 数量
        func numberOfRowsInSection(_ section: Int) -> Int {
            return parent.dataSource.count
        }
        
        /// 返回指定 indexPath 的 row 高度
        /// - Parameter indexPath: 索引路径
        /// - Returns: row 高度
        func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
            return 80.0
        }
        
        /// 返回指定 indexPath 的 cell
        /// - Parameters:
        ///   - flow: HFlowView 实例
        ///   - indexPath: 索引路径
        /// - Returns: UITableViewCell 实例
        func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
            let identifier = "SwiftUICell"
            let cell = flow.dequeueReusableCell(withIdentifier: identifier)
                ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
            return cell
        }
        
        /// 当 cell 被选中时调用
        /// - Parameter indexPath: 索引路径
        func didSelectCell(_ indexPath: IndexPath) {
            parent.onSelection(indexPath)
        }
    }
}

/// HFlowView 的 SwiftUI 视图
///
/// 提供更便捷的 SwiftUI 接口
@available(iOS 13.0, *)
public struct HFlowViewSwiftUI: View {
    /// 数据源
    private let dataSource: [Any]
    /// 配置闭包
    private let configuration: (HFlowView) -> Void
    /// 选择回调
    private let onSelection: (IndexPath) -> Void
    
    /// 初始化
    /// - Parameters:
    ///   - data: 数据源
    ///   - configuration: 配置闭包
    ///   - onSelection: 选择回调
    init(data: [Any], configuration: @escaping (HFlowView) -> Void, onSelection: @escaping (IndexPath) -> Void) {
        self.dataSource = data
        self.configuration = configuration
        self.onSelection = onSelection
    }
    
    /// 视图主体
    public var body: some View {
        HFlowViewRepresentable(
            dataSource: dataSource,
            configuration: configuration,
            onSelection: onSelection
        )
    }
}

/// 扩展 HFlowView，添加 SwiftUI 相关方法
@available(iOS 13.0, *)
extension HFlowView {
    /// 创建 SwiftUI 视图
    /// - Parameters:
    ///   - data: 数据源
    ///   - configuration: 配置闭包
    ///   - onSelection: 选择回调
    /// - Returns: SwiftUI 视图
    public static func swiftUI(data: [Any], configuration: @escaping (HFlowView) -> Void, onSelection: @escaping (IndexPath) -> Void) -> some View {
        HFlowViewSwiftUI(data: data, configuration: configuration, onSelection: onSelection)
    }
}

/// SwiftUI 预览
@available(iOS 13.0, *)
struct HFlowViewSwiftUIPreviews: PreviewProvider {
    static var previews: some View {
        let data = Array(0..<10).map { "Item \($0)" }
        
        HFlowView.swiftUI(
            data: data,
            configuration: { flowView in
                // 配置 HFlowView
                flowView.backgroundColor = .white
                flowView.refreshManager.setupRefresh(headerStyle: .gray) {}
                flowView.refreshManager.setupLoadMore(footerStyle: .style1) {}
            },
            onSelection: { indexPath in
                print("Selected: \(indexPath)")
            }
        )
        .frame(height: 400)
        .previewLayout(.sizeThatFits)
    }
}
