//
//  AutoTask.swift
//  CommandLine
//

import Foundation

/// A wrapper for `Process` with automatic simple piping.
public struct AutoTask {
	fileprivate let tasks: [Process]
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
	
	fileprivate init(tasks: [Process], pipes: [Pipe]) {
		self.tasks = tasks
		self.pipes = pipes
	}
	
	public init(cmd: String, args: String...) {
		self.tasks = [
			AutoTask.createProcess([cmd] + args)
		]
		self.pipes = []
	}
	
	/// Synchronously run every `Process` in `self`
	///
	/// - Returns: The output of the last `Process`.
	public func run() -> Data {
		var buffer = Data()
		self > buffer
		return buffer
	}
	
	private static func createProcess(_ arguments: [String]) -> Process {
		let process = Process()
		process.launchPath = "/usr/bin/env"
		process.arguments = arguments
		return process
	}
}

extension AutoTask: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		self.tasks = [
			AutoTask.createProcess(value.components(separatedBy: " "))
		]
		self.pipes = []
	}
}

extension AutoTask: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: String...) {
		self.tasks = [
			AutoTask.createProcess(elements)
		]
		self.pipes = []
	}
}

private func >(lhs: AutoTask, rhs: (Data) -> ()) {
	let pipe = Pipe()
	lhs.tasks.last!.standardOutput = pipe
	lhs.tasks.forEach { $0.launch() }
	
	while true {
		let data = pipe.fileHandleForReading.availableData
		if data.isEmpty { break }
		rhs(data)
	}
}

public func >(lhs: AutoTask, rhs: Output) {
	lhs > rhs.receive
}

public func >(lhs: AutoTask, rhs: inout Data) {
	lhs > { rhs.append($0) }
}

public func >(lhs: AutoTask, rhs: inout String) {
	lhs > { rhs.append(String(data: $0, encoding: .utf8) ?? "") }
}

public func |(lhs: AutoTask, rhs: AutoTask) -> AutoTask {
	let newPipe = Pipe()
	lhs.tasks.last!.standardOutput = newPipe
	rhs.tasks.first?.standardInput = newPipe
	
	let tasks = lhs.tasks + rhs.tasks
	let pipes = lhs.pipes + rhs.pipes
	return AutoTask(tasks: tasks, pipes: pipes)
}

public func |(lhs: AutoTask, rhs: String) -> AutoTask {
	return lhs | AutoTask(stringLiteral: rhs)
}

public func |(lhs: String, rhs: AutoTask) -> AutoTask {
	return AutoTask(stringLiteral: lhs) | rhs
}

public func |(lhs: String, rhs: String) -> AutoTask {
	return AutoTask(stringLiteral: lhs) | AutoTask(stringLiteral: rhs)
}
