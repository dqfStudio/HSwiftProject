//
//  HSwiftProjectTests.swift
//  HSwiftProjectTests
//
//  Created by owner on 2025/3/31.
//  Copyright © 2025 wind. All rights reserved.
//

//import Testing
//
//struct HSwiftProjectTests {
//
//    @Test func example() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    }
//
//}

//import Testing
//
//// 定义一个简单的加法函数
//func add(_ a: Int, _ b: Int) -> Int {
//    return a + b
//}
//
//struct HSwiftProjectTests {
//
//    @Test func example() async throws {
//        // 调用 add 函数
//        let result = add(2, 3)
//        // 使用 #expect 验证结果是否符合预期
//        #expect(result == 5)
//    }
//
//}

//import Testing
//
//// 定义一个异步函数
//func asyncFetchData() async -> String {
//    // 模拟异步操作
//    try? await Task.sleep(nanoseconds: 1_000_000_000)
//    return "Fetched Data"
//}
//
//struct HSwiftProjectTests {
//
//    @Test func example() async throws {
//        // 调用异步函数
//        let data = await asyncFetchData()
//        // 使用 #expect 验证结果是否符合预期
//        #expect(data == "Fetched Data")
//    }
//
//}

import Testing
@testable import HSwiftProject

// 假设这是项目中的一个类
//class MyClass {
//    var counter = 0
//    func incrementCounter() {
//        counter += 1
//    }
//}

struct HSwiftProjectTests {

    @Test func testIncrementCounter() async throws {
        let myObject = await HMainController1()
        let result = await myObject.add(2, 3)
        #expect(result == 5)
    }

}    
