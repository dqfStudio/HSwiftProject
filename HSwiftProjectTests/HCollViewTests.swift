//
//  HCollViewTests.swift
//  HSwiftProjectTests
//
//  Created by owner on 2025/3/31.
//  Copyright © 2019 wind. All rights reserved.
//

import Testing
import UIKit
@testable import HSwiftProject

private final class HCollViewTestDelegate: NSObject, HCollViewDelegate {
    var itemCount = 0

    func numberOfItemsInSection(_ section: Int) -> Int { itemCount }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: 320, height: 44)
    }
}

private final class HCollViewCellStub: NSObject, HCollViewDelegate {
    var lastCell: HCollBaseCell?

    func numberOfItemsInSection(_ section: Int) -> Int { 1 }

    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: 320, height: 44)
    }

    func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath) {
        lastCell = coll.reuseCell(HCollBaseCell.self, false, indexPath)
    }
}

private final class HCollViewOneColumnDelegate: NSObject, HCollViewDelegate {
    func numberOfItemsInSection(_ section: Int) -> Int { 1 }
    func numberOfColumnsInSection(_ section: Int) -> Int { 1 }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: 320, height: 44)
    }
}

private final class HCollViewInsetDelegate: NSObject, HCollViewDelegate {
    func numberOfItemsInSection(_ section: Int) -> Int { 1 }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: 320, height: 44)
    }
    func insetForSection(_ section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }
}

private final class TwoSectionDelegate: NSObject, HCollViewDelegate {
    func numberOfSectionsInCollView() -> Int { 2 }
    func numberOfItemsInSection(_ section: Int) -> Int { 1 }
    func numberOfColumnsInSection(_ section: Int) -> Int { 2 }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 44)
    }
}

private final class HeaderFooterDelegate: NSObject, HCollViewDelegate {
    func numberOfItemsInSection(_ section: Int) -> Int { 1 }
    func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        CGSize(width: 320, height: 44)
    }
    func sizeForHeaderInSection(_ section: Int) -> CGSize {
        CGSize(width: 320, height: 30)
    }
    func sizeForFooterInSection(_ section: Int) -> CGSize {
        CGSize(width: 320, height: 20)
    }
    func insetForSection(_ section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}

@MainActor
private func makeCollView(size: CGSize = CGSize(width: 320, height: 480)) -> HCollView {
    HCollView(frame: CGRect(origin: .zero, size: size))
}

struct HCollViewTests {

    @Test @MainActor func testInitialization() {
        let collView = makeCollView()
        #expect(collView.frame == CGRect(x: 0, y: 0, width: 320, height: 480))
        #expect(collView.collAlign == .default)
        #expect(collView.pageNo == HCollPageConfig.defaultPageNo)
        #expect(collView.pageSize == HCollPageConfig.defaultPageSize)
        #expect(collView.totalNo == HCollPageConfig.maxTotalPages)
    }

    @Test @MainActor func testDataSourceAndDelegateAreSelf() {
        let collView = makeCollView()
        #expect(collView.dataSource === collView)
        #expect(collView.delegate === collView)

        collView.dataSource = nil
        #expect(collView.dataSource === collView)

        let stub = HCollViewTestDelegate()
        collView.delegate = stub
        #expect(collView.delegate === collView)
        #expect(collView.collDelegate === stub)
    }

    @Test @MainActor func testUIKitQueriesItemCountFromDelegate() {
        let collView = makeCollView()
        let stub = HCollViewTestDelegate()
        stub.itemCount = 7
        collView.delegate = stub
        collView.reloadData()
        #expect(collView.numberOfItems(inSection: 0) == 7)
    }

    @Test @MainActor func testPageConfigAllowsValuesBelowFormerDefaults() {
        let collView = makeCollView()

        collView.pageNo = 5
        #expect(collView.pageNo == 5)
        collView.pageNo = 0
        #expect(collView.pageNo == HCollPageConfig.defaultPageNo)

        collView.pageSize = 50
        #expect(collView.pageSize == 50)
        collView.pageSize = 5
        #expect(collView.pageSize == 5)
        collView.pageSize = 0
        #expect(collView.pageSize == HCollPageConfig.defaultPageSize)

        collView.totalNo = 100
        #expect(collView.totalNo == 100)
        collView.totalNo = 0
        #expect(collView.totalNo == HCollPageConfig.maxTotalPages)
    }

    @Test @MainActor func testHasMorePagesAndLoadMore() {
        let collView = makeCollView()
        collView.pageNo = 1
        collView.pageSize = 10
        collView.totalNo = 25

        var loadCount = 0
        collView.loadMoreBlock = { loadCount += 1 }
        #expect(collView.isLoadMoreFooterInstalled)

        #expect(collView.hasMorePages)
        #expect(collView.performLoadMoreIfNeeded())
        #expect(collView.pageNo == 2)
        #expect(loadCount == 1)

        #expect(collView.performLoadMoreIfNeeded())
        #expect(collView.pageNo == 3)
        #expect(loadCount == 2)

        #expect(!collView.hasMorePages)
        #expect(!collView.performLoadMoreIfNeeded())
        #expect(collView.pageNo == 3)
        #expect(loadCount == 2)
    }

    @Test @MainActor func testRefreshInstallsHeaderAndResetsPage() {
        let collView = makeCollView()
        collView.pageNo = 3
        var refreshCount = 0
        collView.refreshBlock = { refreshCount += 1 }

        #expect(collView.isRefreshHeaderInstalled)
        collView.performRefresh()
        #expect(collView.pageNo == 1)
        #expect(refreshCount == 1)
    }

    @Test @MainActor func testEmptyViewShowsWhenEmptyAndHidesWhenDataExists() {
        let collView = makeCollView()
        let stub = HCollViewTestDelegate()
        collView.delegate = stub

        let empty = UIView(frame: collView.bounds)
        empty.backgroundColor = .lightGray
        collView.emptyView = empty

        #expect(collView.emptyView === collView.backgroundView)
        #expect(collView.emptyView?.backgroundColor == .lightGray)

        stub.itemCount = 0
        collView.reloadData()
        #expect(collView.emptyView?.isHidden == false)

        stub.itemCount = 3
        collView.reloadData()
        #expect(collView.emptyView?.isHidden == true)
    }

    @Test @MainActor func testCenterAlignAddsTopInsetWhenContentIsShorterThanBounds() {
        let collView = makeCollView()
        collView.collAlign = .center
        collView.layoutIfNeeded()
        #expect(collView.contentInset.top > 0)

        collView.collAlign = .default
        collView.layoutIfNeeded()
        #expect(collView.contentInset == .zero)
    }

    @Test @MainActor func testReuseCellIsReturnedFromDataSource() {
        let collView = makeCollView()
        let stub = HCollViewCellStub()
        collView.delegate = stub
        collView.reloadData()

        let cell = collView.collectionView(collView, cellForItemAt: IndexPath(item: 0, section: 0))
        #expect(cell === stub.lastCell)
        #expect(cell is HCollBaseCell)
    }

    @Test @MainActor func testNumberOfColumnsAllowsOne() {
        let collView = makeCollView()
        let stub = HCollViewOneColumnDelegate()
        collView.delegate = stub
        #expect(collView.collectionView(collView, numberOfColumnsInSection: 0) == 1)
    }

    @Test @MainActor func testSectionInsetIsUsedForWidth() {
        let collView = makeCollView()
        let stub = HCollViewInsetDelegate()
        collView.delegate = stub
        _ = collView.numberOfItems(inSection: 0)
        #expect(collView.width(for: 0) == 296)
    }

    @Test func testLRUCacheEvictsLeastRecentlyUsed() {
        let cache = HCollLRUCache<String, String>(capacity: 2)
        cache.set("a", for: "1")
        cache.set("b", for: "2")
        _ = cache.get("1")
        cache.set("c", for: "3")
        #expect(cache.get("1") == "a")
        #expect(cache.get("2") == nil)
        #expect(cache.get("3") == "c")
    }

    @Test @MainActor func testSectionInsetsAppliedWithoutHeaderOrFooter() {
        let collView = makeCollView()
        let stub = HCollViewInsetDelegate()
        collView.delegate = stub
        collView.reloadData()
        collView.layoutIfNeeded()

        let layout = collView.collectionViewLayout
        let attr = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        #expect(attr?.frame.minY == 8)
        #expect(layout.collectionViewContentSize.height == 60)
    }

    @Test @MainActor func testLayoutAttributesForItemDoesNotMutateLayout() {
        let collView = makeCollView()
        let stub = HCollViewInsetDelegate()
        collView.delegate = stub
        collView.reloadData()
        collView.layoutIfNeeded()

        let layout = collView.collectionViewLayout
        let first = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        let heightAfterFirst = layout.collectionViewContentSize.height
        let second = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        #expect(first?.frame == second?.frame)
        #expect(layout.collectionViewContentSize.height == heightAfterFirst)
    }

    @Test @MainActor func testLayoutAttributesForItemReturnsIndependentCopy() {
        let collView = makeCollView()
        let stub = HCollViewInsetDelegate()
        collView.delegate = stub
        collView.reloadData()
        collView.layoutIfNeeded()

        let layout = collView.collectionViewLayout
        let first = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        #expect(first != nil)
        if let first {
            var frame = first.frame
            frame.origin.y = 999
            first.frame = frame
        }
        let second = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        #expect(second?.frame.origin.y != 999)
    }

    @Test @MainActor func testSecondSectionDoesNotOverlapFirstWithoutHeader() {
        let collView = makeCollView()
        let stub = TwoSectionDelegate()
        collView.delegate = stub
        collView.reloadData()
        collView.layoutIfNeeded()

        let layout = collView.collectionViewLayout
        let first = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        let second = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))
        #expect(first != nil)
        #expect(second != nil)
        if let first, let second {
            #expect(second.frame.minY >= first.frame.maxY)
        }
    }

    @Test @MainActor func testHeaderFooterInsetsOrder() {
        let collView = makeCollView()
        let stub = HeaderFooterDelegate()
        collView.delegate = stub
        collView.reloadData()
        collView.layoutIfNeeded()

        let layout = collView.collectionViewLayout
        let header = layout.layoutAttributesForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: 0)
        )
        let item = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
        let footer = layout.layoutAttributesForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(item: 0, section: 0)
        )
        #expect(header?.frame.minY == 0)
        #expect(item?.frame.minY == 38)
        #expect(footer?.frame.minY == 90)
        #expect(layout.collectionViewContentSize.height == 110)
    }

    @Test @MainActor func testValidItemIndexPathsFiltersOutOfRange() {
        let collView = makeCollView()
        let stub = HCollViewTestDelegate()
        stub.itemCount = 2
        collView.delegate = stub
        collView.reloadData()

        let valid = collView.validItemIndexPaths(from: [
            IndexPath(item: 0, section: 0),
            IndexPath(item: 5, section: 0),
            IndexPath(item: 0, section: 3)
        ])
        #expect(valid == [IndexPath(item: 0, section: 0)])
    }
}
