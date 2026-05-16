//
//  HFlowView+Example.swift
//  HSwiftProject
//
//  Created by owner on 2026/4/19.
//  Copyright © 2026 wind. All rights reserved.
//

import UIKit

/// HFlowView 使用示例
///
/// 本文件提供了 HFlowView 的各种使用示例，帮助开发者快速上手。
class HFlowViewExampleController: UIViewController, HFlowViewDelegate {
    
    private var hFlowView: HFlowView!
    private var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowView()
        loadData()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // 添加刷新按钮
        let refreshButton = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(manualRefresh))
        
        // 添加滚动按钮
        let scrollButton = UIBarButtonItem(title: "滚动", style: .plain, target: self, action: #selector(showScrollOptions))
        
        // 添加性能按钮
        let performanceButton = UIBarButtonItem(title: "性能", style: .plain, target: self, action: #selector(showPerformanceOptions))
        
        navigationItem.rightBarButtonItems = [performanceButton, scrollButton, refreshButton]
    }
    
    private func setupFlowView() {
        // 创建 HFlowView 实例
        hFlowView = HFlowView(frame: view.bounds)
        hFlowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hFlowView.backgroundColor = .white
        view.addSubview(hFlowView)
        
        // 设置代理
        hFlowView.delegate = self
        
        // 配置刷新和加载更多
        setupRefresh()
        
        // 配置空视图
        setupEmptyView()
        
        // 配置预加载
        hFlowView.preloadBlock = {
            print("触发预加载")
            // 这里可以添加预加载逻辑
        }
        
        // 启用性能优化
        setupPerformanceOptimization()
    }
    
    private func setupRefresh() {
        // 设置下拉刷新
         hFlowView.refreshBlock = {
             print("开始刷新")
             // 模拟网络请求
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 self.loadData()
                 self.hFlowView.endRefreshing {}
             }
         }
        
        // 设置上拉加载更多
         hFlowView.loadMoreBlock = {
             print("开始加载更多")
             // 模拟网络请求
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 self.loadMoreData()
                 self.hFlowView.endLoadMore {}
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
        hFlowView.emptyView = emptyView
    }
    
    private func setupPerformanceOptimization() {
        // 监听内存警告
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
        
        // 启用性能监控
        hFlowView.startPerformanceMonitoring()
        
        // 启用微交互
        hFlowView.enableMicroInteraction = true
        
        // 启用骨架屏
        hFlowView.enableSkeleton = true
        
        // 启用智能预加载
        hFlowView.preloadManager.enablePreloading = true
        
        // 启用无障碍支持
        hFlowView.enableAccessibility = true
        
        // 启用异步布局
        hFlowView.enableAsyncLayout = true
    }
    
    @objc private func handleMemoryWarning() {
        // 清理缓存
        hFlowView.clearCache()
        print("内存缓存已清理")
    }
    
    private func loadData() {
        // 模拟加载数据
        dataSource = Array(0..<20).map { "Item \($0)" }
        hFlowView.reloadData()
    }
    
    private func loadMoreData() {
        // 模拟加载更多数据
        let moreData = Array(dataSource.count..<dataSource.count+20).map { "Item \($0)" }
        dataSource.append(contentsOf: moreData)
        hFlowView.reloadData()
    }
    
    // MARK: - 手动刷新
    
    @objc private func manualRefresh() {
        hFlowView.beginRefreshing {}
    }
    
    // MARK: - 滚动选项
    
    @objc private func showScrollOptions() {
        let alertController = UIAlertController(title: "滚动选项", message: "请选择滚动操作", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "滚动到顶部", style: .default) {
            _ in
            self.hFlowView.scrollToTop(animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "滚动到底部", style: .default) {
            _ in
            self.hFlowView.scrollToBottom(animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "滚动到指定位置", style: .default) {
            _ in
            let indexPath = IndexPath(row: 5, section: 0)
            self.hFlowView.scrollToIndexPath(indexPath, at: .middle, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - 性能优化选项
    
    @objc private func showPerformanceOptions() {
        let alertController = UIAlertController(title: "性能优化", message: "请选择要执行的性能优化操作", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "清理缓存", style: .default) {
            _ in
            self.hFlowView.clearCache()
            print("缓存已清理")
        })
        
        alertController.addAction(UIAlertAction(title: "节流刷新", style: .default) {
            _ in
            self.hFlowView.reloadIfNeeded()
            print("节流刷新已执行")
        })
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alertController, animated: true)
    }
    
    // MARK: - HFlowViewDelegate
    
    func numberOfSectionsInFlowView() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return dataSource.count
    }
    
    func heightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func flowRow(_ flow: HFlowView, atIndexPath indexPath: IndexPath) -> UITableViewCell? {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.backgroundColor = .randomColor
        return cell
    }
    
    func didSelectCell(_ indexPath: IndexPath) {
        print("选中了: \(dataSource[indexPath.row])")
    }
}

/// 扩展 UIColor，提供随机颜色
extension UIColor {
    static var randomColor: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
