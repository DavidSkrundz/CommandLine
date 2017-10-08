//
//  Output.swift
//  CommandLine
//

import Foundation

public protocol Output {
	func receive(_ data: Data)
}
