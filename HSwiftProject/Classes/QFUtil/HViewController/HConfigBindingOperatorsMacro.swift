//
//  HConfigBindingOperatorsMacro.swift
//  HSwiftProject
//
//  Created by windy on 2025/11/13.
//  Copyright © 2025 wind. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - Two way binding shorthand
// swiftlint:disable operator_whitespace
infix operator <~> : DefaultPrecedence

/// Bidirectional bind between a `ControlProperty` and a `BehaviorRelay`.
/// - Important: Use this only when both sides represent the same source of truth.
@discardableResult
public func <~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property.bind(to: relay)
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

@discardableResult
public func <~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property.bind(to: relay)
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

/// Bidirectional bind with duplicate-value suppression on UI -> relay stream.
@discardableResult
public func <~><T: Equatable>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .distinctUntilChanged()
        .bind(to: relay)

    return Disposables.create(bindToUIDisposable, bindToRelay)
}

/// Bidirectional bind with duplicate-value suppression on UI -> relay stream.
@discardableResult
public func <~><T: Equatable>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .distinctUntilChanged()
        .bind(to: relay)

    return Disposables.create(bindToUIDisposable, bindToRelay)
}

// MARK: - One way binding shorthand

infix operator ~>: DefaultPrecedence

/// Observable
@available(*, deprecated, message: "Use explicit overloads (to Binder/Relay/ControlProperty) to avoid ambiguous type inference.")
@discardableResult
public func ~><T, R>(source: Observable<T>, binder: (Observable<T>) -> R) -> R {
    return source.bind(to: binder)
}

@discardableResult
public func ~><T>(source: Observable<T>, binder: Binder<T>) -> Disposable {
    return source.bind(to: binder)
}

@discardableResult
public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T>) -> Disposable {
    return source.bind(to: relay)
}

@discardableResult
public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.bind(to: relay)
}

@discardableResult
public func ~><T>(source: BehaviorRelay<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.bind(to: relay)
}

@discardableResult
public func ~><T>(source: BehaviorRelay<T>, relay: BehaviorRelay<T>) -> Disposable {
    return source.bind(to: relay)
}

/// Single
@discardableResult
public func ~><T>(source: Single<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.subscribe(onSuccess: relay.accept)
}

/// Driver
@discardableResult
public func ~><T>(source: Driver<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.drive(onNext: relay.accept)
}

@discardableResult
public func ~><T>(source: Driver<T>, binder: Binder<T>) -> Disposable {
    return source.drive(onNext: binder.onNext)
}

@discardableResult
public func ~><T>(source: Observable<T>, property: ControlProperty<T>) -> Disposable {
    return source.bind(to: property)
}

/// BehaviorRelay
@discardableResult
public func ~><T>(relay: BehaviorRelay<T>, observer: Binder<T>) -> Disposable {
    return relay.bind(to: observer)
}

@discardableResult
public func ~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    return relay.bind(to: property)
}

@discardableResult
public func ~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    return property.bind(to: relay)
}

/// ControlEvent
@discardableResult
public func ~><T>(event: ControlEvent<T>, relay: BehaviorRelay<T>) -> Disposable {
    return event.bind(to: relay)
}

// MARK: - Add to dispose bag shorthand

precedencegroup DisposablePrecedence {
    lowerThan: DefaultPrecedence
}

infix operator =>: DisposablePrecedence

@discardableResult
public func =>(disposable: Disposable, bag: DisposeBag) -> Disposable {
    disposable.disposed(by: bag)
    return disposable
}

public func =>(disposable: Disposable?, bag: DisposeBag?) {
    if let dispose = disposable, let disposeBag = bag {
        dispose.disposed(by: disposeBag)
    }
}
