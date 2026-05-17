//
//  HCollView+Example.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import Alamofire

/// HCollView 使用示例
///
/// 本文件提供了 HCollView 的各种使用示例，帮助开发者快速上手。
class HCollViewExampleController: UIViewController, HCollViewDelegate {
    
    private var collView: HCollView!
    private var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollView()
        loadData()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // 添加布局切换按钮
        let layoutButton = UIBarButtonItem(title: "布局", style: .plain, target: self, action: #selector(showLayoutOptions))
        
        // 添加交互模式按钮
        let interactionButton = UIBarButtonItem(title: "交互", style: .plain, target: self, action: #selector(showInteractionOptions))
        
        // 添加性能优化按钮
        let performanceButton = UIBarButtonItem(title: "性能", style: .plain, target: self, action: #selector(showPerformanceOptions))
        
        // 添加解决方案按钮
        let solutionButton = UIBarButtonItem(title: "解决方案", style: .plain, target: self, action: #selector(showSolutionOptions))
        
        // 添加模板按钮
        let templateButton = UIBarButtonItem(title: "模板", style: .plain, target: self, action: #selector(showTemplateOptions))
        
        navigationItem.rightBarButtonItems = [templateButton, solutionButton, performanceButton, interactionButton, layoutButton]
    }
    
    private func setupCollView() {
        // 创建 HCollView 实例
        collView = HCollView(frame: view.bounds)
        collView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collView.backgroundColor = .white
        view.addSubview(collView)
        
        // 设置代理
        collView.delegate = self
        
        // 配置刷新和加载更多
        setupRefresh()
        
        // 配置空视图
        setupEmptyView()
        
        // 配置对齐方式
        collView.collAlign = .center
        
        // 配置预加载
        collView.preloadEnabled = true
        collView.preloadBlock = {
            print("触发预加载")
            // 这里可以添加预加载逻辑
        }
        
        // 启用性能优化
        setupPerformanceOptimization()
        
        // 启用网络优化
        setupNetworkOptimization()
        
        // 启用稳定性优化
        setupStabilityOptimization()
        
        // 启用扩展性
        setupExtensibility()
    }
    
    private func setupRefresh() {
        // 设置下拉刷新
        collView.refreshBlock = {
            print("开始刷新")
            // 模拟网络请求
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadData()
                self.collView.endRefreshing {}
            }
        }
        
        // 设置上拉加载更多
        collView.loadMoreBlock = {
            print("开始加载更多")
            // 模拟网络请求
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.loadMoreData()
                self.collView.endLoadMore {}
            }
        }
    }
    
    private func setupEmptyView() {
        // 创建自定义空视图
        let emptyView = UIView()
        emptyView.backgroundColor = .lightGray
        
        let label = UILabel()
        label.text = "暂无数据"
        label.textAlignment = .center
        label.textColor = .gray
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        label.center = emptyView.center
        
        emptyView.addSubview(label)
        
        // 设置空视图
        collView.emptyView = emptyView
    }
    
    private func setupPerformanceOptimization() {
        // 优化启动性能
        collView.optimizeStartupPerformance()
        
        // 启用内存监控
        collView.enableMemoryMonitoring()
        
        // 启用懒加载
        collView.enableLazyLoading()
        
        // 启用预加载
        collView.enablePreloading()
        
        // 创建对象池
        // collView.createObjectPool(key: "cellPool") { 
        //     HCollBaseCell()
        // }
    }
    
    private func setupNetworkOptimization() {
        // 启用离线模式
        collView.enableOfflineMode()
        
        // 启用网络状态适应
        collView.enableNetworkStateAdaptation()
        
        // 注册网络状态变化通知
        collView.registerForNetworkStatusChanges()
    }
    
    private func setupStabilityOptimization() {
        // 启用崩溃防护
        collView.enableCrashProtection()
        
        // 启用错误处理
        collView.enableErrorHandling()
        
        // 启用异常监控
        collView.enableExceptionMonitoring()
    }
    
    private func setupExtensibility() {
        // 注册插件
        let examplePlugin = ExtExamplePlugin()
        collView.registerExtPlugin(examplePlugin, forKey: "examplePlugin")
        
        // 设置主题
        collView.setExtTheme(ExtDefaultTheme())
        
        // 设置语言
        collView.setExtLanguage("zh-CN")
    }
    
    private func loadData() {
        // 模拟加载数据
        dataSource = Array(0..<20).map { "Item \($0)" }
        collView.reloadData()
    }
    
    private func loadMoreData() {
        // 模拟加载更多数据
        let moreData = Array(dataSource.count..<dataSource.count+20).map { "Item \($0)" }
        dataSource.append(contentsOf: moreData)
        collView.reloadData()
    }
    
    // MARK: - 布局选项
    
    @objc private func showLayoutOptions() {
        let alertController = UIAlertController(title: "选择布局", message: "请选择要使用的布局类型", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "网格布局", style: .default) { _ in
            self.collView.setLayout(.grid, configuration: ["columns": 3, "itemSize": CGSize(width: 100, height: 100), "spacing": 10])
        })
        
        alertController.addAction(UIAlertAction(title: "瀑布流布局", style: .default) { _ in
            self.collView.setLayout(.waterfall, configuration: ["columns": 2, "spacing": 10])
        })
        
        alertController.addAction(UIAlertAction(title: "时间线布局", style: .default) { _ in
            self.collView.setLayout(.timeline, configuration: ["lineColor": UIColor.gray, "lineWidth": 2, "spacing": 20])
        })
        
        alertController.addAction(UIAlertAction(title: "卡片布局", style: .default) { _ in
            self.collView.setLayout(.card, configuration: ["cornerRadius": 8, "shadowColor": UIColor.black, "shadowOffset": CGSize(width: 0, height: 2), "shadowRadius": 4, "shadowOpacity": 0.2, "spacing": 15])
        })
        
        alertController.addAction(UIAlertAction(title: "Masonry 布局", style: .default) { _ in
            self.collView.setLayout(.masonry, configuration: ["columns": 3, "spacing": 5])
        })
        
        alertController.addAction(UIAlertAction(title: "水平滚动布局", style: .default) { _ in
            self.collView.setLayout(.horizontal, configuration: ["itemSize": CGSize(width: 150, height: 100), "spacing": 10])
        })
        
        alertController.addAction(UIAlertAction(title: "垂直滚动布局", style: .default) { _ in
            self.collView.setLayout(.vertical, configuration: ["itemSize": CGSize(width: 300, height: 100), "spacing": 10])
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - 交互模式选项
    
    @objc private func showInteractionOptions() {
        let alertController = UIAlertController(title: "选择交互模式", message: "请选择要使用的交互模式", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "正常模式", style: .default) { _ in
            self.collView.setInteractionMode(.normal)
        })
        
        alertController.addAction(UIAlertAction(title: "拖拽排序模式", style: .default) { _ in
            self.collView.enableDragDrop()
        })
        
        alertController.addAction(UIAlertAction(title: "滑动操作模式", style: .default) { _ in
            self.collView.addSwipeActions([
                UIContextualAction(style: .destructive, title: "删除") { (action, view, completion) in
                    completion(true)
                },
                UIContextualAction(style: .normal, title: "编辑") { (action, view, completion) in
                    completion(true)
                }
            ], position: .trailing)
        })
        
        alertController.addAction(UIAlertAction(title: "多选模式", style: .default) { _ in
            self.collView.setInteractionMode(.multiSelect)
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - 性能优化选项
    
    @objc private func showPerformanceOptions() {
        let alertController = UIAlertController(title: "性能优化", message: "请选择要启用的性能优化选项", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "优化启动性能", style: .default) { _ in
            self.collView.optimizeStartupPerformance()
            print("启动性能优化已启用")
        })
        
        alertController.addAction(UIAlertAction(title: "启用内存监控", style: .default) { _ in
            self.collView.enableMemoryMonitoring()
            print("内存监控已启用")
        })
        
        alertController.addAction(UIAlertAction(title: "清理内存缓存", style: .default) { _ in
            self.collView.clearMemoryCache()
            print("内存缓存已清理")
        })
        
        alertController.addAction(UIAlertAction(title: "启用网络状态适应", style: .default) { _ in
            self.collView.enableNetworkStateAdaptation()
            print("网络状态适应已启用")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - 解决方案选项
    
    @objc private func showSolutionOptions() {
        let alertController = UIAlertController(title: "行业解决方案", message: "请选择要使用的行业解决方案", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "电商解决方案", style: .default) { _ in
            let solution = self.collView.getECommerceSolution()
            self.collView.applySolution(solution)
            print("电商解决方案已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "新闻解决方案", style: .default) { _ in
            let solution = self.collView.getNewsSolution()
            self.collView.applySolution(solution)
            print("新闻解决方案已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "社交媒体解决方案", style: .default) { _ in
            let solution = self.collView.getSocialMediaSolution()
            self.collView.applySolution(solution)
            print("社交媒体解决方案已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "图片库解决方案", style: .default) { _ in
            let solution = self.collView.getPhotoGallerySolution()
            self.collView.applySolution(solution)
            print("图片库解决方案已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - 模板选项
    
    @objc private func showTemplateOptions() {
        let alertController = UIAlertController(title: "模板市场", message: "请选择要使用的模板", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "网格布局模板", style: .default) { _ in
            self.collView.applyTemplate(name: "网格布局")
            print("网格布局模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "瀑布流布局模板", style: .default) { _ in
            self.collView.applyTemplate(name: "瀑布流布局")
            print("瀑布流布局模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "时间线布局模板", style: .default) { _ in
            self.collView.applyTemplate(name: "时间线布局")
            print("时间线布局模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "卡片布局模板", style: .default) { _ in
            self.collView.applyTemplate(name: "卡片布局")
            print("卡片布局模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "拖拽排序模板", style: .default) { _ in
            self.collView.applyTemplate(name: "拖拽排序")
            print("拖拽排序模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "滑动操作模板", style: .default) { _ in
            self.collView.applyTemplate(name: "滑动操作")
            print("滑动操作模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "多选模式模板", style: .default) { _ in
            self.collView.applyTemplate(name: "多选模式")
            print("多选模式模板已应用")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - HCollViewDelegate
    
    func numberOfSectionsInCollView() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return dataSource.count
    }
    
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 30) / 2 // 2列，左右边距10，中间间距10
        return CGSize(width: width, height: width)
    }
    
    func minimumLineSpacingForSectionAt(_ section: Int) -> CGFloat {
        return 10
    }
    
    func minimumInteritemSpacingForSectionAt(_ section: Int) -> CGFloat {
        return 10
    }
    
    func insetForSection(_ section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath) {
        // 这里可以配置 cell
        if let cell = coll.cellForItem(at: indexPath) as? HCollBaseCell {
            // 配置 cell
            cell.backgroundColor = .random
            
            // 添加标签
            if cell.contentView.subviews.isEmpty {
                let label = UILabel()
                label.textAlignment = .center
                label.frame = cell.contentView.bounds
                label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                cell.contentView.addSubview(label)
            }
            
            if let label = cell.contentView.subviews.first as? UILabel {
                label.text = dataSource[indexPath.item]
            }
        }
    }
    
    func didSelectCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath) {
        print("选中了: \(dataSource[indexPath.item])")
        
        // 示例：加载图片
        if let url = URL(string: "https://via.placeholder.com/150") {
            collView.loadImage(from: url) { image in
                if let image = image {
                    print("图片加载成功: \(image.size)")
                } else {
                    print("图片加载失败")
                }
            }
        }
        
        // 示例：发送网络请求
        collView.sendRequest("https://jsonplaceholder.typicode.com/todos/1") { data, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("网络请求成功: \(json)")
                } catch {
                    print("网络请求失败: \(error)")
                }
            } else if let error = error {
                print("网络请求失败: \(error)")
            }
        }
    }
}

/// 扩展 UIColor，提供随机颜色
extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}

