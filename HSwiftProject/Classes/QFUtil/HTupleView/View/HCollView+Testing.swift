//
//  HCollView+Testing.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import XCTest

/// HCollView 测试扩展
///
/// 提供单元测试、集成测试和UI测试的支持
extension HCollView {
    
    /// 测试管理器
    class TestManager {
        
        // MARK: - 单例
        static let shared = TestManager()
        private init() {}
        
        // MARK: - 测试数据
        
        /// 生成测试数据
        /// - Parameters:
        ///   - count: 数据数量
        ///   - prefix: 数据前缀
        /// - Returns: 测试数据数组
        func generateTestData(count: Int, prefix: String = "Item") -> [String] {
            return (1...count).map { "\(prefix) \($0)" }
        }
        
        /// 生成测试 cell
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPath: 索引路径
        ///   - identifier: 重用标识符
        /// - Returns: 测试 cell
        func generateTestCell(_ collectionView: UICollectionView, at indexPath: IndexPath, identifier: String) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            
            // 配置测试 cell
            if let label = cell.viewWithTag(100) as? UILabel {
                label.text = "Cell \(indexPath.section)-\(indexPath.item)"
            }
            
            return cell
        }
        
        // MARK: - 性能测试
        
        /// 性能测试配置
        struct PerformanceTestConfig {
            /// 测试数据量
            let dataCount: Int
            /// 测试次数
            let testCount: Int
            /// 测试名称
            let testName: String
        }
        
        /// 执行性能测试
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - config: 测试配置
        ///   - testBlock: 测试闭包
        func runPerformanceTest(_ collectionView: HCollView, config: PerformanceTestConfig, testBlock: @escaping () -> Void) {
            // 准备测试数据
            let testData = generateTestData(count: config.dataCount)
            
            // 执行性能测试
            measure { [weak collectionView] in
                guard let collectionView = collectionView else { return }
                
                for _ in 1...config.testCount {
                    testBlock()
                }
            }
        }
        
        // MARK: - 功能测试
        
        /// 测试刷新功能
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - expectation: 测试期望
        func testRefresh(_ collectionView: HCollView, expectation: XCTestExpectation) {
            // 设置刷新回调
            collectionView.refreshBlock = {
                // 模拟网络请求
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    collectionView.endRefreshing {}
                    expectation.fulfill()
                }
            }
            
            // 触发刷新
            collectionView.beginRefreshing {}
        }
        
        /// 测试加载更多功能
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - expectation: 测试期望
        func testLoadMore(_ collectionView: HCollView, expectation: XCTestExpectation) {
            // 设置加载更多回调
            collectionView.loadMoreBlock = {
                // 模拟网络请求
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    collectionView.endLoadMore {}
                    expectation.fulfill()
                }
            }
            
            // 触发加载更多
            collectionView.beginLoadMore {}
        }
        
        /// 测试滚动功能
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - indexPath: 目标索引路径
        func testScrollToItem(_ collectionView: HCollView, at indexPath: IndexPath) {
            // 安全滚动
            collectionView.safeScrollToItem(at: indexPath, at: .top, animated: false)
            
            // 验证滚动位置
            XCTAssertTrue(collectionView.indexPathsForVisibleItems.contains(indexPath))
        }
        
        /// 测试数据重载
        /// - Parameters:
        ///   - collectionView: 集合视图
        ///   - dataCount: 数据数量
        func testReloadData(_ collectionView: HCollView, dataCount: Int) {
            // 重载数据
            collectionView.reloadData()
            
            // 验证数据数量
            XCTAssertEqual(collectionView.numberOfItems(inSection: 0), dataCount)
        }
        
        // MARK: - 边界测试
        
        /// 测试边界情况
        /// - Parameter collectionView: 集合视图
        func testEdgeCases(_ collectionView: HCollView) {
            // 测试空数据
            collectionView.reloadData()
            XCTAssertEqual(collectionView.numberOfSections, 0)
            
            // 测试越界索引
            let invalidIndexPath = IndexPath(item: 999, section: 999)
            let cell = collectionView.safeCellForItem(at: invalidIndexPath)
            XCTAssertNil(cell)
            
            // 测试负数索引
            let negativeIndexPath = IndexPath(item: -1, section: -1)
            let negativeCell = collectionView.safeCellForItem(at: negativeIndexPath)
            XCTAssertNil(negativeCell)
        }
    }
    
    /// 测试管理器
    var testManager: TestManager {
        return TestManager.shared
    }
    
    /// 准备测试
    /// - Parameters:
    ///   - dataCount: 测试数据数量
    ///   - cellIdentifier: cell 重用标识符
    func prepareForTesting(dataCount: Int, cellIdentifier: String) {
        // 注册测试 cell
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // 模拟数据源
        // 注意：实际测试中需要设置真实的数据源
    }
    
    /// 运行性能测试
    /// - Parameters:
    ///   - dataCount: 测试数据数量
    ///   - testCount: 测试次数
    ///   - testName: 测试名称
    func runPerformanceTest(dataCount: Int, testCount: Int, testName: String) {
        let config = TestManager.PerformanceTestConfig(dataCount: dataCount, testCount: testCount, testName: testName)
        testManager.runPerformanceTest(self, config: config) { [weak self] in
            self?.reloadData()
        }
    }
    
    /// 运行功能测试
    /// - Parameter expectation: 测试期望
    func runFunctionalityTest(expectation: XCTestExpectation) {
        // 测试刷新
        testManager.testRefresh(self, expectation: expectation)
        
        // 测试加载更多
        // testManager.testLoadMore(self, expectation: expectation)
    }
    
    /// 运行边界测试
    func runEdgeCaseTest() {
        testManager.testEdgeCases(self)
    }
}
