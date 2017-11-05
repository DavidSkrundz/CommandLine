//
//  Option.swift
//  CommandLine
//

internal struct Option {
	internal let argumentCount: Int
	internal let shortFlag: Character?
	internal let longFlag: String?
	internal let description: String
	internal let closure: ([String]) throws -> Void
	
	internal init(argumentCount: Int,
	              short: Character?, long: String?,
				  description: String,
	              closure: @escaping ([String]) throws -> Void) {
		self.argumentCount = argumentCount
		self.shortFlag = short
		self.longFlag = long
		self.description = description
		self.closure = closure
	}
}
