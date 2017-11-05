//
//  ArgumentParser.swift
//  CommandLine
//

import Generator

private let shortOptionPrefix = "-"
private let longOptionPrefix = "--"
private let argumentStopper = "--"
private let argumentAttacher = "="

/// Parses commandline arguments
public class ArgumentParser {
	private let strict: Bool
	private var options = [Option]()
	
	/// Create a new ArgumentParser
	///
	/// - Parameter strict: Fail to parse if any unrecognized flags are passed.
	///                     Defaults to `false`
	public init(strict: Bool = false) {
		self.strict = strict
	}
	
	/// Add a boolean option
	///
	/// - Parameter short: The option's short flag
	/// - Parameter long: The option's long flag
	/// - Parameter closure: Gets called when the flag is parsed
	public func boolOption(short: Character? = nil,
	                       long: String? = nil,
						   description: String = "",
	                       _ closure: @escaping () -> Void) {
		guard short != nil || long != nil else { return }
		let option = Option(argumentCount: 0,
							short: short, long: long,
							description: description) { _ in
			closure()
		}
		self.options.append(option)
	}
	
	/// Add a boolean option
	///
	/// - Parameter short: The positive option's short flag
	/// - Parameter negativeShort: The negative option`s short flag
	/// - Parameter long: The positive option's long flag
	/// - Parameter negativeLong: The negative option's long flag
	/// - Parameter closure: Gets called when the flag is parsed
	public func boolOption(short: Character? = nil,
						   long: String? = nil,
						   description: String = "",
						   negativeShort: Character? = nil,
						   negativeLong: String? = nil,
						   negativeDescription: String = "",
						   _ closure: @escaping (Bool) -> Void) {
		if short != nil || long != nil {
			self.boolOption(short: short, long: long,
							description: description) { closure(true) }
		}
		if negativeShort != nil || negativeLong != nil {
			self.boolOption(short: negativeShort, long: negativeLong,
							description: negativeDescription) { closure(false) }
		}
	}
	
	/// Add an integer option
	///
	/// - Parameter short: The option's short flag
	/// - Parameter long: The option's long flag
	/// - Parameter closure: Gets called when the flag is parsed
	public func intOption(short: Character? = nil,
						  long: String? = nil,
						  description: String = "",
						  _ closure: @escaping (Int) -> Void) {
		guard short != nil || long != nil else { return }
		let option = Option(argumentCount: 1,
							short: short, long: long,
							description: description) { arg in
			guard arg.count == 2 else {
				throw ParseError.missingArgument(arg[0], "Integer")
			}
			guard let int = Int(arg[1]) else {
				throw ParseError.invalidArgument(arg[0], arg[1], "Integer")
			}
			closure(int)
		}
		self.options.append(option)
	}
	
	/// Add a double option
	///
	/// - Parameter short: The option's short flag
	/// - Parameter long: The option's long flag
	/// - Parameter closure: Gets called when the flag is parsed
	public func doubleOption(short: Character? = nil,
							 long: String? = nil,
							 description: String = "",
							 _ closure: @escaping (Double) -> Void) {
		guard short != nil || long != nil else { return }
		let option = Option(argumentCount: 1,
							short: short, long: long,
							description: description) { arg in
			guard arg.count == 2 else {
				throw ParseError.missingArgument(arg[0], "Double")
			}
			guard let int = Double(arg[1]) else {
				throw ParseError.invalidArgument(arg[0], arg[1], "Double")
			}
			closure(int)
		}
		self.options.append(option)
	}
	
	/// Add a string option
	public func stringOption(short: Character? = nil,
							 long: String? = nil,
							 description: String = "",
							 _ closure: @escaping (String) -> Void) {
		guard short != nil || long != nil else { return }
		let option = Option(argumentCount: 1,
							short: short, long: long,
							description: description) { arg in
			guard arg.count == 2 else {
				throw ParseError.missingArgument(arg[0], "String")
			}
			closure(arg[1])
		}
		self.options.append(option)
	}
	
	/// Parse a list of arguments and return a list of unprocesses arguments
	///
	/// - Parameter args: A list of arguments or the commandline arguments by
	///                   default
	///
	/// - Throws: ParseError
	///
	/// - Returns: Unparsed arguments
	public func parse(args: [String] = Array(CommandLine.arguments.dropFirst()))
		throws -> [String] {
			var nonOptionArguments = [String]()
			nonOptionArguments.reserveCapacity(args.count)
			
			var generator = args.generator()
			while let argument = generator.next() {
				if argument == argumentStopper {
					let rest = generator.remainingItems()
					nonOptionArguments.append(contentsOf: rest)
					generator.advanceBy(rest.count)
					continue
				}
				
				if argument.hasPrefix(longOptionPrefix) {
					var flagArg = argument
						.dropFirst(2)
						.split(separator: "=", maxSplits: 1)
						.map(String.init)
					let flag = flagArg.first!
					if let option = self.options
						.filter({ $0.longFlag == flag })
						.first {
						if option.argumentCount == 0 {
							if flagArg.count > 1 {
								throw ParseError.invalidArgument(flag,
																 flagArg[1],
																 "Nothing")
							}
							try option.closure(flagArg)
						} else {
							var extraArgs = option.argumentCount
							if flagArg.count > 1 {
								extraArgs -= 1
							}
							for _ in 0..<extraArgs {
								if let next = generator.next() {
									flagArg.append(next)
								}
							}
							try option.closure(flagArg)
						}
					} else {
						if self.strict {
							throw ParseError.invalidFlag("--\(flag)")
						} else {
							nonOptionArguments.append("--\(flag)")
						}
					}
					continue
				}
				
				if argument.hasPrefix(shortOptionPrefix) {
					var flags = argument.dropFirst().generator()
					while let flag = flags.next() {
						var closureArgs = [String(flag)]
						if let option = self.options
							.filter({ $0.shortFlag == flag })
							.first {
							if option.argumentCount == 0 {
								try option.closure(closureArgs)
							} else {
								let remaining = String(flags.remainingItems())
								var extraArgs = option.argumentCount
								if !remaining.isEmpty {
									closureArgs.append(remaining)
									flags.advanceBy(remaining.count)
									extraArgs -= 1
								}
								for _ in 0..<extraArgs {
									if let next = generator.next() {
										closureArgs.append(next)
									}
								}
								try option.closure(closureArgs)
							}
						} else {
							if self.strict {
								throw ParseError.invalidFlag("-\(flag)")
							} else {
								nonOptionArguments.append("-\(flag)")
							}
						}
					}
					continue
				}
				
				nonOptionArguments.append(argument)
			}
			
			return nonOptionArguments
	}
	
	/// - Returns: The usage string for the options provided
	public func usage() -> String {
		let firstLine = "OPTIONS:"
		let options = self.options.map { option -> String in
			var string = "  "
			if let flag = option.longFlag {
				string += longOptionPrefix
				string += flag
			}
			if let f = option.shortFlag {
				if string.count > 2 {
					string += ", "
				}
				string += shortOptionPrefix
				string.append(f)
			}
			for _ in 0..<option.argumentCount {
				string += " <value>"
			}
			if string.count < 26 {
				string.append(contentsOf: repeatElement(" ",
														count: 26-string.count))
			} else {
				string.append("\n")
				string.append(contentsOf: repeatElement(" ", count: 26))
			}
			string += option.description
			return string
		}
		return ([firstLine] + options).joined(separator: "\n")
	}
}
