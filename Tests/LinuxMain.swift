//
//  LinuxMain.swift
//  CommandLine
//

import XCTest
@testable import CommandLineTests

XCTMain([
	testCase(ArgumentParserTests.allTests),
	testCase(AutoTaskTests.allTests),
])
