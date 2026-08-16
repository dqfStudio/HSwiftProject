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
/// UI 侧 skip(1)，避免 ControlProperty 订阅时的当前值把 Relay 盖掉并形成回环。
@discardableResult
public func <~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    bidirectionalBind(property: property, relay: relay)
}

@discardableResult
public func <~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    bidirectionalBind(property: property, relay: relay)
}

@discardableResult
public func <~><T: Equatable>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    bidirectionalBindEquatable(property: property, relay: relay)
}

@discardableResult
public func <~><T: Equatable>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    bidirectionalBindEquatable(property: property, relay: relay)
}

private func bidirectionalBind<T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUI = relay.bind(to: property)
    let bindToRelay = property
        .skip(1)
        .subscribe(onNext: { relay.accept($0) })
    return Disposables.create(bindToUI, bindToRelay)
}

private func bidirectionalBindEquatable<T: Equatable>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUI = relay.bind(to: property)
    let bindToRelay = property
        .skip(1)
        .distinctUntilChanged()
        .subscribe(onNext: { newValue in
            if relay.value != newValue {
                relay.accept(newValue)
            }
        })
    return Disposables.create(bindToUI, bindToRelay)
}

// MARK: - One way binding shorthand

infix operator ~>: DefaultPrecedence

/// Observable
@available(*, deprecated, message: "Use explicit overloads (to Binder/Relay/ControlProperty) to avoid ambiguous type inference.")
@discardableResult
public func ~><T, R>(source: Observable<T>, binder: (Observable<T>) -> R) -> R {
    source.bind(to: binder)
}

@discardableResult
public func ~><T>(source: Observable<T>, binder: Binder<T>) -> Disposable {
    source.bind(to: binder)
}

@discardableResult
public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T>) -> Disposable {
    source.bind(to: relay)
}

@discardableResult
public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T?>) -> Disposable {
    source.bind(to: relay)
}

@discardableResult
public func ~><T>(source: BehaviorRelay<T>, relay: BehaviorRelay<T?>) -> Disposable {
    source.bind(to: relay)
}

@discardableResult
public func ~><T>(source: BehaviorRelay<T>, relay: BehaviorRelay<T>) -> Disposable {
    source.bind(to: relay)
}

/// Single
@discardableResult
public func ~><T>(source: Single<T>, relay: BehaviorRelay<T?>) -> Disposable {
    source.subscribe(onSuccess: relay.accept)
}

/// Driver
@discardableResult
public func ~><T>(source: Driver<T>, relay: BehaviorRelay<T?>) -> Disposable {
    source.drive(onNext: relay.accept)
}

@discardableResult
public func ~><T>(source: Driver<T>, binder: Binder<T>) -> Disposable {
    source.drive(binder)
}

@discardableResult
public func ~><T>(source: Observable<T>, property: ControlProperty<T>) -> Disposable {
    source.bind(to: property)
}

/// BehaviorRelay
@discardableResult
public func ~><T>(relay: BehaviorRelay<T>, observer: Binder<T>) -> Disposable {
    relay.bind(to: observer)
}

@discardableResult
public func ~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    relay.bind(to: property)
}

@discardableResult
public func ~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    property.bind(to: relay)
}

/// ControlEvent
@discardableResult
public func ~><T>(event: ControlEvent<T>, relay: BehaviorRelay<T>) -> Disposable {
    event.bind(to: relay)
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
    guard let disposable else { return }
    guard let bag else {
        assertionFailure("DisposeBag is nil, subscription will leak")
        return
    }
    disposable.disposed(by: bag)
}
