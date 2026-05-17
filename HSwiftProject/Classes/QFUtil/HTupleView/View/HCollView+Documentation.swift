//
//  HCollView+Documentation.swift
//  HSwiftProject
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

import UIKit
import Alamofire

/// HCollView 文档与示例扩展
///
/// 提供详细的文档和使用示例，包括给开发者和AI系统的结构化文档
///
/// - Note: 本扩展包含完整的API文档、使用指南、示例代码和常见问题解答
/// - Version: 1.0.0
/// - LastUpdated: 2026-04-19
/// - Author: HSwiftProject Team
///
/// HCollView 是一个功能强大的集合视图扩展，提供了丰富的布局类型、交互模式和性能优化功能。
/// 本文档旨在帮助开发者快速了解和使用 HCollView 的所有功能，同时也为 AI 系统提供结构化的文档信息。
extension HCollView {
    
    /// 文档管理器
    ///
    /// 提供全面的文档和使用示例，帮助开发者快速上手HCollView
    ///
    /// - Note: 文档管理器采用单例模式，确保全局只有一个实例
    /// - Version: 1.0.0
    ///
    /// 文档管理器负责管理 HCollView 的所有文档内容，包括使用指南、API文档、示例代码和常见问题解答。
    class DocumentationManager {
        
        // MARK: - 单例
        /// 文档管理器单例
        static let shared = DocumentationManager()
        private init() {}
        
        // MARK: - 方法
        
        /// 获取使用指南
        ///
        /// 提供 HCollView 的详细使用指南，包含基本用法和高级用法
        ///
        /// - Returns: 详细的使用指南，包含基本用法和高级用法
        /// - Version: 1.0.0
        ///
        /// 使用指南包括 HCollView 的创建、布局设置、交互模式设置、内容加载、性能优化等方面的详细说明和示例代码。
        func getUsageGuide() -> String {
            return """
            # HCollView 使用指南
            
            ## 1. 基本用法
            
            ### 1.1 创建 HCollView
            ```swift
            // 创建 HCollView 实例
            let hCollView = HCollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
            hCollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(hCollView)
            
            // 设置代理
            hCollView.delegate = self
            ```
            
            ### 1.2 设置布局
            ```swift
            // 设置流式布局
            hCollView.setLayout(.flow, configuration: ["itemSize": CGSize(width: 100, height: 100)])
            
            // 设置网格布局
            hCollView.setLayout(.grid, configuration: ["columns": 3, "itemSize": CGSize(width: 100, height: 100)])
            
            // 设置瀑布流布局
            hCollView.setLayout(.waterfall, configuration: ["columns": 2, "spacing": 10])
            
            // 设置时间线布局
            hCollView.setLayout(.timeline, configuration: ["lineColor": UIColor.gray, "lineWidth": 2])
            
            // 设置卡片布局
            hCollView.setLayout(.card, configuration: ["cornerRadius": 8, "shadowColor": UIColor.black, "shadowOffset": CGSize(width: 0, height: 2), "shadowRadius": 4, "shadowOpacity": 0.2])
            ```
            
            ### 1.3 设置交互模式
            ```swift
            // 启用拖拽排序
            hCollView.enableDragDrop()
            
            // 添加滑动操作
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
            
            // 启用多选模式
            hCollView.setInteractionMode(.multiSelect)
            
            // 全选
            hCollView.selectAll()
            
            // 取消全选
            hCollView.deselectAll()
            ```
            
            ### 1.4 加载内容
            ```swift
            // 加载图片
            hCollView.loadImage(from: URL(string: "https://example.com/image.jpg")) { image in
                if let image = image {
                    // 处理图片
                    print("图片加载成功: image.size")
                } else {
                    print("图片加载失败")
                }
            }
            
            // 发送网络请求
            hCollView.sendRequest("https://example.com/api/data") { data, error in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("网络请求成功: json")
                    } catch {
                        print("网络请求失败: error")
                    }
                } else if let error = error {
                    print("网络请求失败: error")
                }
            }
            ```
            
            ### 1.5 性能优化
            ```swift
            // 优化启动性能
            hCollView.optimizeStartupPerformance()
            
            // 启用内存监控
            hCollView.enableMemoryMonitoring()
            
            // 启用网络状态适应
            hCollView.enableNetworkStateAdaptation()
            
            // 启用懒加载
            hCollView.enableLazyLoading()
            
            // 启用预加载
            hCollView.enablePreloading()
            ```
            
            ## 2. 高级用法
            
            ### 2.1 自定义布局
            ```swift
            // 创建自定义布局
            let customLayout = UICollectionViewFlowLayout()
            customLayout.itemSize = CGSize(width: 150, height: 200)
            customLayout.minimumLineSpacing = 10
            customLayout.minimumInteritemSpacing = 10
            customLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            // 设置自定义布局
            hCollView.setLayout(.custom, configuration: ["layout": customLayout])
            ```
            
            ### 2.2 自定义交互
            ```swift
            // 设置自定义交互模式
            hCollView.setInteractionMode(.custom) {
                // 处理自定义交互
                print("自定义交互模式已启用")
            }
            ```
            
            ### 2.3 内容预加载
            ```swift
            // 预加载内容
            hCollView.preloadContent(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)]) {
                indexPath in
                // 预加载逻辑
                print("预加载索引路径: indexPath")
            }
            ```
            
            ### 2.4 错误处理
            ```swift
            // 启用崩溃防护
            hCollView.enableCrashProtection()
            
            // 处理错误
            hCollView.handleError(NSError(domain: "ExampleError", code: 1, userInfo: nil), message: "加载失败")
            
            // 监控异常
            hCollView.monitorException {
                // 可能抛出异常的代码
                print("执行可能抛出异常的代码")
            }
            ```
            
            ### 2.5 扩展性
            ```swift
            // 注册插件
            let examplePlugin = ExamplePlugin()
            hCollView.registerPlugin(examplePlugin, forKey: "examplePlugin")
            
            // 设置主题
            hCollView.setTheme(DarkTheme())
            
            // 设置语言
            hCollView.setLanguage("en-US")
            
            // 获取国际化字符串
            let loadingText = hCollView.getLocalizedString("loading")
            print("加载文本: loadingText")
            ```
            
            ### 2.6 行业解决方案
            ```swift
            // 应用电商解决方案
            let ecommerceSolution = hCollView.getECommerceSolution()
            hCollView.applySolution(ecommerceSolution)
            
            // 应用新闻解决方案
            let newsSolution = hCollView.getNewsSolution()
            hCollView.applySolution(newsSolution)
            ```
            
            ### 2.7 模板市场
            ```swift
            // 应用网格布局模板
            hCollView.applyTemplate(name: "网格布局")
            
            // 应用拖拽排序模板
            hCollView.applyTemplate(name: "拖拽排序")
            ```
            """
        }
        
        /// 获取 API 文档
        ///
        /// 提供 HCollView 的详细 API 文档，包含所有方法和属性的说明
        ///
        /// - Returns: 详细的 API 文档，包含所有方法和属性的说明
        /// - Version: 1.0.0
        ///
        /// API 文档包括 HCollView 的所有方法的签名、参数说明、返回值、功能描述和使用场景。
        func getAPIDocumentation() -> String {
            return """
            # HCollView API 文档
            
            ## 1. 布局系统
            
            ### 1.1 布局类型
            - `flow`: 流式布局
            - `grid`: 网格布局
            - `waterfall`: 瀑布流布局
            - `masonry`: Masonry 布局
            - `timeline`: 时间线布局
            - `card`: 卡片布局
            - `horizontal`: 水平滚动布局
            - `vertical`: 垂直滚动布局
            - `custom`: 自定义布局
            
            ### 1.2 布局方法
            
            #### setLayout
            ```swift
            func setLayout(_ type: LayoutType, configuration: [String: Any] = [:], animated: Bool = true)
            ```
            - **参数**:
              - `type`: 布局类型，支持 flow、grid、waterfall、masonry、timeline、card、horizontal、vertical、custom 等多种布局类型
              - `configuration`: 布局配置，不同布局类型支持不同的配置项
                - `flow`: `itemSize` (CGSize), `minimumLineSpacing` (CGFloat), `minimumInteritemSpacing` (CGFloat), `sectionInset` (UIEdgeInsets)
                - `grid`: `columns` (Int), `itemSize` (CGSize), `spacing` (CGFloat)
                - `waterfall`: `columns` (Int), `spacing` (CGFloat)
                - `masonry`: `columns` (Int), `spacing` (CGFloat)
                - `timeline`: `lineColor` (UIColor), `lineWidth` (CGFloat), `spacing` (CGFloat)
                - `card`: `cornerRadius` (CGFloat), `shadowColor` (UIColor), `shadowOffset` (CGSize), `shadowRadius` (CGFloat), `shadowOpacity` (Float), `spacing` (CGFloat)
                - `horizontal`: `itemSize` (CGSize), `spacing` (CGFloat)
                - `vertical`: `itemSize` (CGSize), `spacing` (CGFloat)
                - `custom`: `layout` (UICollectionViewLayout)
              - `animated`: 是否使用动画，默认为 true
            - **功能**: 设置集合视图的布局，支持动态切换不同类型的布局
            - **使用场景**: 当需要根据不同的内容类型或用户偏好切换布局时使用
            
            #### switchLayout
            ```swift
            func switchLayout(_ type: LayoutType, configuration: [String: Any] = [:], animated: Bool = true)
            ```
            - **参数**:
              - `type`: 布局类型，支持 flow、grid、waterfall、masonry、timeline、card、horizontal、vertical、custom 等多种布局类型
              - `configuration`: 布局配置，不同布局类型支持不同的配置项（与 setLayout 相同）
              - `animated`: 是否使用动画，默认为 true
            - **功能**: 切换集合视图的布局，与 setLayout 功能类似
            - **使用场景**: 当需要在运行时动态切换布局类型时使用
            
            #### getCurrentLayout
            ```swift
            func getCurrentLayout() -> UICollectionViewLayout
            ```
            - **返回值**: 当前的布局对象，类型为 UICollectionViewLayout 或其子类
            - **功能**: 获取当前集合视图的布局对象
            - **使用场景**: 当需要获取当前布局对象进行自定义修改或获取布局属性时使用
            
            ## 2. 交互模式
            
            ### 2.1 交互模式
            - `normal`: 正常模式
            - `selection`: 选择模式
            - `dragDrop`: 拖拽排序模式
            - `swipe`: 滑动操作模式
            - `multiSelect`: 多选模式
            - `custom`: 自定义模式
            
            ### 2.2 交互方法
            
            #### setInteractionMode
            ```swift
            func setInteractionMode(_ mode: InteractionMode, configuration: [String: Any] = [:])
            ```
            - **参数**:
              - `mode`: 交互模式，支持 normal、selection、dragDrop、swipe、multiSelect、custom 等多种交互模式
              - `configuration`: 交互配置，不同交互模式支持不同的配置项
                - `multiSelect`: `allowMultipleSelection` (Bool), `selectionColor` (UIColor)
                - `custom`: `customHandler` (() -> Void)
            - **功能**: 设置集合视图的交互模式，控制用户与集合视图的交互行为
            - **使用场景**: 当需要根据不同的用户操作需求切换交互模式时使用
            
            #### addSwipeActions
            ```swift
            func addSwipeActions(_ actions: @escaping () -> [UIContextualAction])
            ```
            - **参数**:
              - `actions`: 返回滑动操作数组的闭包，每个 UIContextualAction 代表一个滑动操作
            - **功能**: 为集合视图添加滑动操作，支持左滑或右滑显示操作按钮
            - **使用场景**: 当需要为集合视图单元格添加滑动删除、编辑、分享等操作时使用
            
            #### enableDragDrop
            ```swift
            func enableDragDrop()
            ```
            - **功能**: 启用拖拽排序功能，允许用户通过拖拽来重新排列集合视图中的项目
            - **使用场景**: 当需要允许用户自定义项目顺序时使用，如待办事项列表、收藏夹等
            
            #### enableMultiSelect
            ```swift
            func enableMultiSelect()
            ```
            - **功能**: 启用多选模式，允许用户选择多个单元格
            - **使用场景**: 当需要用户选择多个项目进行批量操作时使用，如批量删除、批量分享等
            
            #### selectAll
            ```swift
            func selectAll()
            ```
            - **功能**: 全选所有单元格
            - **使用场景**: 当需要快速选择所有项目时使用，如批量操作前的全选
            
            #### deselectAll
            ```swift
            func deselectAll()
            ```
            - **功能**: 取消全选所有单元格
            - **使用场景**: 当需要清除所有选择时使用，如批量操作完成后
            
            ## 3. 内容展示
            
            ### 3.1 内容类型
            - `text`: 文本
            - `richText`: 富文本
            - `image`: 图片
            - `video`: 视频
            - `audio`: 音频
            - `mixed`: 混合内容
            - `ar`: AR 内容
            - `vr`: VR 内容
            
            ### 3.2 内容方法
            
            #### loadImage
            ```swift
            func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
            ```
            - **参数**:
              - `url`: 图片 URL，指向要加载的图片资源
              - `completion`: 完成回调，返回加载的图片，成功时为 UIImage 对象，失败时为 nil
            - **功能**: 加载图片，支持缓存，提高图片加载效率
            - **使用场景**: 当需要加载网络图片到集合视图单元格时使用
            
            #### loadVideo
            ```swift
            func loadVideo(from url: URL, completion: @escaping (URL?) -> Void)
            ```
            - **参数**:
              - `url`: 视频 URL，指向要加载的视频资源
              - `completion`: 完成回调，返回视频 URL，成功时为本地缓存的视频 URL，失败时为 nil
            - **功能**: 加载视频，支持缓存，提高视频加载效率
            - **使用场景**: 当需要加载网络视频到集合视图单元格时使用
            
            #### createRichText
            ```swift
            func createRichText(from html: String) -> NSAttributedString?
            ```
            - **参数**:
              - `html`: HTML 字符串，包含富文本格式信息
            - **返回值**: 富文本对象，成功时为 NSAttributedString 对象，失败时为 nil
            - **功能**: 从 HTML 字符串创建富文本，支持各种文本格式
            - **使用场景**: 当需要在集合视图中显示富文本内容时使用
            
            #### preloadContent
            ```swift
            func preloadContent(at indexPaths: [IndexPath], contentLoader: @escaping (IndexPath) -> Void)
            ```
            - **参数**:
              - `indexPaths`: 要预加载的索引路径数组，指定需要预加载内容的单元格位置
              - `contentLoader`: 内容加载闭包，接收索引路径作为参数，用于实现具体的预加载逻辑
            - **功能**: 预加载指定索引路径的内容，提高用户体验
            - **使用场景**: 当需要提前加载用户可能即将浏览的内容时使用，如滚动列表时预加载下一批内容
            
            ## 4. 性能优化
            
            ### 4.1 启动性能
            
            #### startStartupTimer
            ```swift
            func startStartupTimer()
            ```
            - **功能**: 开始启动计时，用于测量应用启动时间
            - **使用场景**: 当需要分析应用启动性能时使用
            
            #### endStartupTimer
            ```swift
            func endStartupTimer() -> Double
            ```
            - **返回值**: 启动时间（毫秒），从调用 startStartupTimer 到调用此方法的时间差
            - **功能**: 结束启动计时并返回启动时间
            - **使用场景**: 当需要获取应用启动时间以分析性能时使用
            
            #### optimizeStartupPerformance
            ```swift
            func optimizeStartupPerformance()
            ```
            - **功能**: 优化启动性能，包括延迟加载非关键资源、优化布局计算等
            - **使用场景**: 当需要提高应用启动速度时使用
            
            #### enableLazyLoading
            ```swift
            func enableLazyLoading()
            ```
            - **功能**: 启用懒加载，仅在需要时加载资源
            - **使用场景**: 当需要减少初始加载时间和内存使用时使用
            
            #### enablePreloading
            ```swift
            func enablePreloading()
            ```
            - **功能**: 启用预加载，提前加载可能需要的资源
            - **使用场景**: 当需要提高用户体验，减少用户等待时间时使用
            
            ### 4.2 内存优化
            
            #### startMemoryMonitoring
            ```swift
            func startMemoryMonitoring()
            ```
            - **功能**: 开始内存监控，定期检查应用内存使用情况
            - **使用场景**: 当需要监控应用内存使用，及时发现内存泄漏时使用
            
            #### stopMemoryMonitoring
            ```swift
            func stopMemoryMonitoring()
            ```
            - **功能**: 停止内存监控
            - **使用场景**: 当不需要继续监控内存使用时使用
            
            #### getCurrentMemoryUsage
            ```swift
            func getCurrentMemoryUsage() -> Double
            ```
            - **返回值**: 当前内存使用（MB），返回应用当前的内存使用量
            - **功能**: 获取当前内存使用情况
            - **使用场景**: 当需要检查应用内存使用情况时使用
            
            #### clearMemoryCache
            ```swift
            func clearMemoryCache()
            ```
            - **功能**: 清理内存缓存，释放不必要的内存
            - **使用场景**: 当应用内存使用过高时使用
            
            #### createObjectPool
            ```swift
            func createObjectPool<T>(key: String, creator: @escaping () -> T, capacity: Int = 10)
            ```
            - **参数**:
              - `key`: 对象池键，用于标识不同的对象池
              - `creator`: 对象创建闭包，用于创建新的对象
              - `capacity`: 对象池容量，默认为 10
            - **功能**: 创建对象池，用于复用对象，减少内存分配和释放
            - **使用场景**: 当需要频繁创建和销毁对象时使用，如集合视图单元格
            
            #### getObject
            ```swift
            func getObject<T>(fromPool key: String) -> T?
            ```
            - **参数**:
              - `key`: 对象池键，指定从哪个对象池获取对象
            - **返回值**: 从对象池获取的对象，成功时为泛型 T 对象，失败时为 nil
            - **功能**: 从对象池获取对象
            - **使用场景**: 当需要使用对象时，从对象池获取以减少创建新对象的开销
            
            #### returnObject
            ```swift
            func returnObject<T>(_ object: T, toPool key: String)
            ```
            - **参数**:
              - `object`: 要归还的对象，类型为泛型 T
              - `key`: 对象池键，指定归还到哪个对象池
            - **功能**: 归还对象到对象池，以便复用
            - **使用场景**: 当对象不再使用时，归还到对象池以减少内存开销
            
            ### 4.3 网络优化
            
            #### sendRequest
            ```swift
            func sendRequest(
                _ url: String,
                method: HTTPMethod = .get,
                parameters: [String: Any]? = nil,
                headers: HTTPHeaders? = nil,
                cachePolicy: NetworkOptimizationManager.CachePolicy = .useCacheElseLoad,
                completion: @escaping (Data?, Error?) -> Void
            )
            ```
            - **参数**:
              - `url`: 请求 URL，指向要请求的资源
              - `method`: 请求方法，默认为 .get，支持 .post、.put、.delete 等
              - `parameters`: 请求参数，默认为 nil
              - `headers`: 请求头，默认为 nil
              - `cachePolicy`: 缓存策略，默认为 .useCacheElseLoad，支持 .useCacheElseLoad、.reloadIgnoringCache、.returnCacheDataDontLoad
              - `completion`: 完成回调，返回请求数据和错误信息
            - **功能**: 发送网络请求，支持缓存和离线模式，提高网络请求效率
            - **使用场景**: 当需要从网络获取数据时使用
            
            #### cancelRequest
            ```swift
            func cancelRequest(_ url: String)
            ```
            - **参数**:
              - `url`: 请求 URL，指定要取消的请求
            - **功能**: 取消指定 URL 的请求
            - **使用场景**: 当不再需要某个网络请求的结果时使用
            
            #### cancelAllRequests
            ```swift
            func cancelAllRequests()
            ```
            - **功能**: 取消所有请求
            - **使用场景**: 当需要停止所有正在进行的网络请求时使用，如页面销毁时
            
            #### enableOfflineMode
            ```swift
            func enableOfflineMode()
            ```
            - **功能**: 启用离线模式，使用缓存数据而不发起网络请求
            - **使用场景**: 当网络连接不可用时使用，提高用户体验
            
            #### enableNetworkStateAdaptation
            ```swift
            func enableNetworkStateAdaptation()
            ```
            - **功能**: 启用网络状态适应，根据网络状态自动调整请求策略
            - **使用场景**: 当需要根据网络状态（如 4G/5G/WiFi）自动调整请求行为时使用
            
            #### registerForNetworkStatusChanges
            ```swift
            func registerForNetworkStatusChanges()
            ```
            - **功能**: 注册网络状态变化通知，监听网络状态的变化
            - **使用场景**: 当需要在网络状态变化时执行特定操作时使用
            
            #### unregisterForNetworkStatusChanges
            ```swift
            func unregisterForNetworkStatusChanges()
            ```
            - **功能**: 取消注册网络状态变化通知
            - **使用场景**: 当不再需要监听网络状态变化时使用，如页面销毁时
            
            ## 5. 稳定性
            
            ### 5.1 稳定性方法
            
            #### safeExecute
            ```swift
            func safeExecute<T>(_ block: () throws -> T) -> T?
            ```
            - **参数**:
              - `block`: 可能抛出异常的闭包
            - **返回值**: 闭包执行结果，成功时为泛型 T 对象，失败时为 nil
            - **功能**: 防护执行，捕获并处理异常，防止应用崩溃
            - **使用场景**: 当执行可能抛出异常的代码时使用，如网络请求、文件操作等
            
            #### handleError
            ```swift
            func handleError(_ error: Error, message: String)
            ```
            - **参数**:
              - `error`: 错误对象，包含错误信息
              - `message`: 错误信息，用于显示给用户
            - **功能**: 处理错误，包括错误日志记录和用户提示
            - **使用场景**: 当需要统一处理错误时使用
            
            #### monitorException
            ```swift
            func monitorException(_ block: () -> Void)
            ```
            - **参数**:
              - `block`: 可能抛出异常的闭包
            - **功能**: 监控异常，捕获并记录异常信息
            - **使用场景**: 当需要监控可能抛出异常的代码时使用
            
            #### enableCrashProtection
            ```swift
            func enableCrashProtection()
            ```
            - **功能**: 启用崩溃防护，防止应用因异常而崩溃
            - **使用场景**: 当需要提高应用稳定性时使用
            
            #### disableCrashProtection
            ```swift
            func disableCrashProtection()
            ```
            - **功能**: 禁用崩溃防护
            - **使用场景**: 当需要调试应用，查看原始崩溃信息时使用
            
            #### enableErrorHandling
            ```swift
            func enableErrorHandling()
            ```
            - **功能**: 启用错误处理，统一处理应用中的错误
            - **使用场景**: 当需要统一管理错误处理逻辑时使用
            
            #### disableErrorHandling
            ```swift
            func disableErrorHandling()
            ```
            - **功能**: 禁用错误处理
            - **使用场景**: 当需要自定义错误处理逻辑时使用
            
            #### enableExceptionMonitoring
            ```swift
            func enableExceptionMonitoring()
            ```
            - **功能**: 启用异常监控，实时监控应用中的异常
            - **使用场景**: 当需要监控应用稳定性时使用
            
            #### disableExceptionMonitoring
            ```swift
            func disableExceptionMonitoring()
            ```
            - **功能**: 禁用异常监控
            - **使用场景**: 当不需要继续监控异常时使用
            
            ## 6. 扩展性
            
            ### 6.1 扩展性方法
            
            #### registerPlugin
            ```swift
            func registerPlugin(_ plugin: HCollViewPlugin, forKey key: String)
            ```
            - **参数**:
              - `plugin`: 插件对象，实现了 HCollViewPlugin 协议
              - `key`: 插件键，用于标识插件
            - **功能**: 注册插件，扩展 HCollView 的功能
            - **使用场景**: 当需要为 HCollView 添加自定义功能时使用
            
            #### removePlugin
            ```swift
            func removePlugin(forKey key: String)
            ```
            - **参数**:
              - `key`: 插件键，指定要移除的插件
            - **功能**: 移除插件
            - **使用场景**: 当不再需要某个插件时使用
            
            #### getPlugin
            ```swift
            func getPlugin(forKey key: String) -> HCollViewPlugin?
            ```
            - **参数**:
              - `key`: 插件键，指定要获取的插件
            - **返回值**: 插件对象，成功时为 HCollViewPlugin 对象，失败时为 nil
            - **功能**: 获取插件
            - **使用场景**: 当需要获取已注册的插件进行操作时使用
            
            #### callPlugins
            ```swift
            func callPlugins(method: String, parameters: [Any] = [])
            ```
            - **参数**:
              - `method`: 方法名，指定要调用的插件方法
              - `parameters`: 参数，传递给插件方法的参数
            - **功能**: 调用所有插件的方法
            - **使用场景**: 当需要通知所有插件执行某个操作时使用
            
            #### setTheme
            ```swift
            func setTheme(_ theme: HCollViewTheme)
            ```
            - **参数**:
              - `theme`: 主题对象，实现了 HCollViewTheme 协议
            - **功能**: 设置主题，改变 HCollView 的外观
            - **使用场景**: 当需要切换应用主题时使用
            
            #### getCurrentTheme
            ```swift
            func getCurrentTheme() -> HCollViewTheme
            ```
            - **返回值**: 当前主题对象，类型为 HCollViewTheme
            - **功能**: 获取当前主题
            - **使用场景**: 当需要获取当前主题进行操作时使用
            
            #### setLanguage
            ```swift
            func setLanguage(_ language: String)
            ```
            - **参数**:
              - `language`: 语言代码，如 "zh-CN"、"en-US" 等
            - **功能**: 设置语言，切换应用的语言
            - **使用场景**: 当需要切换应用语言时使用
            
            #### getCurrentLanguage
            ```swift
            func getCurrentLanguage() -> String
            ```
            - **返回值**: 当前语言代码，如 "zh-CN"、"en-US" 等
            - **功能**: 获取当前语言
            - **使用场景**: 当需要获取当前语言进行操作时使用
            
            #### addLocalizedStrings
            ```swift
            func addLocalizedStrings(_ strings: [String: String], forLanguage language: String)
            ```
            - **参数**:
              - `strings`: 字符串字典，键为字符串标识符，值为对应的翻译
              - `language`: 语言代码，指定为哪种语言添加字符串
            - **功能**: 添加国际化字符串，用于多语言支持
            - **使用场景**: 当需要为应用添加新的语言支持时使用
            
            #### getLocalizedString
            ```swift
            func getLocalizedString(_ key: String, forLanguage language: String? = nil) -> String
            ```
            - **参数**:
              - `key`: 字符串键，指定要获取的字符串
              - `language`: 语言代码，可选，指定要获取哪种语言的字符串，默认为当前语言
            - **返回值**: 国际化字符串，根据指定的语言返回对应的翻译
            - **功能**: 获取国际化字符串
            - **使用场景**: 当需要显示国际化文本时使用
            
            ## 7. 行业解决方案
            
            ### 7.1 解决方案方法
            
            #### getECommerceSolution
            ```swift
            func getECommerceSolution() -> HCollViewSolution
            ```
            - **返回值**: 电商解决方案，包含电商应用所需的布局和交互配置
            - **功能**: 获取电商解决方案
            - **使用场景**: 当开发电商应用时使用，提供商品列表、详情等布局
            
            #### getNewsSolution
            ```swift
            func getNewsSolution() -> HCollViewSolution
            ```
            - **返回值**: 新闻解决方案，包含新闻应用所需的布局和交互配置
            - **功能**: 获取新闻解决方案
            - **使用场景**: 当开发新闻应用时使用，提供新闻列表、分类等布局
            
            #### getSocialMediaSolution
            ```swift
            func getSocialMediaSolution() -> HCollViewSolution
            ```
            - **返回值**: 社交媒体解决方案，包含社交媒体应用所需的布局和交互配置
            - **功能**: 获取社交媒体解决方案
            - **使用场景**: 当开发社交媒体应用时使用，提供动态、评论等布局
            
            #### getPhotoGallerySolution
            ```swift
            func getPhotoGallerySolution() -> HCollViewSolution
            ```
            - **返回值**: 图片库解决方案，包含图片库应用所需的布局和交互配置
            - **功能**: 获取图片库解决方案
            - **使用场景**: 当开发图片库应用时使用，提供图片网格、预览等布局
            
            #### getVideoAppSolution
            ```swift
            func getVideoAppSolution() -> HCollViewSolution
            ```
            - **返回值**: 视频应用解决方案，包含视频应用所需的布局和交互配置
            - **功能**: 获取视频应用解决方案
            - **使用场景**: 当开发视频应用时使用，提供视频列表、播放器等布局
            
            #### getEnterpriseAppSolution
            ```swift
            func getEnterpriseAppSolution() -> HCollViewSolution
            ```
            - **返回值**: 企业应用解决方案，包含企业应用所需的布局和交互配置
            - **功能**: 获取企业应用解决方案
            - **使用场景**: 当开发企业应用时使用，提供数据展示、报表等布局
            
            #### getEducationAppSolution
            ```swift
            func getEducationAppSolution() -> HCollViewSolution
            ```
            - **返回值**: 教育应用解决方案，包含教育应用所需的布局和交互配置
            - **功能**: 获取教育应用解决方案
            - **使用场景**: 当开发教育应用时使用，提供课程列表、学习进度等布局
            
            #### getMedicalAppSolution
            ```swift
            func getMedicalAppSolution() -> HCollViewSolution
            ```
            - **返回值**: 医疗应用解决方案，包含医疗应用所需的布局和交互配置
            - **功能**: 获取医疗应用解决方案
            - **使用场景**: 当开发医疗应用时使用，提供患者信息、预约等布局
            
            #### applySolution
            ```swift
            func applySolution(_ solution: HCollViewSolution)
            ```
            - **参数**:
              - `solution`: 解决方案对象，包含布局和交互配置
            - **功能**: 应用解决方案，快速配置 HCollView
            - **使用场景**: 当需要快速应用行业解决方案时使用
            
            ## 8. 模板市场
            
            ### 8.1 模板方法
            
            #### getTemplates
            ```swift
            func getTemplates() -> [HCollViewTemplate]
            ```
            - **返回值**: 模板列表，包含所有可用的模板
            - **功能**: 获取模板列表
            - **使用场景**: 当需要查看所有可用模板时使用
            
            #### getTemplate
            ```swift
            func getTemplate(name: String) -> HCollViewTemplate?
            ```
            - **参数**:
              - `name`: 模板名称，指定要获取的模板
            - **返回值**: 模板对象，成功时为 HCollViewTemplate 对象，失败时为 nil
            - **功能**: 根据名称获取模板
            - **使用场景**: 当需要获取特定模板时使用
            
            #### applyTemplate
            ```swift
            func applyTemplate(_ template: HCollViewTemplate)
            ```
            - **参数**:
              - `template`: 模板对象，包含布局和交互配置
            - **功能**: 应用模板，快速配置 HCollView
            - **使用场景**: 当需要应用特定模板时使用
            
            #### applyTemplate
            ```swift
            func applyTemplate(name: String)
            ```
            - **参数**:
              - `name`: 模板名称，指定要应用的模板
            - **功能**: 根据名称应用模板
            - **使用场景**: 当需要根据名称应用模板时使用
            """
        }
        
        /// 获取示例代码
        ///
        /// 提供 HCollView 的详细示例代码，覆盖各种使用场景
        ///
        /// - Returns: 详细的示例代码，覆盖各种使用场景
        /// - Version: 1.0.0
        ///
        /// 示例代码包括 HCollView 的基本使用、高级布局、高级交互、性能优化、网络优化、稳定性、扩展性、行业解决方案和模板市场等方面的完整示例。
        func getSampleCode() -> String {
            return """
            # HCollView 示例代码
            
            ## 示例 1: 基本使用
            
            ```swift
            import UIKit
            
            class ViewController: UIViewController, HCollViewDelegate {
                
                private var collView: HCollView!
                private var dataSource: [String] = []
                
                override func viewDidLoad() {
                    super.viewDidLoad()
                    setupCollView()
                    loadData()
                }
                
                private func setupCollView() {
                    // 创建 HCollView 实例
                    collView = HCollView(frame: view.bounds)
                    collView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    collView.backgroundColor = .white
                    view.addSubview(collView)
                    
                    // 设置代理
                    collView.delegate = self
                    
                    // 设置布局
                    collView.setLayout(.grid, configuration: ["columns": 3, "itemSize": CGSize(width: 100, height: 100)])
                }
                
                private func loadData() {
                    // 模拟加载数据
                    dataSource = (0..<20).map { index in "Item index" }
                    collView.reloadData()
                }
                
                // MARK: - HCollViewDelegate
                
                func numberOfSectionsInCollView() -> Int {
                    return 1
                }
                
                func numberOfItemsInSection(_ section: Int) -> Int {
                    return dataSource.count
                }
                
                func sizeForItemAtIndexPath(_ indexPath: IndexPath) -> CGSize {
                    let width = (view.bounds.width - 30) / 3 // 3列，左右边距10，中间间距10
                    return CGSize(width: width, height: width)
                }
                
                func minimumLineSpacingForSectionAt(_ section: Int) -> CGFloat {
                    return 10
                }
                
                func minimumInteritemSpacingForSectionAt(_ section: Int) -> CGFloat {
                    return 10
                }
                
                func insetForSection(_ section: Int) -> UIEdgeInsets {
                    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                }
                
                func collItem(_ coll: HCollView, atIndexPath indexPath: IndexPath) {
                    // 配置单元格
                    if let cell = coll.cellForItem(at: indexPath) as? HCollBaseCell {
                        cell.backgroundColor = .random
                        
                        // 添加标签
                        if cell.contentView.subviews.isEmpty {
                            let label = UILabel()
                            label.textAlignment = .center
                            label.frame = cell.contentView.bounds
                            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            cell.contentView.addSubview(label)
                        }
                        
                        if let label = cell.contentView.subviews.first as? UILabel {
                            label.text = dataSource[indexPath.item]
                        }
                    }
                }
                
                func didSelectCell(_ cell: HCollBaseCell, atIndexPath indexPath: IndexPath) {
                    print("选中了: dataSource[indexPath.item]")
                }
            }
            
            /// 扩展 UIColor，提供随机颜色
            extension UIColor {
                static var random: UIColor {
                    return UIColor(
                        red: .random(in: 0...1),
                        green: .random(in: 0...1),
                        blue: .random(in: 0...1),
                        alpha: 1.0
                    )
                }
            }
            ```
            
            ## 示例 2: 高级布局
            
            ```swift
            // 设置瀑布流布局
            hCollView.setLayout(.waterfall, configuration: ["columns": 2, "spacing": 10])
            
            // 设置时间线布局
            hCollView.setLayout(.timeline, configuration: ["lineColor": UIColor.gray, "lineWidth": 2, "spacing": 20])
            
            // 设置卡片布局
            hCollView.setLayout(.card, configuration: ["cornerRadius": 8, "shadowColor": UIColor.black, "shadowOffset": CGSize(width: 0, height: 2), "shadowRadius": 4, "shadowOpacity": 0.2, "spacing": 15])
            
            // 设置 Masonry 布局
            hCollView.setLayout(.masonry, configuration: ["columns": 3, "spacing": 5])
            
            // 设置水平滚动布局
            hCollView.setLayout(.horizontal, configuration: ["itemSize": CGSize(width: 150, height: 100), "spacing": 10])
            
            // 设置垂直滚动布局
            hCollView.setLayout(.vertical, configuration: ["itemSize": CGSize(width: 300, height: 100), "spacing": 10])
            ```
            
            ## 示例 3: 高级交互
            
            ```swift
            // 启用拖拽排序
            hCollView.enableDragDrop()
            
            // 添加滑动操作
            hCollView.addSwipeActions {
                [
                    UIContextualAction(style: .destructive, title: "删除") { (action, view, completion) in
                        // 处理删除操作
                        completion(true)
                    },
                    UIContextualAction(style: .normal, title: "编辑") { (action, view, completion) in
                        // 处理编辑操作
                        completion(true)
                    },
                    UIContextualAction(style: .normal, title: "分享") { (action, view, completion) in
                        // 处理分享操作
                        completion(true)
                    }
                ]
            }
            
            // 启用多选模式
            hCollView.setInteractionMode(.multiSelect)
            
            // 全选
            hCollView.selectAll()
            
            // 取消全选
            hCollView.deselectAll()
            ```
            
            ## 示例 4: 性能优化
            
            ```swift
            // 优化启动性能
            hCollView.optimizeStartupPerformance()
            
            // 启用内存监控
            hCollView.enableMemoryMonitoring()
            
            // 启用懒加载
            hCollView.enableLazyLoading()
            
            // 启用预加载
            hCollView.enablePreloading()
            
            // 创建对象池
            hCollView.createObjectPool(key: "cellPool") { 
                HCollBaseCell()
            }
            
            // 从对象池获取对象
            if let cell = hCollView.getObject(fromPool: "cellPool") as? HCollBaseCell {
                // 使用单元格
                print("从对象池获取单元格成功")
            }
            
            // 预加载内容
            hCollView.preloadContent(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)]) {
                indexPath in
                // 预加载逻辑
                print("预加载索引路径: indexPath")
            }
            ```
            
            ## 示例 5: 网络优化
            
            ```swift
            // 发送网络请求
            hCollView.sendRequest("https://jsonplaceholder.typicode.com/todos/1") { data, error in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("网络请求成功: json")
                    } catch {
                        print("网络请求失败: error")
                    }
                } else if let error = error {
                    print("网络请求失败: error")
                }
            }
            
            // 启用离线模式
            hCollView.enableOfflineMode()
            
            // 启用网络状态适应
            hCollView.enableNetworkStateAdaptation()
            
            // 注册网络状态变化通知
            hCollView.registerForNetworkStatusChanges()
            
            // 取消请求
            hCollView.cancelRequest("https://example.com/api/data")
            
            // 取消所有请求
            hCollView.cancelAllRequests()
            ```
            
            ## 示例 6: 稳定性
            
            ```swift
            // 启用崩溃防护
            hCollView.enableCrashProtection()
            
            // 启用错误处理
            hCollView.enableErrorHandling()
            
            // 启用异常监控
            hCollView.enableExceptionMonitoring()
            
            // 防护执行
            let result = hCollView.safeExecute {
                // 可能抛出异常的代码
                if 1 > 2 {
                    throw NSError(domain: "ExampleError", code: 1, userInfo: nil)
                }
                return "Success"
            }
            print("执行结果: result ?? "Failed"")
            
            // 处理错误
            hCollView.handleError(NSError(domain: "ExampleError", code: 1, userInfo: nil), message: "加载失败")
            
            // 监控异常
            hCollView.monitorException {
                // 可能抛出异常的代码
                print("执行可能抛出异常的代码")
            }
            ```
            
            ## 示例 7: 扩展性
            
            ```swift
            // 注册插件
            let examplePlugin = ExamplePlugin()
            hCollView.registerPlugin(examplePlugin, forKey: "examplePlugin")
            
            // 调用插件方法
            hCollView.callPlugins(method: "initialize", parameters: ["param1", "param2"])
            
            // 设置主题
            hCollView.setTheme(DarkTheme())
            
            // 获取当前主题
            let currentTheme = hCollView.getCurrentTheme()
            print("当前主题: currentTheme")
            
            // 设置语言
            hCollView.setLanguage("en-US")
            
            // 添加国际化字符串
            hCollView.addLocalizedStrings(["loading": "Loading...", "empty": "No data"], forLanguage: "en-US")
            
            // 获取国际化字符串
            let loadingText = hCollView.getLocalizedString("loading")
            print("加载文本: loadingText")
            ```
            
            ## 示例 8: 行业解决方案
            
            ```swift
            // 应用电商解决方案
            let ecommerceSolution = hCollView.getECommerceSolution()
            hCollView.applySolution(ecommerceSolution)
            print("电商解决方案已应用")
            
            // 应用新闻解决方案
            let newsSolution = hCollView.getNewsSolution()
            hCollView.applySolution(newsSolution)
            print("新闻解决方案已应用")
            
            // 应用社交媒体解决方案
            let socialMediaSolution = hCollView.getSocialMediaSolution()
            hCollView.applySolution(socialMediaSolution)
            print("社交媒体解决方案已应用")
            
            // 应用图片库解决方案
            let photoGallerySolution = hCollView.getPhotoGallerySolution()
            hCollView.applySolution(photoGallerySolution)
            print("图片库解决方案已应用")
            ```
            
            ## 示例 9: 模板市场
            
            ```swift
            // 获取模板列表
            let templates = hCollView.getTemplates()
            print("模板数量: templates.count")
            
            // 应用网格布局模板
            hCollView.applyTemplate(name: "网格布局")
            print("网格布局模板已应用")
            
            // 应用瀑布流布局模板
            hCollView.applyTemplate(name: "瀑布流布局")
            print("瀑布流布局模板已应用")
            
            // 应用时间线布局模板
            hCollView.applyTemplate(name: "时间线布局")
            print("时间线布局模板已应用")
            
            // 应用卡片布局模板
            hCollView.applyTemplate(name: "卡片布局")
            print("卡片布局模板已应用")
            
            // 应用拖拽排序模板
            hCollView.applyTemplate(name: "拖拽排序")
            print("拖拽排序模板已应用")
            
            // 应用滑动操作模板
            hCollView.applyTemplate(name: "滑动操作")
            print("滑动操作模板已应用")
            
            // 应用多选模式模板
            hCollView.applyTemplate(name: "多选模式")
            print("多选模式模板已应用")
            ```
            
            ## 示例 10: 自定义布局实现
            
            ```swift
            // 创建自定义布局
            class CustomLayout: UICollectionViewLayout {
                private var cache: [UICollectionViewLayoutAttributes] = []
                private var contentHeight: CGFloat = 0
                private var contentWidth: CGFloat {
                    guard let collectionView = collectionView else { return 0 }
                    let insets = collectionView.contentInset
                    return collectionView.bounds.width - insets.left - insets.right
                }
                
                override func prepare() {
                    guard cache.isEmpty, let collectionView = collectionView else { return }
                    
                    let itemSize = CGSize(width: contentWidth / 3, height: 100)
                    let itemsPerRow: Int = 3
                    let spacing: CGFloat = 10
                    
                    var xOffset: [CGFloat] = []
                    for column in 0..<itemsPerRow {
                        xOffset.append(CGFloat(column) * (itemSize.width + spacing))
                    }
                    
                    var column = 0
                    var yOffset: [CGFloat] = .init(repeating: 0, count: itemsPerRow)
                    
                    for item in 0..<collectionView.numberOfItems(inSection: 0) {
                        let indexPath = IndexPath(item: item, section: 0)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        
                        attributes.frame = CGRect(
                            x: xOffset[column],
                            y: yOffset[column],
                            width: itemSize.width,
                            height: itemSize.height
                        )
                        
                        cache.append(attributes)
                        contentHeight = max(contentHeight, attributes.frame.maxY)
                        yOffset[column] = yOffset[column] + itemSize.height + spacing
                        column = column < (itemsPerRow - 1) ? (column + 1) : 0
                    }
                }
                
                override var collectionViewContentSize: CGSize {
                    return CGSize(width: contentWidth, height: contentHeight)
                }
                
                override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
                    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
                    
                    for attributes in cache {
                        if attributes.frame.intersects(rect) {
                            visibleLayoutAttributes.append(attributes)
                        }
                    }
                    
                    return visibleLayoutAttributes
                }
                
                override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
                    return cache[indexPath.item]
                }
            }
            
            // 使用自定义布局
            let customLayout = CustomLayout()
            hCollView.setLayout(.custom, configuration: ["layout": customLayout])
            print("自定义布局已应用")
            ```
            
            ## 示例 11: 自定义交互实现
            
            ```swift
            // 实现自定义交互模式
            class CustomInteractionHandler {
                func handleTap(at indexPath: IndexPath) {
                    print("自定义点击处理: indexPath")
                }
                
                func handleLongPress(at indexPath: IndexPath) {
                    print("自定义长按处理: indexPath")
                }
            }
            
            // 使用自定义交互模式
            let customHandler = CustomInteractionHandler()
            hCollView.setInteractionMode(.custom) {
                print("自定义交互模式已启用")
                // 在这里可以设置自定义手势
                let tapGesture = UITapGestureRecognizer(target: customHandler, action: #selector(customHandler.handleTap))
                hCollView.addGestureRecognizer(tapGesture)
                
                let longPressGesture = UILongPressGestureRecognizer(target: customHandler, action: #selector(customHandler.handleLongPress))
                hCollView.addGestureRecognizer(longPressGesture)
            }
            ```
            
            ## 示例 12: 性能优化综合示例
            
            ```swift
            // 性能优化综合配置
            func configurePerformanceOptimization() {
                // 优化启动性能
                hCollView.optimizeStartupPerformance()
                
                // 启用内存监控
                hCollView.enableMemoryMonitoring()
                
                // 启用懒加载
                hCollView.enableLazyLoading()
                
                // 启用预加载
                hCollView.enablePreloading()
                
                // 创建对象池
                hCollView.createObjectPool(key: "cellPool") { 
                    HCollBaseCell()
                }
                
                // 注册内存警告通知
                NotificationCenter.default.addObserver(
                    forName: UIApplication.didReceiveMemoryWarningNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    // 清理内存缓存
                    self?.hCollView.clearMemoryCache()
                    print("内存缓存已清理")
                }
            }
            
            // 调用性能优化配置
            configurePerformanceOptimization()
            ```
            
            ## 示例 13: 网络优化综合示例
            
            ```swift
            // 网络优化综合配置
            func configureNetworkOptimization() {
                // 启用离线模式
                hCollView.enableOfflineMode()
                
                // 启用网络状态适应
                hCollView.enableNetworkStateAdaptation()
                
                // 注册网络状态变化通知
                hCollView.registerForNetworkStatusChanges()
                
                // 发送带缓存的网络请求
                hCollView.sendRequest(
                    "https://jsonplaceholder.typicode.com/posts",
                    method: .get,
                    cachePolicy: .useCacheElseLoad
                ) { data, error in
                    if let data = data {
                        do {
                            let posts = try JSONSerialization.jsonObject(with: data, options: [])
                            print("网络请求成功，获取到 String(describing: posts")
                        } catch {
                            print("网络请求失败: error")
                        }
                    } else if let error = error {
                        print("网络请求失败: error")
                    }
                }
            }
            
            // 调用网络优化配置
            configureNetworkOptimization()
            ```
            
            ## 示例 14: 稳定性综合示例
            
            ```swift
            // 稳定性综合配置
            func configureStability() {
                // 启用崩溃防护
                hCollView.enableCrashProtection()
                
                // 启用错误处理
                hCollView.enableErrorHandling()
                
                // 启用异常监控
                hCollView.enableExceptionMonitoring()
                
                // 安全执行可能抛出异常的代码
                let result = hCollView.safeExecute {
                    // 模拟可能抛出异常的操作
                    if Bool.random() {
                        throw NSError(domain: "ExampleError", code: 1, userInfo: nil)
                    }
                    return "Success"
                }
                print("安全执行结果: result ?? "Failed"")
                
                // 监控异常
                hCollView.monitorException {
                    // 模拟可能抛出异常的操作
                    if Bool.random() {
                        fatalError("模拟崩溃")
                    }
                    print("异常监控: 操作成功")
                }
            }
            
            // 调用稳定性配置
            configureStability()
            ```
            
            ## 示例 15: 扩展性综合示例
            
            ```swift
            // 定义插件
            class AnalyticsPlugin: HCollViewPlugin {
                func initialize() {
                    print("AnalyticsPlugin 已初始化")
                }
                
                func trackEvent(_ event: String, parameters: [String: Any]) {
                    print("追踪事件: event), 参数: parameters")
                }
            }
            
            // 定义主题
            class LightTheme: HCollViewTheme {
                var backgroundColor: UIColor { return .white }
                var textColor: UIColor { return .black }
                var accentColor: UIColor { return .blue }
            }
            
            // 扩展性综合配置
            func configureExtensibility() {
                // 注册插件
                let analyticsPlugin = AnalyticsPlugin()
                hCollView.registerPlugin(analyticsPlugin, forKey: "analytics")
                
                // 调用插件方法
                hCollView.callPlugins(method: "initialize", parameters: [])
                hCollView.callPlugins(method: "trackEvent", parameters: ["viewDidLoad", ["time": Date()]])
                
                // 设置主题
                hCollView.setTheme(LightTheme())
                print("主题已设置为浅色主题")
                
                // 设置语言
                hCollView.setLanguage("zh-CN")
                
                // 添加国际化字符串
                hCollView.addLocalizedStrings([
                    "loading": "加载中...",
                    "empty": "暂无数据",
                    "error": "加载失败"
                ], forLanguage: "zh-CN")
                
                // 获取国际化字符串
                let loadingText = hCollView.getLocalizedString("loading")
                print("加载文本: loadingText")
            }
            
            // 调用扩展性配置
            configureExtensibility()
            ```
            """
        }
        
        /// 获取常见问题
        ///
        /// 提供 HCollView 的详细常见问题解答
        ///
        /// - Returns: 详细的常见问题解答
        /// - Version: 1.0.0
        ///
        /// 常见问题解答包括 HCollView 的各种使用问题、性能优化问题、错误处理问题等方面的详细解答。
        func getFAQ() -> String {
            return """
            # HCollView 常见问题
            
            ## 1. 如何设置自定义布局？
            
            答：使用 `setLayout(.custom, configuration: ["layout": customLayout])` 方法设置自定义布局，其中 `customLayout` 是你创建的自定义布局对象。
            
            ```swift
            // 创建自定义布局
            let customLayout = UICollectionViewFlowLayout()
            customLayout.itemSize = CGSize(width: 150, height: 200)
            
            // 设置自定义布局
            hCollView.setLayout(.custom, configuration: ["layout": customLayout])
            ```
            
            ## 2. 如何启用拖拽排序？
            
            答：使用 `enableDragDrop()` 方法启用拖拽排序功能。
            
            ```swift
            // 启用拖拽排序
            hCollView.enableDragDrop()
            ```
            
            ## 3. 如何添加滑动操作？
            
            答：使用 `addSwipeActions()` 方法添加滑动操作，传入一个返回 `[UIContextualAction]` 的闭包。
            
            ```swift
            // 添加滑动操作
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
            ```
            
            ## 4. 如何优化内存使用？
            
            答：可以使用以下方法优化内存使用：
            - 启用内存监控：`enableMemoryMonitoring()`
            - 清理内存缓存：`clearMemoryCache()`
            - 使用对象池：`createObjectPool()`
            
            ```swift
            // 启用内存监控
            hCollView.enableMemoryMonitoring()
            
            // 清理内存缓存
            hCollView.clearMemoryCache()
            
            // 创建对象池
            hCollView.createObjectPool(key: "cellPool") { 
                HCollBaseCell()
            }
            ```
            
            ## 5. 如何处理网络请求？
            
            答：使用 `sendRequest()` 方法发送网络请求，支持缓存策略和离线模式。
            
            ```swift
            // 发送网络请求
            hCollView.sendRequest("https://example.com/api/data") { data, error in
                if let data = data {
                    // 处理数据
                } else if let error = error {
                    // 处理错误
                }
            }
            ```
            
            ## 6. 如何提高启动性能？
            
            答：使用 `optimizeStartupPerformance()` 方法优化启动性能，启用懒加载和预加载。
            
            ```swift
            // 优化启动性能
            hCollView.optimizeStartupPerformance()
            
            // 启用懒加载
            hCollView.enableLazyLoading()
            
            // 启用预加载
            hCollView.enablePreloading()
            ```
            
            ## 7. 如何处理错误和异常？
            
            答：可以使用以下方法处理错误和异常：
            - 启用崩溃防护：`enableCrashProtection()`
            - 处理错误：`handleError()`
            - 监控异常：`monitorException()`
            
            ```swift
            // 启用崩溃防护
            hCollView.enableCrashProtection()
            
            // 处理错误
            hCollView.handleError(NSError(domain: "ExampleError", code: 1, userInfo: nil), message: "加载失败")
            
            // 监控异常
            hCollView.monitorException {
                // 可能抛出异常的代码
            }
            ```
            
            ## 8. 如何预加载内容？
            
            答：使用 `preloadContent()` 方法预加载内容，传入要预加载的索引路径和加载闭包。
            
            ```swift
            // 预加载内容
            hCollView.preloadContent(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0)]) {
                indexPath in
                // 预加载逻辑
            }
            ```
            
            ## 9. 如何切换布局？
            
            答：使用 `switchLayout()` 方法切换布局，支持动画效果。
            
            ```swift
            // 切换到网格布局
            hCollView.switchLayout(.grid, configuration: ["columns": 3, "itemSize": CGSize(width: 100, height: 100)])
            ```
            
            ## 10. 如何使用多选模式？
            
            答：使用 `setInteractionMode(.multiSelect)` 方法启用多选模式，然后使用 `selectAll()` 和 `deselectAll()` 方法进行全选和取消全选。
            
            ```swift
            // 启用多选模式
            hCollView.setInteractionMode(.multiSelect)
            
            // 全选
            hCollView.selectAll()
            
            // 取消全选
            hCollView.deselectAll()
            ```
            
            ## 11. 如何应用行业解决方案？
            
            答：使用 `getECommerceSolution()`、`getNewsSolution()` 等方法获取行业解决方案，然后使用 `applySolution()` 方法应用解决方案。
            
            ```swift
            // 应用电商解决方案
            let solution = hCollView.getECommerceSolution()
            hCollView.applySolution(solution)
            ```
            
            ## 12. 如何使用模板？
            
            答：使用 `applyTemplate(name: "模板名称")` 方法应用模板。
            
            ```swift
            // 应用网格布局模板
            hCollView.applyTemplate(name: "网格布局")
            ```
            
            ## 13. 如何设置主题？
            
            答：使用 `setTheme()` 方法设置主题。
            
            ```swift
            // 设置暗黑主题
            hCollView.setTheme(DarkTheme())
            ```
            
            ## 14. 如何实现国际化？
            
            答：使用 `setLanguage()` 方法设置语言，使用 `addLocalizedStrings()` 方法添加国际化字符串，使用 `getLocalizedString()` 方法获取国际化字符串。
            
            ```swift
            // 设置语言
            hCollView.setLanguage("en-US")
            
            // 添加国际化字符串
            hCollView.addLocalizedStrings(["loading": "Loading..."], forLanguage: "en-US")
            
            // 获取国际化字符串
            let loadingText = hCollView.getLocalizedString("loading")
            ```
            
            ## 15. 如何注册和使用插件？
            
            答：使用 `registerPlugin()` 方法注册插件，使用 `callPlugins()` 方法调用插件方法。
            
            ```swift
            // 注册插件
            let plugin = ExamplePlugin()
            hCollView.registerPlugin(plugin, forKey: "examplePlugin")
            
            // 调用插件方法
            hCollView.callPlugins(method: "initialize")
            ```
            
            ## 16. 如何实现自定义主题？
            
            答：实现 `HCollViewTheme` 协议，然后使用 `setTheme()` 方法设置主题。
            
            ```swift
            // 实现自定义主题
            class DarkTheme: HCollViewTheme {
                var backgroundColor: UIColor { return .black }
                var textColor: UIColor { return .white }
                var accentColor: UIColor { return .blue }
            }
            
            // 设置主题
            hCollView.setTheme(DarkTheme())
            ```
            
            ## 17. 如何处理内存警告？
            
            答：注册内存警告通知，在收到通知时清理内存缓存。
            
            ```swift
            // 注册内存警告通知
            NotificationCenter.default.addObserver(
                forName: UIApplication.didReceiveMemoryWarningNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                // 清理内存缓存
                self?.hCollView.clearMemoryCache()
                print("内存缓存已清理")
            }
            ```
            
            ## 18. 如何实现下拉刷新和上拉加载？
            
            答：可以使用 UIRefreshControl 实现下拉刷新，使用滚动监听实现上拉加载。
            
            ```swift
            // 添加下拉刷新
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            hCollView.addSubview(refreshControl)
            
            // 实现上拉加载
            func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                let height = scrollView.frame.size.height
                
                if offsetY > contentHeight - height - 100 {
                    // 触发上拉加载
                    loadMoreData()
                }
            }
            
            @objc func handleRefresh() {
                // 处理下拉刷新
                loadNewData()
            }
            ```
            
            ## 19. 如何优化大型数据集的性能？
            
            答：可以使用以下方法优化大型数据集的性能：
            - 启用分页加载
            - 使用虚拟列表
            - 优化单元格重用
            - 使用对象池
            - 启用预加载
            
            ```swift
            // 优化大型数据集
            func optimizeLargeDataset() {
                // 启用分页加载
                // 实现代码...
                
                // 使用对象池
                hCollView.createObjectPool(key: "cellPool") { 
                    HCollBaseCell()
                }
                
                // 启用预加载
                hCollView.enablePreloading()
            }
            ```
            
            ## 20. 如何实现多语言支持？
            
            答：使用 `setLanguage()` 方法设置语言，使用 `addLocalizedStrings()` 方法添加国际化字符串，使用 `getLocalizedString()` 方法获取国际化字符串。
            
            ```swift
            // 设置语言
            hCollView.setLanguage("zh-CN")
            
            // 添加国际化字符串
            hCollView.addLocalizedStrings([
                "loading": "加载中...",
                "empty": "暂无数据",
                "error": "加载失败"
            ], forLanguage: "zh-CN")
            
            // 获取国际化字符串
            let loadingText = hCollView.getLocalizedString("loading")
            ```
            
            ## 21. 如何实现搜索功能？
            
            答：可以使用 UISearchController 实现搜索功能，根据搜索关键词过滤数据。
            
            ```swift
            // 添加搜索控制器
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "搜索"
            navigationItem.searchController = searchController
            definesPresentationContext = true
            
            // 实现搜索结果更新
            func updateSearchResults(for searchController: UISearchController) {
                guard let searchText = searchController.searchBar.text else { return }
                // 根据搜索文本过滤数据
                filteredDataSource = dataSource.filter { $0.contains(searchText) }
                hCollView.reloadData()
            }
            ```
            
            ## 22. 如何实现夜间模式？
            
            答：可以通过设置不同的主题来实现夜间模式。
            
            ```swift
            // 切换夜间模式
            func toggleNightMode(_ isNightMode: Bool) {
                if isNightMode {
                    // 设置暗黑主题
                    hCollView.setTheme(DarkTheme())
                } else {
                    // 设置浅色主题
                    hCollView.setTheme(LightTheme())
                }
            }
            ```
            
            ## 23. 如何实现卡片翻转效果？
            
            答：可以通过自定义单元格和手势识别器实现卡片翻转效果。
            
            ```swift
            // 实现卡片翻转效果
            class FlipCardCell: HCollBaseCell {
                private var frontView: UIView!
                private var backView: UIView!
                private var isFlipped = false
                
                override func setupUI() {
                    super.setupUI()
                    
                    // 创建正面和背面视图
                    frontView = UIView(frame: contentView.bounds)
                    frontView.backgroundColor = .blue
                    contentView.addSubview(frontView)
                    
                    backView = UIView(frame: contentView.bounds)
                    backView.backgroundColor = .red
                    backView.isHidden = true
                    contentView.addSubview(backView)
                    
                    // 添加点击手势
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
                    addGestureRecognizer(tapGesture)
                }
                
                @objc private func flipCard() {
                    isFlipped.toggle()
                    
                    UIView.transition(
                        from: isFlipped ? frontView : backView,
                        to: isFlipped ? backView : frontView,
                        duration: 0.3,
                        options: [.transitionFlipFromRight, .showHideTransitionViews]
                    )
                }
            }
            ```
            
            ## 24. 如何实现无限滚动？
            
            答：可以通过监听滚动事件，当滚动到列表末尾时加载更多数据。
            
            ```swift
            // 实现无限滚动
            func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let offsetY = scrollView.contentOffset.y
                let contentHeight = scrollView.contentSize.height
                let height = scrollView.frame.size.height
                
                if offsetY > contentHeight - height - 100 {
                    // 防止重复加载
                    if !isLoading {
                        isLoading = true
                        // 加载更多数据
                        loadMoreData { [weak self] in
                            self?.isLoading = false
                        }
                    }
                }
            }
            
            func loadMoreData(completion: @escaping () -> Void) {
                // 模拟网络请求
                DispatchQueue.global().async {
                    // 加载数据
                    // ...
                    
                    DispatchQueue.main.async {
                        // 更新数据
                        // ...
                        completion()
                    }
                }
            }
            ```
            
            ## 25. 如何实现分组列表？
            
            答：可以通过实现多个 section 来创建分组列表。
            
            ```swift
            // 实现分组列表
            func numberOfSectionsInCollView() -> Int {
                return sections.count
            }
            
            func numberOfItemsInSection(_ section: Int) -> Int {
                return sections[section].items.count
            }
            
            func collView(_ coll: HCollView, viewForHeaderInSection section: Int) -> UIView? {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: coll.bounds.width, height: 50))
                headerView.backgroundColor = .lightGray
                
                let label = UILabel(frame: headerView.bounds)
                label.text = sections[section].title
                label.textAlignment = .center
                headerView.addSubview(label)
                
                return headerView
            }
            
            func heightForHeaderInSection(_ section: Int) -> CGFloat {
                return 50
            }
            ```
            """
        }
    }
    
    /// 文档管理器
    /// - Returns: 文档管理器单例
    var documentationManager: DocumentationManager {
        return DocumentationManager.shared
    }
    
    /// 获取使用指南
    /// - Returns: 详细的使用指南，包含基本用法和高级用法
    func getUsageGuide() -> String {
        return documentationManager.getUsageGuide()
    }
    
    /// 获取 API 文档
    /// - Returns: 详细的 API 文档，包含所有方法和属性的说明
    func getAPIDocumentation() -> String {
        return documentationManager.getAPIDocumentation()
    }
    
    /// 获取示例代码
    /// - Returns: 详细的示例代码，覆盖各种使用场景
    func getSampleCode() -> String {
        return documentationManager.getSampleCode()
    }
    
    /// 获取常见问题
    /// - Returns: 详细的常见问题解答
    func getFAQ() -> String {
        return documentationManager.getFAQ()
    }
    
    /// 显示使用指南
    func showUsageGuide() {
        print(getUsageGuide())
    }
    
    /// 显示 API 文档
    func showAPIDocumentation() {
        print(getAPIDocumentation())
    }
    
    /// 显示示例代码
    func showSampleCode() {
        print(getSampleCode())
    }
    
    /// 显示常见问题
    func showFAQ() {
        print(getFAQ())
    }
}

