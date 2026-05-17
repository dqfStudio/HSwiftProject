//
//  HCollView+SwiftUI.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import SwiftUI
import Combine

/// HCollView SwiftUI 扩展
///
/// 提供SwiftUI组件和Combine集成
extension HCollView {
    
    /// SwiftUI 视图包装器
    struct HCollViewRepresentable: UIViewRepresentable {
        
        // MARK: - 属性
        
        /// 配置闭包
        var configuration: (HCollView) -> Void
        
        /// 数据更新回调
        var onDataUpdate: (() -> Void)?
        
        // MARK: - 方法
        
        /// 创建UIView
        /// - Parameter context: 上下文
        /// - Returns: HCollView
        func makeUIView(context: Context) -> HCollView {
            let collectionView = HCollView()
            configuration(collectionView)
            return collectionView
        }
        
        /// 更新UIView
        /// - Parameters:
        ///   - uiView: HCollView
        ///   - context: 上下文
        func updateUIView(_ uiView: HCollView, context: Context) {
            onDataUpdate?()
        }
    }
    
    /// SwiftUI 数据源包装器
    class HCollViewDataSource: NSObject, UICollectionViewDataSource {
        
        // MARK: - 属性
        
        /// 单元格创建闭包
        var cellForItem: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell)?
        
        /// 分区数量
        var numberOfSections: (() -> Int)? = { 1 }
        
        /// 每个分区的项目数量
        var numberOfItemsInSection: ((_ section: Int) -> Int)?
        
        // MARK: - UICollectionViewDataSource
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return numberOfSections?() ?? 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numberOfItemsInSection?(section) ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return cellForItem?(collectionView, indexPath) ?? UICollectionViewCell()
        }
    }
    
    /// SwiftUI 代理包装器
    class HCollViewSwiftUIDelegate: NSObject, UICollectionViewDelegate {
        
        // MARK: - 属性
        
        /// 单元格点击闭包
        var didSelectItemAt: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)?
        
        /// 单元格大小闭包
        var sizeForItemAt: ((_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize)?
        
        // MARK: - UICollectionViewDelegate
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            didSelectItemAt?(collectionView, indexPath)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return sizeForItemAt?(collectionView, collectionViewLayout, indexPath) ?? CGSize(width: 100, height: 100)
        }
    }
    
    /// Combine 扩展
    class HCollViewCombine {
        
        // MARK: - 属性
        
        /// 集合视图
        private weak var collectionView: HCollView?
        
        /// 数据更新Subject
        private let dataUpdateSubject = PassthroughSubject<Void, Never>()
        
        /// 单元格点击Subject
        private let cellTapSubject = PassthroughSubject<IndexPath, Never>()
        
        /// 滚动Subject
        private let scrollSubject = PassthroughSubject<CGPoint, Never>()
        
        // MARK: - 初始化
        
        /// 初始化
        /// - Parameter collectionView: 集合视图
        init(collectionView: HCollView) {
            self.collectionView = collectionView
            setupObservers()
        }
        
        // MARK: - 方法
        
        /// 设置观察者
        private func setupObservers() {
            guard let collectionView = collectionView else { return }
            
            // 使用 UIScrollViewDelegate 监听滚动事件
            // 通过 UIScrollView 的 delegate 方法或 KVO 实现
        }
        
        /// 数据更新Publisher
        var dataUpdatePublisher: AnyPublisher<Void, Never> {
            return dataUpdateSubject.eraseToAnyPublisher()
        }
        
        /// 单元格点击Publisher
        var cellTapPublisher: AnyPublisher<IndexPath, Never> {
            return cellTapSubject.eraseToAnyPublisher()
        }
        
        /// 滚动Publisher
        var scrollPublisher: AnyPublisher<CGPoint, Never> {
            return scrollSubject.eraseToAnyPublisher()
        }
        
        /// 发送数据更新事件
        func sendDataUpdate() {
            dataUpdateSubject.send(())
        }
        
        /// 发送单元格点击事件
        /// - Parameter indexPath: 索引路径
        func sendCellTap(_ indexPath: IndexPath) {
            cellTapSubject.send(indexPath)
        }
        
        /// 发送滚动事件
        /// - Parameter offset: 滚动偏移
        func sendScroll(_ offset: CGPoint) {
            scrollSubject.send(offset)
        }
    }
    
    /// Combine 实例
    var combine: HCollViewCombine {
        get {
            if let combine = objc_getAssociatedObject(self, &combineKey) as? HCollViewCombine {
                return combine
            } else {
                let combine = HCollViewCombine(collectionView: self)
                objc_setAssociatedObject(self, &combineKey, combine, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return combine
            }
        }
        set {
            objc_setAssociatedObject(self, &combineKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// SwiftUI 视图
    /// - Parameter configuration: 配置闭包
    /// - Returns: SwiftUI 视图
    static func swiftUIView(configuration: @escaping (HCollView) -> Void) -> some View {
        HCollViewRepresentable(configuration: configuration)
    }
    
    /// SwiftUI 视图
    /// - Parameters:
    ///   - configuration: 配置闭包
    ///   - onDataUpdate: 数据更新回调
    /// - Returns: SwiftUI 视图
    static func swiftUIView(configuration: @escaping (HCollView) -> Void, onDataUpdate: @escaping () -> Void) -> some View {
        HCollViewRepresentable(configuration: configuration, onDataUpdate: onDataUpdate)
    }
}

/// 关联对象键
private var combineKey: UInt8 = 0

/// SwiftUI 扩展
extension HCollView {
    
    /// 示例 SwiftUI 视图
    struct ExampleView: View {
        
        // MARK: - 属性
        
        /// 数据
        @State private var data = Array(0..<20)
        
        // MARK: - 视图
        
        var body: some View {
            VStack {
                Text("HCollView SwiftUI Example")
                    .font(.title)
                    .padding()
                
                HCollView.swiftUIView {
                    collectionView in
                    
                    // 配置集合视图
                    collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
                    collectionView.backgroundColor = .white
                    
                    // 设置数据源
                    let dataSource = HCollViewDataSource()
                    dataSource.numberOfItemsInSection = { _ in self.data.count }
                    dataSource.cellForItem = { collectionView, indexPath in
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HCollBaseCell ?? HCollBaseCell()
                        cell.backgroundColor = .lightGray
                        // HCollBaseCell does not have textLabel; use a custom label or comment out
                        // cell.textLabel.text = "Item \(self.data[indexPath.item])"
                        return cell
                    }
                    collectionView.dataSource = dataSource
                    
                    // 注册单元格
                    collectionView.register(HCollBaseCell.self, forCellWithReuseIdentifier: "Cell")
                    
                    // 设置代理
                    let delegate = HCollViewSwiftUIDelegate()
                    delegate.didSelectItemAt = { collectionView, indexPath in
                        print("Selected item: \(indexPath.item)")
                    }
                    delegate.sizeForItemAt = { collectionView, layout, indexPath in
                        return CGSize(width: 100, height: 100)
                    }
                    collectionView.delegate = delegate
                    
                    // 应用布局
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = CGSize(width: 100, height: 100)
                    layout.minimumInteritemSpacing = 10
                    layout.minimumLineSpacing = 10
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    collectionView.setCollectionViewLayout(layout, animated: false)
                } onDataUpdate: {
                    // 数据更新时的回调
                }
                .frame(width: 300, height: 400)
                .border(Color.gray, width: 1)
                
                Button("Add Item") {
                    data.append(data.count)
                }
                .padding()
                
                Button("Remove Item") {
                    if !data.isEmpty {
                        data.removeLast()
                    }
                }
                .padding()
            }
        }
    }
}
