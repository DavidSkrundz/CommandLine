//
//  ArgumentParserTests.swift
//  CommandLineTests
//

import XCTest
import CommandLine

final class ArgumentParserTests: XCTestCase {
	func testShortBool() {
		let parser = ArgumentParser()
		
		var aValue = false
		parser.boolOption(short: "a") { aValue = true }
		
		do {
			let remainingArgs = try parser.parse(args: ["-a"])
			XCTAssertTrue(aValue)
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testLongBool() {
		let parser = ArgumentParser()
		
		var aValue = false
		parser.boolOption(long: "all") { aValue = true }
		
		do {
			let remainingArgs = try parser.parse(args: ["--all"])
			XCTAssertTrue(aValue)
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testNegativeBool() {
		let parser = ArgumentParser()
		
		var values = [Bool]()
		parser.boolOption(short: "y", negativeShort: "n") { values.append($0) }
		
		do {
			let remainingArgs = try parser.parse(args: ["-y", "-n"])
			XCTAssertEqual(values, [true, false])
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testShortInt() {
		let parser = ArgumentParser()
		
		var values = [Int]()
		parser.intOption(short: "i") { values.append($0) }
		
		do {
			let remainingArgs = try parser.parse(args: ["-i1", "-i", "5"])
			XCTAssertEqual(values, [1, 5])
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testLongInt() {
		let parser = ArgumentParser()
		
		var values = [Int]()
		parser.intOption(long: "int") { values.append($0) }
		
		do {
			let remainingArgs = try parser.parse(args: ["--int", "1", "--int=5"])
			XCTAssertEqual(values, [1, 5])
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testMultipleShort() {
		let parser = ArgumentParser()
		
		var values = [Int]()
		parser.intOption(short: "i") { values.append($0) }
		parser.boolOption(short: "b") { values.append(0) }
		
		do {
			let remainingArgs = try parser.parse(args: ["-bbi1", "-bbi", "2"])
			XCTAssertEqual(values, [0, 0, 1, 0, 0, 2])
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testStopper() {
		let parser = ArgumentParser()
		
		var count = 0
		parser.boolOption(short: "b") { count += 1 }
		
		do {
			let remainingArgs = try parser.parse(args: ["-b", "-b", "--", "-b"])
			XCTAssertEqual(count, 2)
			XCTAssertEqual(remainingArgs, ["-b"])
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testShortString() {
		let parser = ArgumentParser()
		
		var values = [String]()
		parser.stringOption(short: "s") { values.append($0) }
		
		do {
			_ = try parser.parse(args: ["-saaa", "-s", "bbb"])
			XCTAssertEqual(values, ["aaa", "bbb"])
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testLongString() {
		let parser = ArgumentParser()
		
		var values = [String]()
		parser.stringOption(long: "string") { values.append($0) }
		
		do {
			_ = try parser.parse(args: ["--string", "aaa", "--string=bbb"])
			XCTAssertEqual(values, ["aaa", "bbb"])
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testNonInteger() {
		let parser = ArgumentParser()
		parser.intOption(short: "i") { _ in }
		parser.intOption(long: "int") { _ in }
		
		do {
			_ = try parser.parse(args: ["-ia"])
		} catch let error as ParseError {
			switch error {
				case .invalidArgument("i", "a", "Integer"): ()
				default: XCTFail("Threw Error: \(error)")
			}
		} catch let error { XCTFail("Threw Error: \(error)") }
		
		do {
			_ = try parser.parse(args: ["--int=a"])
		} catch let error as ParseError {
			switch error {
				case .invalidArgument("int", "a", "Integer"): ()
				default: XCTFail("Threw Error: \(error)")
			}
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testMissingArgument() {
		let parser = ArgumentParser()
		parser.intOption(short: "i") { _ in }
		
		do {
			_ = try parser.parse(args: ["-i"])
		} catch let error as ParseError {
			switch error {
				case .missingArgument("i", "Integer"): ()
				default: XCTFail("Threw Error: \(error)")
			}
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testInvalidShortFlag() {
		let parser = ArgumentParser()
		
		do {
			let remainingArgs = try parser.parse(args: ["-i"])
			XCTAssertEqual(remainingArgs, ["-i"])
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testInvalidLongFlag() {
		let parser = ArgumentParser()
		
		do {
			let remainingArgs = try parser.parse(args: ["--invalid"])
			XCTAssertEqual(remainingArgs, ["--invalid"])
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testInvalidShortFlagThrows() {
		let parser = ArgumentParser(strict: true)
		
		do {
			_ = try parser.parse(args: ["-i"])
			XCTFail("Did not throw")
		} catch let error as ParseError {
			switch error {
				case .invalidFlag("-i"): ()
				default: XCTFail("Threw Error: \(error)")
			}
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testInvalidLongFlagThrows() {
		let parser = ArgumentParser(strict: true)
		
		do {
			_ = try parser.parse(args: ["--invalid"])
			XCTFail("Did not throw")
		} catch let error as ParseError {
			switch error {
				case .invalidFlag("--invalid"): ()
				default: XCTFail("Threw Error: \(error)")
			}
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
	
	func testUsage() {
		let parser = ArgumentParser()
		parser.boolOption(short: "y", long: "yes",
						  description: "aaa",
						  negativeLong: "no",
						  negativeDescription: "bbb") { _ in }
		parser.intOption(short: "i", description: "ccc") { _ in }
		let usage = parser.usage()
		print(usage)
	}
	
	func testDoubleOption() {
		let parser = ArgumentParser()
		
		var value = 0.0
		parser.doubleOption(long: "double") { value = $0 }
		
		do {
			let remainingArgs = try parser.parse(args: ["--double", "4.1"])
			XCTAssertEqual(value, 4.1)
			XCTAssertTrue(remainingArgs.isEmpty)
		} catch let error { XCTFail("Threw Error: \(error)") }
	}
}

extension ArgumentParserTests: TestCase {
	static var allTests = [
		("testShortBool", testShortBool),
		("testLongBool", testLongBool),
		("testNegativeBool", testNegativeBool),
		("testShortInt", testShortInt),
		("testLongInt", testLongInt),
		("testMultipleShort", testMultipleShort),
		("testStopper", testStopper),
		("testShortString", testShortString),
		("testLongString", testLongString),
		("testNonInteger", testNonInteger),
		("testMissingArgument", testMissingArgument),
		("testInvalidShortFlag", testInvalidShortFlag),
		("testInvalidLongFlag", testInvalidLongFlag),
		("testInvalidShortFlagThrows", testInvalidShortFlagThrows),
		("testInvalidLongFlagThrows", testInvalidLongFlagThrows),
		("testUsage", testUsage),
		("testDoubleOption", testDoubleOption),
	]
}
