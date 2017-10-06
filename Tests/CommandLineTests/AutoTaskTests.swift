//
//  AutoTaskTests.swift
//  CommandLine
//

import XCTest
import CommandLine

class AutoTaskTests: XCTestCase {
	func testInit() {
		let string = "Some string to echo"
		let task = AutoTask("echo", string)
		let (output, error) = task.run()
		XCTAssertEqual(output, string)
		XCTAssertEqual(error, "")
	}
	
	static var allTests = [
		("testInit", testInit)
	]
}

