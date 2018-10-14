//
//  TestCount.swift
//  CommandLineTests
//

import XCTest

protocol TestCase {
	static var allTests: [(String, (Self) -> () -> ())] { get }
}

#if os(macOS)

final class TestCount: XCTestCase {
	func testTestCount() {
		AssertTestCount(ArgumentParserTests.self)
		AssertTestCount(AutoTaskTests.self)
	}
}

func AssertTestCount<T: XCTestCase & TestCase>(_ T: T.Type) {
	let allTestsCount = T.allTests.count
	let testCount = T.defaultTestSuite.testCaseCount
	let difference = testCount - allTestsCount
	XCTAssertEqual(allTestsCount, testCount,
				   "\(difference) tests are missing from \(String(describing: T)).allTests")
}

#endif
