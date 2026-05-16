//
//  HCollViewTests.swift
//  HSwiftProjectTests
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import Testing
@testable import HSwiftProject

struct HCollViewTests {
    
    @Test func testInitialization() async throws {
        // 测试默认初始化
        let collView = await HCollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        #expect(collView.frame == CGRect(x: 0, y: 0, width: 320, height: 480))
        #expect(collView.collAlign == .default)
        #expect(collView.pageNo == HCollPageConfig.defaultPageNo)
        #expect(collView.pageSize == HCollPageConfig.defaultPageSize)
        #expect(collView.totalNo == HCollPageConfig.maxTotalPages)
    }
    
    @Test func testDataSourceMethods() async throws {
        let collView = await HCollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // 测试 numberOfSections 方法
        let sections = collView.numberOfSections(in: collView)
        #expect(sections == 1)
        
        // 测试 numberOfItemsInSection 方法
        let items = collView.collectionView(collView, numberOfItemsInSection: 0)
        #expect(items == 0)
    }
    
    @Test func testRefreshAndLoadMore() async throws {
        let collView = await HCollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // 测试刷新和加载更多回调设置
        var refreshCalled = false
        var loadMoreCalled = false
        
        collView.refreshBlock = {
            refreshCalled = true
        }
        
        collView.loadMoreBlock = {
            loadMoreCalled = true
        }
        
        // 测试刷新方法
        collView.beginRefreshing {}
        #expect(refreshCalled == false) // 因为是异步调用
        
        // 测试加载更多方法
        collView.beginLoadMore {}
        #expect(loadMoreCalled == false) // 因为是异步调用
    }
    
    @Test func testEmptyView() async throws {
        let collView = await HCollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // 测试空视图设置
        let emptyView = UIView(frame: collView.bounds)
        emptyView.backgroundColor = .lightGray
        collView.emptyView = emptyView
        
        #expect(collView.emptyView != nil)
        #expect(collView.emptyView?.backgroundColor == .lightGray)
    }
    
    @Test func testPageConfig() async throws {
        let collView = await HCollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // 测试页码设置
        collView.pageNo = 5
        #expect(collView.pageNo == 5)
        
        // 测试页码边界情况
        collView.pageNo = 0
        #expect(collView.pageNo == HCollPageConfig.defaultPageNo)
        
        // 测试每页数量设置
        collView.pageSize = 50
        #expect(collView.pageSize == 50)
        
        // 测试每页数量边界情况
        collView.pageSize = 5
        #expect(collView.pageSize == HCollPageConfig.defaultPageSize)
    }
    
    @Test func testAlignment() async throws {
        let collView = await HCollView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // 测试对齐方式设置
        collView.collAlign = .center
        #expect(collView.collAlign == .center)
        
        collView.collAlign = .top(100)
        #expect(collView.collAlign == .top(100))
        
        collView.collAlign = .bottom(50)
        #expect(collView.collAlign == .bottom(50))
        
        collView.collAlign = .ratio(0.5)
        #expect(collView.collAlign == .ratio(0.5))
    }
    
    @Test func testLRUCache() async throws {
        let cache = HCollLRUCache<String, String>(capacity: 2)
        
        // 测试缓存设置和获取
        cache.set("value1", for: "key1")
        cache.set("value2", for: "key2")
        
        #expect(cache.get("key1") == "value1")
        #expect(cache.get("key2") == "value2")
        
        // 测试缓存淘汰
        cache.set("value3", for: "key3")
        #expect(cache.get("key1") == nil) // 应该被淘汰
        #expect(cache.get("key2") == "value2")
        #expect(cache.get("key3") == "value3")
        
        // 测试缓存更新
        cache.set("updatedValue2", for: "key2")
        #expect(cache.get("key2") == "updatedValue2")
    }
}
