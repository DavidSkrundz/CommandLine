//
//  CommandLineTests.swift
//  CommandLine
//

@testable import CommandLine
import XCTest

class CommandLineTests: XCTestCase {
	func testStringOuput() {
		let input = "some string to echo"
		
		var result = ""
		["echo", input] > result
		
		XCTAssertEqual(input + "\n", result)
	}
	
	func testPipe() {
		let input = "1\n2\n3"
		
		var result = ""
		"echo \(input)" | "grep 2" > result
		
		XCTAssertEqual("2\n", result)
	}
	
	func testPrint() {
		"This line should not have an empty line underneath" > StandardOut
	}
	
	static var allTests = [
		("testStringOuput", testStringOuput),
		("testPipe", testPipe),
		("testPrint", testPrint),
	]
}
