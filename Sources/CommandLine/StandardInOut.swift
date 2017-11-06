//
//  StandardInOut.swift
//  CommandLine
//

import Foundation

public struct StandardOut: Output {
	fileprivate init() {}
	
	public func isTerminal() -> Bool {
		return isatty(fileno(stdout)) == 1
	}
	
	public func receive(_ data: Data) {
		let string = String(data: data, encoding: .utf8) ?? ""
		print(string, terminator: "")
	}
}

public struct StandardIn {
	fileprivate init() {}
	
	public func isTerminal() -> Bool {
		return isatty(fileno(stdin)) == 1
	}
}

public let standardIn: StandardIn = StandardIn()
public let standardOut: StandardOut = StandardOut()
