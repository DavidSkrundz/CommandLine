//
//  ParseError.swift
//  CommandLine
//

public enum ParseError: Error {
	/// Flag, Argument, Expected
	case invalidArgument(String, String, String)
	
	/// Flag, Expected
	case missingArgument(String, String)
	
	/// Flag
	case invalidFlag(String)
}
