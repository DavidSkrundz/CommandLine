//
//  StandardOut.swift
//  CommandLine
//

import Foundation

private struct StandardOutStruct: Output {
	fileprivate func receive(_ data: Data) {
		let string = String(data: data, encoding: .utf8) ?? ""
		print(string, terminator: "")
	}
}

public let standardOut: Output = StandardOutStruct()
