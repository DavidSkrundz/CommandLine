//
//  ANSI.swift
//  CommandLine
//

public enum ANSI {
	public enum Text {
		public enum Style {
			public static let Reset =       "\u{1B}[0m"
			
			public static let Bold =        "\u{1B}[1m"
			public static let Faint =       "\u{1B}[2m"
			public static let Normal =      "\u{1B}[22m"
			
			public static let Underline =   "\u{1B}[4m"
			public static let NoUnderline = "\u{1B}[24m"
			
			public static let Blink =       "\u{1B}[5m"
			public static let NoBlink =     "\u{1B}[25m"
			
			public static let Invert =      "\u{1B}[7m"
			public static let NoInvert =    "\u{1B}[27m"
			
			public static let Conceal =     "\u{1B}[8m"
			public static let NoConceal =   "\u{1B}[28m"
		}
		
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
	
	public enum Background {
		public enum Color {
			public static let Default = "\u{1B}[49m"
			
			public static let Black =   "\u{1B}[40m"
			public static let Red =     "\u{1B}[41m"
			public static let Green =   "\u{1B}[42m"
			public static let Yellow =  "\u{1B}[43m"
			public static let Blue =    "\u{1B}[44m"
			public static let Magenta = "\u{1B}[45m"
			public static let Cyan =    "\u{1B}[46m"
			public static let White =   "\u{1B}[47m"
		}
	}
	
	public enum Cursor {
		public static let Hide = "\u{1B}[?25l"
		public static let Show = "\u{1B}[?25h"
		
		public enum Move {
			public static func Up(_ n: Int) -> String {
				return "\u{1B}[\(n)A"
			}
			
			public static func Down(_ n: Int) -> String {
				return "\u{1B}[\(n)B"
			}
			
			public static func Right(_ n: Int) -> String {
				return "\u{1B}[\(n)C"
			}
			
			public static func Left(_ n: Int) -> String {
				return "\u{1B}[\(n)D"
			}
		}
		
		// TODO:
		public static func Next(_ n: Int) -> String {
			return "\u{1B}[\(n)E"
		}
		// TODO:
		public static func Previous(_ n: Int) -> String {
			return "\u{1B}[\(n)F"
		}
		
		public enum Set {
			public static func Column  (_ x: Int) -> String {
				return "\u{1B}[\(x)G"
			}
			
			public static func Position(_ x: Int, _ y: Int) -> String {
				return "\u{1B}[\(y);\(x)H"
			}
		}
	}
	
	public enum Terminal {
		public static let ClearToEnd =       "\u{1B}[0J"
		public static let ClearToStart =     "\u{1B}[1J"
		public static let Clear =            "\u{1B}[2J"
		
		public enum Line {
			public static let ClearToEnd =   "\u{1B}[0K"
			public static let ClearToStart = "\u{1B}[1K"
			public static let Clear =        "\u{1B}[2K"
		}
		
		public enum Scroll {
			public static func Up(_ n: Int) -> String {
				return "\u{1B}[\(n)S"
			}
			
			public static func Down(_ n: Int) -> String {
				return "\u{1B}[\(n)T"
			}
		}
	}
}
