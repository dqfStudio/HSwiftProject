//
//  HCollView+TemplateMarket.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 模板市场扩展
///
/// 提供各种布局和交互模板，方便用户快速使用
extension HCollView {
    
    /// 模板市场管理器
    class TemplateMarketManager {
        
        // MARK: - 单例
        static let shared = TemplateMarketManager()
        private init() {}
        
        // MARK: - 方法
        
        /// 获取模板列表
        /// - Returns: 模板列表
        func getTemplates() -> [HCollViewTemplate] {
            return [
                getGridTemplate(),
                getWaterfallTemplate(),
                getTimelineTemplate(),
                getCardTemplate(),
                getMasonryTemplate(),
                getHorizontalScrollTemplate(),
                getVerticalScrollTemplate(),
                getDragDropTemplate(),
                getSwipeActionsTemplate(),
                getMultiSelectTemplate()
            ]
        }
        
        /// 获取网格布局模板
        /// - Returns: 网格布局模板
        func getGridTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "网格布局",
                description: "标准的网格布局，适合展示图片、商品等内容",
                layout: .grid,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.grid, configuration: ["columns": 3, "itemSize": CGSize(width: 100, height: 100), "spacing": 10])
            }
            
            return template
        }
        
        /// 获取瀑布流布局模板
        /// - Returns: 瀑布流布局模板
        func getWaterfallTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "瀑布流布局",
                description: "瀑布流布局，适合展示不同高度的内容",
                layout: .waterfall,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.waterfall, configuration: ["columns": 2, "spacing": 10])
            }
            
            return template
        }
        
        /// 获取时间线布局模板
        /// - Returns: 时间线布局模板
        func getTimelineTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "时间线布局",
                description: "时间线布局，适合展示按时间顺序排列的内容",
                layout: .timeline,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.timeline, configuration: ["lineColor": UIColor.gray, "lineWidth": 2, "spacing": 20])
            }
            
            return template
        }
        
        /// 获取卡片布局模板
        /// - Returns: 卡片布局模板
        func getCardTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "卡片布局",
                description: "卡片布局，适合展示独立的内容块",
                layout: .card,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.card, configuration: ["cornerRadius": 8, "shadowColor": UIColor.black, "shadowOffset": CGSize(width: 0, height: 2), "shadowRadius": 4, "shadowOpacity": 0.2, "spacing": 15])
            }
            
            return template
        }
        
        /// 获取 Masonry 布局模板
        /// - Returns: Masonry 布局模板
        func getMasonryTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "Masonry 布局",
                description: "Masonry 布局，适合展示图片墙等内容",
                layout: .masonry,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.masonry, configuration: ["columns": 3, "spacing": 5])
            }
            
            return template
        }
        
        /// 获取水平滚动布局模板
        /// - Returns: 水平滚动布局模板
        func getHorizontalScrollTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "水平滚动布局",
                description: "水平滚动布局，适合展示横向列表",
                layout: .horizontal,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.horizontal, configuration: ["itemSize": CGSize(width: 150, height: 100), "spacing": 10])
            }
            
            return template
        }
        
        /// 获取垂直滚动布局模板
        /// - Returns: 垂直滚动布局模板
        func getVerticalScrollTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "垂直滚动布局",
                description: "垂直滚动布局，适合展示纵向列表",
                layout: .vertical,
                interactionMode: .normal
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.vertical, configuration: ["itemSize": CGSize(width: 300, height: 100), "spacing": 10])
            }
            
            return template
        }
        
        /// 获取拖拽排序模板
        /// - Returns: 拖拽排序模板
        func getDragDropTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "拖拽排序",
                description: "支持拖拽排序的布局",
                layout: .flow,
                interactionMode: .dragDrop
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.flow, configuration: ["itemSize": CGSize(width: 100, height: 100), "spacing": 10])
                hCollView.enableDragDrop()
            }
            
            return template
        }
        
        /// 获取滑动操作模板
        /// - Returns: 滑动操作模板
        func getSwipeActionsTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "滑动操作",
                description: "支持滑动操作的布局",
                layout: .flow,
                interactionMode: .swipe
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.flow, configuration: ["itemSize": CGSize(width: 300, height: 100), "spacing": 10])
                hCollView.addSwipeActions {
                    [
                        UIContextualAction(style: .destructive, title: "删除") { (action, view, completion) in
                            // 处理删除操作
                            completion(true)
                        },
                        UIContextualAction(style: .normal, title: "编辑") { (action, view, completion) in
                            // 处理编辑操作
                            completion(true)
                        }
                    ]
                }
            }
            
            return template
        }
        
        /// 获取多选模式模板
        /// - Returns: 多选模式模板
        func getMultiSelectTemplate() -> HCollViewTemplate {
            let template = HCollViewTemplate(
                name: "多选模式",
                description: "支持多选的布局",
                layout: .grid,
                interactionMode: .multiSelect
            )
            
            // 配置模板
            template.configure {
                hCollView in
                hCollView.setLayout(.grid, configuration: ["columns": 3, "itemSize": CGSize(width: 100, height: 100), "spacing": 10])
                hCollView.setInteractionMode(.multiSelect)
            }
            
            return template
        }
        
        /// 根据名称获取模板
        /// - Parameter name: 模板名称
        /// - Returns: 模板
        func getTemplate(name: String) -> HCollViewTemplate? {
            return getTemplates().first { $0.name == name }
        }
    }
    
    /// 模板市场管理器
    var templateMarketManager: TemplateMarketManager {
        return TemplateMarketManager.shared
    }
    
    /// 获取模板列表
    /// - Returns: 模板列表
    func getTemplates() -> [HCollViewTemplate] {
        return templateMarketManager.getTemplates()
    }
    
    /// 根据名称获取模板
    /// - Parameter name: 模板名称
    /// - Returns: 模板
    func getTemplate(name: String) -> HCollViewTemplate? {
        return templateMarketManager.getTemplate(name: name)
    }
    
    /// 应用模板
    /// - Parameter template: 模板
    func applyTemplate(_ template: HCollViewTemplate) {
        template.apply(to: self)
    }
    
    /// 应用模板（通过名称）
    /// - Parameter name: 模板名称
    func applyTemplate(name: String) {
        if let template = getTemplate(name: name) {
            applyTemplate(template)
        }
    }
}

/// HCollView 模板
class HCollViewTemplate {
    
    // MARK: - 属性
    
    /// 模板名称
    let name: String
    
    /// 模板描述
    let description: String
    
    /// 模板布局
    let layout: LayoutType
    
    /// 模板交互模式
    let interactionMode: InteractionMode
    
    /// 配置闭包
    private var configuration: ((HCollView) -> Void)?
    
    // MARK: - 初始化
    
    /// 初始化
    /// - Parameters:
    ///   - name: 模板名称
    ///   - description: 模板描述
    ///   - layout: 模板布局
    ///   - interactionMode: 模板交互模式
    init(name: String, description: String, layout: LayoutType, interactionMode: InteractionMode) {
        self.name = name
        self.description = description
        self.layout = layout
        self.interactionMode = interactionMode
    }
    
    // MARK: - 方法
    
    /// 配置模板
    /// - Parameter configuration: 配置闭包
    func configure(_ configuration: @escaping (HCollView) -> Void) {
        self.configuration = configuration
    }
    
    /// 应用模板
    /// - Parameter hCollView: 集合视图
    func apply(to hCollView: HCollView) {
        // 设置布局
        hCollView.setLayout(layout)
        
        // 设置交互模式
        hCollView.setInteractionMode(interactionMode)
        
        // 执行配置
        configuration?(hCollView)
    }
    
    /// 获取模板信息
    /// - Returns: 模板信息
    func getInfo() -> String {
        var info = "# \(name)\n\n"
        info += "## 描述\n\(description)\n\n"
        info += "## 布局\n\(layout)\n\n"
        info += "## 交互模式\n\(interactionMode)"
        return info
    }
}
