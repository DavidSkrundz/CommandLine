//
//  AutoTaskTests.swift
//  CommandLine
//

import XCTest
import CommandLine

import Foundation

class AutoTaskTests: XCTestCase {
	func testArgumentCreation() {
		let string = "Some string to echo"
		let task = AutoTask(cmd: "echo", args: string)
		let output = task.run()
		XCTAssertEqual(String(bytes: output, encoding: .utf8), string + "\n")
	}
	
	func testStringCreation() {
		let string = "Some string to echo\n"
		let task: AutoTask = "echo Some string to echo"
		let output = task.run()
		XCTAssertEqual(String(bytes: output, encoding: .utf8), string)
	}
	
	func testListCreation() {
		let string = "Some string to echo"
		let task: AutoTask = ["echo", string]
		let output = task.run()
		XCTAssertEqual(String(bytes: output, encoding: .utf8), string + "\n")
	}
	
	func testTaskChainEnding() {
		let task: AutoTask = "echo A String"
		var output = Data()
		task > output
		XCTAssertEqual(String(bytes: output, encoding: .utf8), "A String\n")
	}
	
	func testTaskChaining() {
		var output = Data()
		let task: AutoTask = "grep d"
		let task2 = task | "tail -n 1"
		let solution = "def\n"
		"echo abc\n\(solution)abc" | task2 > output
		XCTAssertEqual(String(bytes: output, encoding: .utf8), solution)
	}
	
	func testStringToTask() {
		var output = Data()
		"echo abc\ndef\nabc" | "grep d" > output
		XCTAssertEqual(String(bytes: output, encoding: .utf8), "def\n")
	}
	
	func testStringOutput() {
		var output = ""
		AutoTask("echo to") > output
		AutoTask(cmd: "echo", args: [" string!"]) > output
		XCTAssertEqual(output, "to\n string!\n")
	}
	
	func testSetEnv() {
		let key = "SwiftTestStringKey"
		let value = "SwiftTestStringValue"
		var output = ""
		var task = AutoTask(cmd: "env")
		task.environment[key] = value
		task | "grep \(key)" > output
		XCTAssertEqual(output, "\(key)=\(value)\n")
	}
	
	/// A placeholder test to ensure `standardOut` compiles.
	/// This does not actually test that it works properly :(
	func testOutput() {
		"echo abc" > standardOut
	}
	
	static var allTests = [
		("testArgumentCreation", testArgumentCreation),
		("testStringCreation", testStringCreation),
		("testListCreation", testListCreation),
		("testTaskChainEnding", testTaskChainEnding),
		("testTaskChaining", testTaskChaining),
		("testStringToTask", testStringToTask),
		("testStringOutput", testStringOutput),
		("testSetEnv", testSetEnv),
		("testOutput", testOutput)
	]
}
