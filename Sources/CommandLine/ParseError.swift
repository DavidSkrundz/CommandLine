//
//  ParseError.swift
//  CommandLine
//

public enum ParseError: Error, CustomStringConvertible {
	/// Flag
	case invalidFlag(String)
	
	/// Flag, Expected
	case missingArgument(String, String)
	
	/// Flag, Argument, Expected
	case invalidArgument(String, String, String)
	
	public var description: String {
		switch self {
			case let .invalidFlag(f):
				return "Invalid flag: \(f)"
			case let .missingArgument(f, e):
				return "Missing argument for \(f). Expecting: \(e)"
			case let .invalidArgument(f, a, e):
				return "Invalid argument for \(f). Got \(a), Expecting: \(e)"
		}
	}
}
