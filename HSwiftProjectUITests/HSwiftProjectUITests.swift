//
//  HSwiftProjectUITests.swift
//  HSwiftProjectUITests
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

//import XCTest
//
//final class HSwiftProjectUITests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    @MainActor
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    @MainActor
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//}


import XCTest

final class HSwiftProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    @MainActor
    func testButtonTap() throws {
        // 启动应用
        let app = XCUIApplication()
        app.launch()

        // 查找按钮元素，假设按钮的 accessibilityIdentifier 为 "myButton"
        let button = app.buttons["myButton"]

        // 验证按钮是否存在
        XCTAssertTrue(button.exists, "按钮未找到")

        // 点击按钮
        button.tap()

        // 查找点击按钮后应该出现的元素，假设是一个标签，accessibilityIdentifier 为 "resultLabel"
        let resultLabel = app.staticTexts["resultLabel"]

        // 验证标签是否存在
        XCTAssertTrue(resultLabel.exists, "点击按钮后结果标签未出现")

        // 验证标签的文本内容是否符合预期
        XCTAssertEqual(resultLabel.label, "按钮已点击", "结果标签的文本内容不符合预期")
    }
    
}
