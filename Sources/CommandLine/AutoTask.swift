//
//  AutoTask.swift
//  CommandLine
//

import Foundation

#if os(macOS)
private typealias Task = Process
#endif

/// A wrapper for `Task` with auto piping
public struct AutoTask {
	public typealias Element = String
	
	fileprivate let tasks: [Task]
	fileprivate let pipes: [Pipe]
	
	/// - get: Returns the environment variables of the first task
	/// - set: Set the environment variables for all tasks
	public var environment: [String : String] {
		get {
			let defaultEnvironment = ProcessInfo.processInfo.environment
			return self.tasks[0].environment ?? defaultEnvironment
		}
		set {
			self.tasks.forEach { $0.environment = newValue }
		}
	}
	
	fileprivate init(tasks: [Task], pipes: [Pipe]) {
		self.tasks = tasks
		self.pipes = pipes
	}
	
	public init(_ command: String, _ arguments: String...) {
		self.tasks = [AutoTask.createTask([command] + arguments)]
		self.pipes = []
	}
	
	public init(_ command: String, arguments: [String]) {
		self.tasks = [AutoTask.createTask([command] + arguments)]
		self.pipes = []
	}
	
	public init(_ command: String) {
		self.tasks = [AutoTask.createTask(command.components(separatedBy: " "))]
		self.pipes = []
	}
	
	fileprivate init(arguments: [String]) {
		self.tasks = [AutoTask.createTask(arguments)]
		self.pipes = []
	}
	
	fileprivate static func createTask(_ arguments: [String]) -> Task {
		let task = Task()
		task.launchPath = "/usr/bin/env"
		task.arguments = arguments
		return task
	}
	
	/// Set the environment variable for all tasks
	public func setEnvironmentVariable(_ name: String, value: String) {
		let defaultEnvironment = ProcessInfo.processInfo.environment
		self.tasks.forEach {
			var environment = $0.environment ?? defaultEnvironment
			environment[name] = value
			$0.environment = environment
		}
	}
}

extension AutoTask: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.tasks = [AutoTask.createTask(value.components(separatedBy: " "))]
		self.pipes = []
	}
	
	public init(extendedGraphemeClusterLiteral value: Character) {
		self.tasks = [AutoTask.createTask([String(value)])]
		self.pipes = []
	}
	
	public init(unicodeScalarLiteral value: UnicodeScalar) {
		self.tasks = [AutoTask.createTask([String(Character(value))])]
		self.pipes = []
	}
}

extension AutoTask: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Element...) {
		self.tasks = [AutoTask.createTask(elements)]
		self.pipes = []
	}
}

public func |(lhs: AutoTask, rhs: AutoTask) -> AutoTask {
	let newPipe = Pipe()
	lhs.tasks.last!.standardOutput = newPipe
	rhs.tasks.first!.standardInput = newPipe
	
	let tasks = lhs.tasks + rhs.tasks
	let pipes = lhs.pipes + [newPipe] + rhs.pipes
	return AutoTask(tasks: tasks, pipes: pipes)
}

public func |(lhs: String, rhs: String) -> AutoTask {
	return AutoTask(stringLiteral: lhs) | AutoTask(stringLiteral: rhs)
}

public func |(lhs: [String], rhs: String) -> AutoTask {
	return AutoTask(arguments: lhs) | AutoTask(stringLiteral: rhs)
}

public func |(lhs: String, rhs: [String]) -> AutoTask {
	return AutoTask(stringLiteral: lhs) | AutoTask(arguments: rhs)
}

public func |(lhs: [String], rhs: [String]) -> AutoTask {
	return AutoTask(arguments: lhs) | AutoTask(arguments: rhs)
}

public func >(lhs: AutoTask, rhs: (String) -> ()) {
	let finalPipe = Pipe()
	lhs.tasks.last!.standardOutput = finalPipe
	
	lhs.tasks.forEach { $0.launch() }
	
	var outputBuffer = ""
	while true {
		let data = finalPipe.fileHandleForReading.availableData
		if data.count == 0 { break }
		
		let string = String(data: data, encoding: .utf8) ?? ""
		outputBuffer.append(string)
		
		var lines = outputBuffer.components(separatedBy: "\n")
		outputBuffer = lines.removeLast()
		lines
			.map { $0 + "\n" }
			.forEach(rhs)
	}
	
	let data = finalPipe.fileHandleForReading.readDataToEndOfFile()
	outputBuffer += String(data: data, encoding: .utf8) ?? ""
	if outputBuffer.characters.count > 0 {
		rhs(outputBuffer)
	}
}

public func >(lhs: AutoTask, rhs: Output) {
	lhs > rhs.receive
}

public func >(lhs: AutoTask, rhs: inout String) {
	lhs > { rhs.append($0) }
}
