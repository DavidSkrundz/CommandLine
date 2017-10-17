//
//  ANSI.swift
//  CommandLine
//

public enum ANSI {
	public enum Text {
		public enum Color {
			public static let Default = "\u{1B}[39m"
			
			public static let Black =   "\u{1B}[30m"
			public static let Red =     "\u{1B}[31m"
			public static let Green =   "\u{1B}[32m"
			public static let Yellow =  "\u{1B}[33m"
			public static let Blue =    "\u{1B}[34m"
			public static let Magenta = "\u{1B}[35m"
			public static let Cyan =    "\u{1B}[36m"
			public static let White =   "\u{1B}[37m"
		}
	}
}
