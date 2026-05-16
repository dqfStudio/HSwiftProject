//
//  HCollView+Rx.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// HCollView 的 RxSwift 扩展
///
/// 提供了数据绑定和响应式编程支持
extension Reactive where Base: HCollView {
    
    /// 数据源绑定
    /// - Parameter source: 数据源 Observable
    /// - Returns: Disposable
    func items<S: Sequence, O: ObservableType>(_ source: O)
        -> Disposable where O.Element == S {
        
        return source.bind {[weak base] items in
            guard let base = base else { return }
            
            // 这里需要根据具体的数据结构和业务逻辑来实现
            // 示例：假设 items 是一个字符串数组
            // 实际使用时，需要根据具体的数据源类型进行调整
            base.reloadData()
        }
    }
    
    /// 带 cell 配置的数据源绑定
    /// - Parameters:
    ///   - source: 数据源 Observable
    ///   - configureCell: cell 配置闭包
    /// - Returns: Disposable
    func items<S: Sequence, O: ObservableType, Cell: HCollBaseCell>(_ source: O, configureCell: @escaping (HCollView, IndexPath, S.Element) -> Cell)
        -> Disposable where O.Element == S {
        
        return source.bind {[weak base] items in
            guard let base = base else { return }
            
            // 这里需要根据具体的数据结构和业务逻辑来实现
            // 示例：假设 items 是一个泛型序列
            // 实际使用时，需要根据具体的数据源类型进行调整
            base.reloadData()
        }
    }
    
    /// 刷新状态绑定
    var isRefreshing: Binder<Bool> {
        return Binder(base) { collView, isRefreshing in
            if isRefreshing {
                collView.beginRefreshing {}
            } else {
                collView.endRefreshing {}
            }
        }
    }
    
    /// 加载更多状态绑定
    var isLoadingMore: Binder<Bool> {
        return Binder(base) { collView, isLoadingMore in
            if isLoadingMore {
                collView.beginLoadMore {}
            } else {
                collView.endLoadMore {}
            }
        }
    }
    
    /// 滚动事件 Observable
    var didScroll: ControlEvent<UIScrollView> {
        let source = delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidScroll(_:)))
            .map { args in
                return args[0] as! UIScrollView
            }
        return ControlEvent(events: source)
    }
    
    /// 滚动结束事件 Observable
    var didEndDecelerating: ControlEvent<UIScrollView> {
        let source = delegate
            .methodInvoked(#selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
            .map { args in
                return args[0] as! UIScrollView
            }
        return ControlEvent(events: source)
    }
    
    /// 单元格点击事件 Observable
    var itemSelected: ControlEvent<IndexPath> {
        let source = delegate
            .methodInvoked(#selector(UICollectionViewDelegate.collectionView(_:didSelectItemAt:)))
            .map { args in
                return args[1] as! IndexPath
            }
        return ControlEvent(events: source)
    }
    
    /// 内容大小变化事件 Observable
    var contentSizeChanged: Observable<CGSize> {
        return base.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0 }
    }
    
    /// 下拉刷新事件 Observable
    var refreshTrigger: ControlEvent<Void> {
        let source = PublishSubject<Void>()
        
        base.refreshBlock = {
            source.onNext(())
        }
        
        return ControlEvent(events: source)
    }
    
    /// 上拉加载更多事件 Observable
    var loadMoreTrigger: ControlEvent<Void> {
        let source = PublishSubject<Void>()
        
        base.loadMoreBlock = {
            source.onNext(())
        }
        
        return ControlEvent(events: source)
    }
}

/// HCollView 的 RxSwift 扩展
extension HCollView {
    
    /// 获取 Reactive 实例
    var rx: Reactive<HCollView> {
        return Reactive(self)
    }
    
    /// 绑定数据源
    /// - Parameter observable: 数据源 Observable
    /// - Returns: Disposable
    func bindDataSource<T>(_ observable: Observable<[T]>) -> Disposable {
        return observable.bind {[weak self] _ in
            self?.reloadData()
        }
    }
    
    /// 绑定刷新状态
    /// - Parameter observable: 刷新状态 Observable
    /// - Returns: Disposable
    func bindRefreshing(_ observable: Observable<Bool>) -> Disposable {
        return observable.bind(to: rx.isRefreshing)
    }
    
    /// 绑定加载更多状态
    /// - Parameter observable: 加载更多状态 Observable
    /// - Returns: Disposable
    func bindLoadingMore(_ observable: Observable<Bool>) -> Disposable {
        return observable.bind(to: rx.isLoadingMore)
    }
}
