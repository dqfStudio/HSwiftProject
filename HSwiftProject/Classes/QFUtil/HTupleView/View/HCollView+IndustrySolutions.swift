//
//  HCollView+IndustrySolutions.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit

/// HCollView 行业解决方案扩展
///
/// 提供不同行业的解决方案
extension HCollView {
    
    /// 行业解决方案管理器
    class IndustrySolutionsManager {
        
        // MARK: - 单例
        static let shared = IndustrySolutionsManager()
        private init() {}
        
        // MARK: - 方法
        
        /// 获取电商解决方案
        /// - Returns: 电商解决方案
        func getECommerceSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "电商解决方案",
                description: "为电商应用提供商品展示、分类浏览、购物车等功能的解决方案",
                features: [
                    "商品网格展示",
                    "分类浏览",
                    "商品详情",
                    "购物车集成",
                    "支付流程"
                ],
                layout: .grid,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置网格布局
                hCollView.setLayout(.grid, configuration: ["columns": 2, "itemSize": CGSize(width: 150, height: 200)])
                
                // 添加滑动操作
                hCollView.addSwipeActions {
                    [
                        UIContextualAction(style: .normal, title: "加入购物车") { (action, view, completion) in
                            // 处理加入购物车操作
                            completion(true)
                        }
                    ]
                }
                
                // 启用网络状态适应
                hCollView.enableNetworkStateAdaptation()
            }
            
            return solution
        }
        
        /// 获取新闻解决方案
        /// - Returns: 新闻解决方案
        func getNewsSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "新闻解决方案",
                description: "为新闻应用提供新闻列表、分类浏览、新闻详情等功能的解决方案",
                features: [
                    "新闻列表展示",
                    "分类浏览",
                    "新闻详情",
                    "收藏功能",
                    "分享功能"
                ],
                layout: .timeline,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置时间线布局
                hCollView.setLayout(.timeline, configuration: ["lineColor": UIColor.gray, "lineWidth": 2])
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用网络状态适应
                hCollView.enableNetworkStateAdaptation()
            }
            
            return solution
        }
        
        /// 获取社交媒体解决方案
        /// - Returns: 社交媒体解决方案
        func getSocialMediaSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "社交媒体解决方案",
                description: "为社交媒体应用提供动态列表、用户资料、评论等功能的解决方案",
                features: [
                    "动态列表展示",
                    "用户资料",
                    "评论功能",
                    "点赞功能",
                    "分享功能"
                ],
                layout: .card,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置卡片布局
                hCollView.setLayout(.card, configuration: ["cornerRadius": 8, "shadowColor": UIColor.black, "shadowOffset": CGSize(width: 0, height: 2), "shadowRadius": 4, "shadowOpacity": 0.2])
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用网络状态适应
                hCollView.enableNetworkStateAdaptation()
            }
            
            return solution
        }
        
        /// 获取图片库解决方案
        /// - Returns: 图片库解决方案
        func getPhotoGallerySolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "图片库解决方案",
                description: "为图片库应用提供图片网格展示、图片详情、相册管理等功能的解决方案",
                features: [
                    "图片网格展示",
                    "图片详情",
                    "相册管理",
                    "图片编辑",
                    "分享功能"
                ],
                layout: .masonry,
                interactionMode: .multiSelect
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置 Masonry 布局
                hCollView.setLayout(.masonry, configuration: ["columns": 3, "spacing": 10])
                
                // 启用多选模式
                hCollView.setInteractionMode(.multiSelect)
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用内存监控
                hCollView.enableMemoryMonitoring()
            }
            
            return solution
        }
        
        /// 获取视频应用解决方案
        /// - Returns: 视频应用解决方案
        func getVideoAppSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "视频应用解决方案",
                description: "为视频应用提供视频列表、视频详情、播放功能等的解决方案",
                features: [
                    "视频列表展示",
                    "视频详情",
                    "播放功能",
                    "评论功能",
                    "分享功能"
                ],
                layout: .card,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置卡片布局
                hCollView.setLayout(.card, configuration: ["cornerRadius": 8, "shadowColor": UIColor.black, "shadowOffset": CGSize(width: 0, height: 2), "shadowRadius": 4, "shadowOpacity": 0.2])
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用网络状态适应
                hCollView.enableNetworkStateAdaptation()
            }
            
            return solution
        }
        
        /// 获取企业应用解决方案
        /// - Returns: 企业应用解决方案
        func getEnterpriseAppSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "企业应用解决方案",
                description: "为企业应用提供数据展示、报表分析、任务管理等功能的解决方案",
                features: [
                    "数据展示",
                    "报表分析",
                    "任务管理",
                    "审批流程",
                    "消息通知"
                ],
                layout: .flow,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置流式布局
                hCollView.setLayout(.flow, configuration: ["itemSize": CGSize(width: 300, height: 100)])
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用内存监控
                hCollView.enableMemoryMonitoring()
            }
            
            return solution
        }
        
        /// 获取教育应用解决方案
        /// - Returns: 教育应用解决方案
        func getEducationAppSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "教育应用解决方案",
                description: "为教育应用提供课程列表、学习进度、考试管理等功能的解决方案",
                features: [
                    "课程列表展示",
                    "学习进度",
                    "考试管理",
                    "作业提交",
                    "成绩查询"
                ],
                layout: .timeline,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置时间线布局
                hCollView.setLayout(.timeline, configuration: ["lineColor": UIColor.gray, "lineWidth": 2])
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用网络状态适应
                hCollView.enableNetworkStateAdaptation()
            }
            
            return solution
        }
        
        /// 获取医疗应用解决方案
        /// - Returns: 医疗应用解决方案
        func getMedicalAppSolution() -> HCollViewSolution {
            let solution = HCollViewSolution(
                name: "医疗应用解决方案",
                description: "为医疗应用提供患者信息、预约管理、健康记录等功能的解决方案",
                features: [
                    "患者信息管理",
                    "预约管理",
                    "健康记录",
                    "药品管理",
                    "医生咨询"
                ],
                layout: .flow,
                interactionMode: .normal
            )
            
            // 配置解决方案
            solution.configure {
                hCollView in
                // 设置流式布局
                hCollView.setLayout(.flow, configuration: ["itemSize": CGSize(width: 300, height: 100)])
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 启用内存监控
                hCollView.enableMemoryMonitoring()
            }
            
            return solution
        }
    }
    
    /// 行业解决方案管理器
    var industrySolutionsManager: IndustrySolutionsManager {
        return IndustrySolutionsManager.shared
    }
    
    /// 获取电商解决方案
    /// - Returns: 电商解决方案
    func getECommerceSolution() -> HCollViewSolution {
        return industrySolutionsManager.getECommerceSolution()
    }
    
    /// 获取新闻解决方案
    /// - Returns: 新闻解决方案
    func getNewsSolution() -> HCollViewSolution {
        return industrySolutionsManager.getNewsSolution()
    }
    
    /// 获取社交媒体解决方案
    /// - Returns: 社交媒体解决方案
    func getSocialMediaSolution() -> HCollViewSolution {
        return industrySolutionsManager.getSocialMediaSolution()
    }
    
    /// 获取图片库解决方案
    /// - Returns: 图片库解决方案
    func getPhotoGallerySolution() -> HCollViewSolution {
        return industrySolutionsManager.getPhotoGallerySolution()
    }
    
    /// 获取视频应用解决方案
    /// - Returns: 视频应用解决方案
    func getVideoAppSolution() -> HCollViewSolution {
        return industrySolutionsManager.getVideoAppSolution()
    }
    
    /// 获取企业应用解决方案
    /// - Returns: 企业应用解决方案
    func getEnterpriseAppSolution() -> HCollViewSolution {
        return industrySolutionsManager.getEnterpriseAppSolution()
    }
    
    /// 获取教育应用解决方案
    /// - Returns: 教育应用解决方案
    func getEducationAppSolution() -> HCollViewSolution {
        return industrySolutionsManager.getEducationAppSolution()
    }
    
    /// 获取医疗应用解决方案
    /// - Returns: 医疗应用解决方案
    func getMedicalAppSolution() -> HCollViewSolution {
        return industrySolutionsManager.getMedicalAppSolution()
    }
    
    /// 应用解决方案
    /// - Parameter solution: 解决方案
    func applySolution(_ solution: HCollViewSolution) {
        solution.apply(to: self)
    }
}

/// HCollView 解决方案
class HCollViewSolution {
    
    // MARK: - 属性
    
    /// 解决方案名称
    let name: String
    
    /// 解决方案描述
    let description: String
    
    /// 解决方案特性
    let features: [String]
    
    /// 推荐布局
    let recommendedLayout: LayoutType
    
    /// 推荐交互模式
    let recommendedInteractionMode: InteractionMode
    
    /// 配置闭包
    private var configuration: ((HCollView) -> Void)?
    
    // MARK: - 初始化
    
    /// 初始化
    /// - Parameters:
    ///   - name: 解决方案名称
    ///   - description: 解决方案描述
    ///   - features: 解决方案特性
    ///   - layout: 推荐布局
    ///   - interactionMode: 推荐交互模式
    init(name: String, description: String, features: [String], layout: LayoutType, interactionMode: InteractionMode) {
        self.name = name
        self.description = description
        self.features = features
        self.recommendedLayout = layout
        self.recommendedInteractionMode = interactionMode
    }
    
    // MARK: - 方法
    
    /// 配置解决方案
    /// - Parameter configuration: 配置闭包
    func configure(_ configuration: @escaping (HCollView) -> Void) {
        self.configuration = configuration
    }
    
    /// 应用解决方案
    /// - Parameter hCollView: 集合视图
    func apply(to hCollView: HCollView) {
        // 设置推荐布局
        hCollView.setLayout(recommendedLayout)
        
        // 设置推荐交互模式
        hCollView.setInteractionMode(recommendedInteractionMode)
        
        // 执行配置
        configuration?(hCollView)
    }
    
    /// 获取解决方案信息
    /// - Returns: 解决方案信息
    func getInfo() -> String {
        var info = "# \(name)\n\n"
        info += "## 描述\n\(description)\n\n"
        info += "## 特性\n"
        for feature in features {
            info += "- \(feature)\n"
        }
        info += "\n"
        info += "## 推荐布局\n\(recommendedLayout)\n\n"
        info += "## 推荐交互模式\n\(recommendedInteractionMode)"
        return info
    }
}
