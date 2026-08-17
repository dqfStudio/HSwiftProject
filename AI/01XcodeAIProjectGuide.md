# 项目工程配置，严格遵守以下约束（Xcode AI 专用）：
一、开发环境：Xcode 26.3、Swift 6.1.2、最低iOS 14.1
二、架构：UIKit（禁止使用SwiftUI）、MVVM+RxSwift、纯代码snapkit布局（无Storyboard/XIB）
三、通用规则：禁止强制解包、全部使用if let/guard let、防止循环引用、文件前缀为DPM、所有代码必须可直接运行，标注需要修改的配置项
四、依赖：通过CocoaPods引入第三方框架(排除下面这些项目中已经引入的框架，同时也可以使用这些框架来实现对应的功能)

  # ReactiveX响应式编程
  pod 'RxCocoa'
  #  基于Alamofire的网络请求封装
  pod 'Moya/RxSwift'
  # 自动布局
  pod 'Masonry'
  pod 'SnapKitExtend'
  # 支付宝
  pod 'AlipaySDK-iOS'
  #  网易七鱼
  pod 'QY_iOS_SDK'
  # 非对称加密
  pod 'SwiftyRSA'
  #  标签
  pod 'YYText-swift'
  #  下拉刷新
  pod 'MJRefresh'
  #  弹窗视图框架
  pod 'LSTPopView'
  #  宫格视图
  pod 'BAGridView'
  #  文本框
  pod 'BATextField'
  #  加载指示器
  pod 'SVProgressHUD'
  #  分类选择器、分页视图
  pod 'JXSegmentedView'
  pod 'JXPagingView/Paging'
  #  轮播视图
  pod 'TYCyclePagerView'
  # TabBar
  pod 'CYLTabBarController'
  #  图片视频选择器
  pod 'TZImagePickerController'
  #  瀑布流布局
  pod 'CHTCollectionViewWaterfallLayout'
  pod 'JQCollectionViewAlignLayout'
  # 日历
  pod 'FSCalendar'
  # 选择器
  pod 'BRPickerView'
  #  预览器
  pod 'JXPhotoBrowser'
  #  键盘管理器
  pod 'IQKeyboardManager'
  #  数据存储
  pod 'FMDB'
  #  钥匙链
  pod 'KeychainAccess'
  #  高度计算
  pod 'FDTemplateLayoutCell'
  #  GIO埋点
  pod 'GrowingAnalytics/Autotracker'
  #  极光推送
  pod 'JPush'
  #  腾讯Bug收集
  pod 'Bugly'
  #  动画图片
  pod 'FLAnimatedImage'
  #  网络图片
  pod 'Kingfisher'
  # 微信
  pod 'WechatOpenSDK'
  # QQ
  #pod 'TencentOpenAPI-iOS'
  #pod 'LJTencentOpenAPI-iOS'
  #pod 'TencentOpenSDK-iOS'
  # 网络监控
  pod 'CocoaDebug', '1.7.7', :configurations => ['Debug']
  # 骨架屏
  pod 'TABAnimated', '2.6.3'
  # 网络监控
  pod 'Reachability'

  pod 'ZLPhotoBrowser'
  pod 'CryptoSwift'
  pod 'SwiftyRSA'
  pod 'APNGKit'

五、输出要求：
1、代码带完整注释，命名符合Swift规范，可直接编译运行
2、界面与模型绑定，参考下面关于”RxSwift和RxCocoa相关定义”的定义
3、只给出业务层代码，定义和基类代码不用给出
4、处理内存管理，避免内存泄漏
5、定义颜色用如：DPMHexColor(“#FFFFFF”) 或 DPMHexAColor("#000000", 0.5)
6、定义字体用如：DPMFont(size: 10, weight: .semibold)


六、自定义view要求：
1、继承于DPMBaseView
2、属性使用懒加载方式
3、子视图加载方式为:

	override func dpm_setupViews() {
        //加载子视图
        
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
    }

4、子视图布局
	override func updateConstraints() {
        //子视图布局
        
        super.updateConstraints()
    }

5、modul赋值及界面逻辑处理
	override func dpm_bindViewModel(_ viewModel: Any?) {
		guard let newViewModel = viewModel as? DPMBaseViewModel else {return}
        
        self.viewModel = newViewModel
		//modul赋值及界面逻辑处理

	}


七、自定义viewController要求：
1、继承于DPMBaseViewController
2、属性使用懒加载方式
3、子视图加载方式为:

	override func dpm_addSubviews() {
        //加载子视图
        
		self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }

4、子视图布局
	override func updateViewConstraints() {
        //子视图布局
        
        super.updateViewConstraints()
    }


5、modul赋值及界面逻辑处理
	override func dpm_bindViewModel() {
        super.dpm_bindViewModel()
		//modul赋值及界面逻辑处理

	}

6、viewController类定义可参考
	class DPMHomeContainerVC: DPMBaseViewController<DPMBaseViewModel> {

	}

八、自定义ViewModel可参考：
	class DPMHomeViewModel: DPMBaseViewModel {

		override func dpm_initialize() {
	        super.dpm_initialize()
			// 下面为传参举例
        		let categoryId = self.params[DPMConstants.shared.params.CategoryId] as? String ?? ""
        		self.categoryIdRelay.accept(categoryId)
    		}
	}


九、RxSwift和RxCocoa相关定义

// MARK: - Two way binding shorthand
// swiftlint:disable operator_whitespace
infix operator <~> : DefaultPrecedence

public func <~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property.bind(to: relay)
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

public func <~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property.bind(to: relay)
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}

// MARK: - One way binding shorthand

infix operator ~>: DefaultPrecedence

/// Observale
public func ~><T, R>(source: Observable<T>, binder: (Observable<T>) -> R) -> R {
    return source.bind(to: binder)
}

public func ~><T>(source: Observable<T>, binder: Binder<T>) -> Disposable {
    return source.bind(to: binder)
}

public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T>) -> Disposable {
    return source.bind(to: relay)
}

public func ~><T>(source: Observable<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.bind(to: relay)
}

public func ~><T>(source: BehaviorRelay<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.bind(to: relay)
}

public func ~><T>(source: BehaviorRelay<T>, relay: BehaviorRelay<T>) -> Disposable {
    return source.bind(to: relay)
}

/// Single
public func ~><T>(source: Single<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.subscribe(onSuccess: relay.accept)
}

/// Driver
public func ~><T>(source: Driver<T>, relay: BehaviorRelay<T?>) -> Disposable {
    return source.drive(onNext: relay.accept)
}

public func ~><T>(source: Driver<T>, binder: Binder<T>) -> Disposable {
    return source.drive(onNext: binder.onNext)
}

public func ~><T>(source: Observable<T>, property: ControlProperty<T>) -> Disposable {
    return source.bind(to: property)
}

/// BehaviorRelay
public func ~><T>(relay: BehaviorRelay<T>, observer: Binder<T>) -> Disposable {
    return relay.bind(to: observer)
}

public func ~><T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    return relay.bind(to: property)
}

public func ~><T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    return relay.bind(to: property)
}

/// ControlEvent
public func ~><T>(event: ControlEvent<T>, relay: BehaviorRelay<T>) -> Disposable {
    return event.bind(to: relay)
}

// MARK: - Add to dispose bag shorthand

precedencegroup DisposablePrecedence {
    lowerThan: DefaultPrecedence
}

infix operator =>: DisposablePrecedence

public func =>(disposable: Disposable?, bag: DisposeBag?) {
    if let dispose = disposable, let disposeBag = bag {
        dispose.disposed(by: disposeBag)
    }
}


