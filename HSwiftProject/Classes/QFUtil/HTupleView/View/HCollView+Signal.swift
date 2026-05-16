//
//  HCollView+Signal.swift
//  HSwiftProject
//
//  Created by owner on 2025/4/6.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

extension HCollView {
    /// HCollView 持有的信号闭包
    var signalBlock: HCollCellSignalBlock? {
        get { return objc_getAssociatedObject(self, kCollSignalKey) as? HCollCellSignalBlock }
        set { objc_setAssociatedObject(self, kCollSignalKey, newValue, .OBJC_ASSOCIATION_COPY) }
    }

    /// 向 HCollView 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - completion: 发送完成后的回调
    func signalToCollView(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        guard let signalBlock = signalBlock else { 
            completion()
            return 
        }
        signalBlock(self, signal)
        completion()
    }

    /// 向所有 item 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - completion: 发送完成后的回调
    func signalToAllItems(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { 
                DispatchQueue.main.async { completion() }
                return 
            }
            
            self.allReuseCells.cache.values.forEach { weakCell in
            if let cell = weakCell.value.value {
                DispatchQueue.main.async { [weak cell] in
                    if let cell = cell {
                        cell.signalBlock?(cell, signal)
                    }
                }
            }
        }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    /// 向指定 section 的所有 item 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - section: 目标 section
    ///   - completion: 发送完成后的回调
    func signal(_ signal: HCollSignal?, itemSection section: Int, _ completion: @escaping () -> Void) {
        let items = numberOfItems(inSection: section)
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            
            DispatchQueue.concurrentPerform(iterations: items) { [weak self] i in
                guard let self = self else { return }
                
                let weakCell = self.allReuseCells.get(IndexPath.stringValue(i, section))
                if let cell = weakCell?.value {
                    DispatchQueue.main.async(group: group) { [weak cell] in
                        if let cell = cell {
                            cell.signalBlock?(cell, signal)
                        }
                    }
                }
            }
            
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    /// 向指定的 item 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - row: 目标 row
    ///   - section: 目标 section
    ///   - completion: 发送完成后的回调
    func signal(_ signal: HCollSignal?, toRow row: Int, inSection section: Int, _ completion: @escaping () -> Void) {
        guard let cell = allReuseCells.get(IndexPath.stringValue(row, section))?.value else {
            completion()
            return
        }
        cell.signalBlock?(cell, signal)
        completion()
    }

    /// 向所有 header 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - completion: 发送完成后的回调
    func signalToAllHeader(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        let sections = numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            
            DispatchQueue.concurrentPerform(iterations: sections) { [weak self] i in
                guard let self = self else { return }
                
                let weakHeader = self.allReuseHeaders.get(IndexPath.stringValue(0, i))
                if let header = weakHeader?.value {
                    DispatchQueue.main.async(group: group) { [weak header] in
                        if let header = header {
                            header.signalBlock?(header, signal)
                        }
                    }
                }
            }
            
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    /// 向指定 section 的 header 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - section: 目标 section
    ///   - completion: 发送完成后的回调
    func signal(_ signal: HCollSignal?, headerSection section: Int, _ completion: @escaping () -> Void) {
        guard let header = allReuseHeaders.get(IndexPath.stringValue(0, section))?.value else {
            completion()
            return
        }
        header.signalBlock?(header, signal)
        completion()
    }

    /// 向所有 footer 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - completion: 发送完成后的回调
    func signalToAllFooter(_ signal: HCollSignal?, _ completion: @escaping () -> Void) {
        let sections = numberOfSections
        DispatchQueue.global(qos: .userInteractive).async {
            let group = DispatchGroup()
            
            DispatchQueue.concurrentPerform(iterations: sections) { [weak self] i in
                guard let self = self else { return }
                
                let weakFooter = self.allReuseFooters.get(IndexPath.stringValue(0, i))
                if let footer = weakFooter?.value {
                    DispatchQueue.main.async(group: group) { [weak footer] in
                        if let footer = footer {
                            footer.signalBlock?(footer, signal)
                        }
                    }
                }
            }
            
            group.wait()
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    /// 向指定 section 的 footer 发送信号
    /// - Parameters:
    ///   - signal: 要发送的信号
    ///   - section: 目标 section
    ///   - completion: 发送完成后的回调
    func signal(_ signal: HCollSignal?, footerSection section: Int, _ completion: @escaping () -> Void) {
        guard let footer = allReuseFooters.get(IndexPath.stringValue(0, section))?.value else {
            completion()
            return
        }
        footer.signalBlock?(footer, signal)
        completion()
    }

    /// 释放所有信号闭包
    func releaseAllSignal() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            
            // 释放 HCollView 自身的信号闭包
            self.signalBlock = nil
            
            // 释放所有 cell 的信号闭包
            self.allReuseCells.cache.values.forEach {
                $0.value.value?.signalBlock = nil
                $0.value.value?.selectBlock = nil
                $0.value.value?.willDisplayBlock = nil
            }
            
            // 释放所有 header 的信号闭包
            self.allReuseHeaders.cache.values.forEach {
                $0.value.value?.signalBlock = nil
            }
            
            // 释放所有 footer 的信号闭包
            self.allReuseFooters.cache.values.forEach {
                $0.value.value?.signalBlock = nil
            }
        }
    }

    /// 根据指定的 row 和 section 获取 cell
    /// - Parameters:
    ///   - row: 目标 row
    ///   - section: 目标 section
    /// - Returns: 对应的 cell 实例
    func cell(_ row: Int, _ section: Int) -> AnyObject? {
        return allReuseCells.get(IndexPath.stringValue(row, section))?.value
    }
    
    /// 根据 indexPath 获取 cell
    /// - Parameter indexPath: 目标 indexPath
    /// - Returns: 对应的 cell 实例
    func cell(for indexPath: IndexPath) -> AnyObject? {
        return allReuseCells.get("\(indexPath.section)-\(indexPath.row)")?.value
    }
    
    /// 根据 section 获取 header
    /// - Parameter section: 目标 section
    /// - Returns: 对应的 header 实例
    func header(for section: Int) -> AnyObject? {
        return allReuseHeaders.get(IndexPath.stringValue(0, section))?.value
    }
    
    /// 根据 section 获取 footer
    /// - Parameter section: 目标 section
    /// - Returns: 对应的 footer 实例
    func footer(for section: Int) -> AnyObject? {
        return allReuseFooters.get(IndexPath.stringValue(0, section))?.value
    }

    /// 获取指定 section 的宽度
    /// - Parameter section: section 索引
    /// - Returns: section 的宽度
    func width(forSection section: Int) -> CGFloat {
        var width: CGFloat = self.bounds.width
        let edgeInsetsString = self.allSectionInsets["\(section)"]
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            width -= edgeInsets.left + edgeInsets.right
            width = max(width, 0) // Ensure width is not less than 0
        }
        return width
    }

    /// 获取指定 section 的高度
    /// - Parameter section: section 索引
    /// - Returns: section 的高度
    func height(forSection section: Int) -> CGFloat {
        var height: CGFloat = self.bounds.height
        let edgeInsetsString = self.allSectionInsets["\(section)"]
        if let edgeInsetsString = edgeInsetsString, !edgeInsetsString.isEmpty {
            let edgeInsets = UIEdgeInsetsFromString(edgeInsetsString)
            height -= edgeInsets.top + edgeInsets.bottom
            height = max(height, 0) // Ensure height is not less than 0
        }
        return height
    }

}
