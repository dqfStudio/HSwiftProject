//
//  HWebCompositeViewTests.swift
//  FreeChat
//
//  Created by Wind on 2026-04-17.
//  Copyright © 2026 wind. All rights reserved.
//

//import XCTest
//@testable import FreeChat
//
//class HWebCompositeViewTests: XCTestCase {
//    
//    var compositeView: HWebCompositeView!
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        compositeView = HWebCompositeView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//    }
//    
//    override func tearDownWithError() throws {
//        compositeView = nil
//        try super.tearDownWithError()
//    }
//    
//    // 测试基本属性设置
//    func testBasicProperties() {
//        // 测试文本设置
//        let testText = "测试文本"
//        compositeView.text = testText
//        XCTAssertEqual(compositeView.text, testText)
//        
//        // 测试文本颜色设置
//        let testColor = UIColor.red
//        compositeView.textColor = testColor
//        XCTAssertEqual(compositeView.textColor, testColor)
//        
//        // 测试字体设置
//        let testFont = UIFont.boldSystemFont(ofSize: 18)
//        compositeView.textFont = testFont
//        XCTAssertEqual(compositeView.textFont, testFont)
//        
//        // 测试图片大小设置
//        let testSize = CGSize(width: 50, height: 50)
//        compositeView.imageSize = testSize
//        XCTAssertEqual(compositeView.imageSize, testSize)
//        
//        // 测试图片间距设置
//        let testSpace: CGFloat = 10
//        compositeView.imageSpace = testSpace
//        XCTAssertEqual(compositeView.imageSpace, testSpace)
//        
//        // 测试图片位置设置
//        let testPosition: HImagePosition = .top
//        compositeView.imagePosition = testPosition
//        XCTAssertEqual(compositeView.imagePosition, testPosition)
//    }
//    
//    // 测试状态管理
//    func testStateManagement() {
//        // 测试默认状态
//        XCTAssertEqual(compositeView.state, .normal)
//        
//        // 测试切换到选中状态
//        compositeView.state = .selected
//        XCTAssertEqual(compositeView.state, .selected)
//        
//        // 测试切换到禁用状态
//        compositeView.state = .disabled
//        XCTAssertEqual(compositeView.state, .disabled)
//        
//        // 测试切换到高亮状态
//        compositeView.state = .highlighted
//        XCTAssertEqual(compositeView.state, .highlighted)
//        
//        // 测试切换到加载状态
//        compositeView.state = .loading
//        XCTAssertEqual(compositeView.state, .loading)
//        
//        // 测试切换回正常状态
//        compositeView.state = .normal
//        XCTAssertEqual(compositeView.state, .normal)
//    }
//    
//    // 测试链式调用
//    func testChainSyntax() {
//        let testText = "链式调用测试"
//        let testColor = UIColor.blue
//        let testFont = UIFont.systemFont(ofSize: 16)
//        let testSize = CGSize(width: 44, height: 44)
//        let testSpace: CGFloat = 8
//        let testPosition: HImagePosition = .left
//        
//        let configuredView = compositeView
//            .text(testText)
//            .textColor(testColor)
//            .textFont(testFont)
//            .imageSize(testSize)
//            .imageSpace(testSpace)
//            .imagePosition(testPosition)
//        
//        XCTAssertEqual(configuredView.text, testText)
//        XCTAssertEqual(configuredView.textColor, testColor)
//        XCTAssertEqual(configuredView.textFont, testFont)
//        XCTAssertEqual(configuredView.imageSize, testSize)
//        XCTAssertEqual(configuredView.imageSpace, testSpace)
//        XCTAssertEqual(configuredView.imagePosition, testPosition)
//    }
//    
//    // 测试手势识别
//    func testGestureRecognition() {
//        // 测试点击手势
//        var tapped = false
//        compositeView.pressed = { _, _ in
//            tapped = true
//        }
//        
//        // 模拟点击
//        let tapGesture = UITapGestureRecognizer(target: compositeView, action: #selector(HWebCompositeView.tapAction))
//        compositeView.addGestureRecognizer(tapGesture)
//        tapGesture.simulate()
//        
//        // 测试长按手势
//        var longPressed = false
//        compositeView.longPressed = { _, _ in
//            longPressed = true
//        }
//        
//        // 模拟长按
//        let longPressGesture = UILongPressGestureRecognizer(target: compositeView, action: #selector(HWebCompositeView.longPressAction(_:)))
//        longPressGesture.minimumPressDuration = 0.1
//        compositeView.addGestureRecognizer(longPressGesture)
//        longPressGesture.simulate()
//        
//        // 测试双击手势
//        var doubleTapped = false
//        compositeView.doubleTapped = { _, _ in
//            doubleTapped = true
//        }
//        
//        // 模拟双击
//        let doubleTapGesture = UITapGestureRecognizer(target: compositeView, action: #selector(HWebCompositeView.doubleTapAction))
//        doubleTapGesture.numberOfTapsRequired = 2
//        compositeView.addGestureRecognizer(doubleTapGesture)
//        doubleTapGesture.simulate()
//        
//        // 测试滑动手势
//        var swiped = false
//        compositeView.swiped = { _, _ in
//            swiped = true
//        }
//        
//        // 模拟滑动
//        let swipeGesture = UISwipeGestureRecognizer(target: compositeView, action: #selector(HWebCompositeView.swipeAction(_:)))
//        swipeGesture.direction = .right
//        compositeView.addGestureRecognizer(swipeGesture)
//        swipeGesture.simulate()
//        
//        // 测试拖拽手势
//        var dragged = false
//        compositeView.dragged = { _, _, _ in
//            dragged = true
//        }
//        
//        // 模拟拖拽
//        let panGesture = UIPanGestureRecognizer(target: compositeView, action: #selector(HWebCompositeView.panAction(_:)))
//        compositeView.addGestureRecognizer(panGesture)
//        panGesture.simulate()
//    }
//    
//    // 测试新布局选项
//    func testNewLayoutOptions() {
//        // 测试图片居中布局
//        compositeView.imagePosition = .center
//        XCTAssertEqual(compositeView.imagePosition, .center)
//        
//        // 测试文字环绕布局
//        compositeView.imagePosition = .textWrap
//        XCTAssertEqual(compositeView.imagePosition, .textWrap)
//    }
//    
//    // 测试可访问性
//    func testAccessibility() {
//        let testLabel = "可访问性标签"
//        let testHint = "可访问性提示"
//        let testValue = "可访问性值"
//        
//        compositeView.accessibilityLabel = testLabel
//        compositeView.accessibilityHint = testHint
//        compositeView.accessibilityValue = testValue
//        compositeView.accessibilityTraits = .button
//        
//        XCTAssertEqual(compositeView.accessibilityLabel, testLabel)
//        XCTAssertEqual(compositeView.accessibilityHint, testHint)
//        XCTAssertEqual(compositeView.accessibilityValue, testValue)
//        XCTAssertEqual(compositeView.accessibilityTraits, .button)
//    }
//    
//    // 测试图片加载
//    func testImageLoading() {
//        // 测试设置网络图片
//        let testUrlString = "https://via.placeholder.com/44"
//        compositeView.imageUrlString = testUrlString
//        XCTAssertEqual(compositeView.imageUrlString, testUrlString)
//        
//        // 测试设置本地图片
//        let testImageName = "icon"
//        compositeView.setImage(named: testImageName)
//        // 无法直接测试图片是否加载成功，因为需要实际的图片资源
//    }
//    
//    // 测试外观定制
//    func testAppearanceCustomization() {
//        // 测试圆角设置
//        let testCornerRadius: CGFloat = 10
//        compositeView.cornerRadius = testCornerRadius
//        XCTAssertEqual(compositeView.cornerRadius, testCornerRadius)
//        
//        // 测试边框设置
//        let testBorderWidth: CGFloat = 2
//        let testBorderColor = UIColor.red
//        compositeView.borderWidth = testBorderWidth
//        compositeView.borderColor = testBorderColor
//        XCTAssertEqual(compositeView.borderWidth, testBorderWidth)
//        XCTAssertEqual(compositeView.borderColor, testBorderColor)
//        
//        // 测试阴影设置
//        let testShadowColor = UIColor.black
//        let testShadowOffset = CGSize(width: 0, height: 2)
//        let testShadowOpacity: Float = 0.5
//        let testShadowRadius: CGFloat = 4
//        compositeView.shadowColor = testShadowColor
//        compositeView.shadowOffset = testShadowOffset
//        compositeView.shadowOpacity = testShadowOpacity
//        compositeView.shadowRadius = testShadowRadius
//        XCTAssertEqual(compositeView.shadowColor, testShadowColor)
//        XCTAssertEqual(compositeView.shadowOffset, testShadowOffset)
//        XCTAssertEqual(compositeView.shadowOpacity, testShadowOpacity)
//        XCTAssertEqual(compositeView.shadowRadius, testShadowRadius)
//    }
//    
//    // 测试渐变背景
//    func testGradientBackground() {
//        let testColors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
//        let testStartPoint = CGPoint(x: 0, y: 0)
//        let testEndPoint = CGPoint(x: 1, y: 1)
//        
//        compositeView.gradientBackgroundColors = testColors
//        compositeView.gradientStartPoint = testStartPoint
//        compositeView.gradientEndPoint = testEndPoint
//        
//        XCTAssertEqual(compositeView.gradientBackgroundColors, testColors)
//        XCTAssertEqual(compositeView.gradientStartPoint, testStartPoint)
//        XCTAssertEqual(compositeView.gradientEndPoint, testEndPoint)
//    }
//}
//
//// 扩展UITapGestureRecognizer以支持模拟点击
//fileprivate extension UITapGestureRecognizer {
//    func simulate() {
//        if let target = self.targets.first?.target as? NSObject,
//           let action = self.targets.first?.action {
//            target.performSelector(onMainThread: action, with: self, waitUntilDone: true)
//        }
//    }
//}
//
//// 扩展UILongPressGestureRecognizer以支持模拟长按
//fileprivate extension UILongPressGestureRecognizer {
//    func simulate() {
//        if let target = self.targets.first?.target as? NSObject,
//           let action = self.targets.first?.action {
//            target.performSelector(onMainThread: action, with: self, waitUntilDone: true)
//        }
//    }
//}
//
//// 扩展UISwipeGestureRecognizer以支持模拟滑动
//fileprivate extension UISwipeGestureRecognizer {
//    func simulate() {
//        if let target = self.targets.first?.target as? NSObject,
//           let action = self.targets.first?.action {
//            target.performSelector(onMainThread: action, with: self, waitUntilDone: true)
//        }
//    }
//}
//
//// 扩展UIPanGestureRecognizer以支持模拟拖拽
//fileprivate extension UIPanGestureRecognizer {
//    func simulate() {
//        if let target = self.targets.first?.target as? NSObject,
//           let action = self.targets.first?.action {
//            target.performSelector(onMainThread: action, with: self, waitUntilDone: true)
//        }
//    }
//}
