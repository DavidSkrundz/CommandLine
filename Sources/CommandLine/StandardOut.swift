//
//  StandardOut.swift
//  CommandLine
//

private struct StandardOutStruct: Output {
	fileprivate func receive(_ input: String) {
		print(input, terminator: "")
	}
}

public let StandardOut: Output = StandardOutStruct()
