//
//  LinuxMain.swift
//  CommandLine
//

import XCTest
@testable import CommandLineTests

XCTMain([
	testCase(ArgumentParser.allTests),
	testCase(AutoTaskTests.allTests),
])
