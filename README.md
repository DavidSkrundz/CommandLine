# CommandLine

[![](https://img.shields.io/badge/Swift-5.0--5.3-orange.svg)][1]
[![](https://img.shields.io/badge/os-macOS%20|%20Linux-lightgray.svg)][1]
[![](https://travis-ci.com/DavidSkrundz/CommandLine.svg?branch=master)][2]
[![](https://codebeat.co/badges/46f0d430-fa26-401f-94d1-b95130fcf9c2)][3]
[![](https://codecov.io/gh/DavidSkrundz/CommandLine/branch/master/graph/badge.svg)][4]

[1]: https://swift.org/download/#releases
[2]: https://travis-ci.com/DavidSkrundz/CommandLine
[3]: https://codebeat.co/projects/github-com-davidskrundz-commandline
[4]: https://codecov.io/gh/DavidSkrundz/CommandLine

Parse arguments and use command-line tools from Swift.

```Swift
"ls -l" | "head -5" > standardOut
```

## Importing

```Swift
import CommandLine
```

```Swift
dependencies: [
	.package(url: "https://github.com/DavidSkrundz/CommandLine.git",
	         from: "2.0.0")
],
targets: [
	.target(
		name: "",
		dependencies: [
			"CommandLine"
		]),
]
```

## Using

### `ArgumentParser`

Parses options from a given list of arguments. By default it uses the arguments provided to the application.

Respects `--` to stop processing arguments

```Swift
let parser = ArgumentParser(strict: Bool = false)
try parser.parse(args: [String] = Arguments)
let usageOptions = parser.usage()
```

#### Options

```Swift
.boolOption(short:long:description:closure:)
.boolOption(short:long:negativeShort:negativeLong:description:closure:)
.intOption(short:long:description:closure:)
.doubleOption(short:long:description:closure:)
.stringOption(short:long:description:closure:)
```

### `AutoTask`

A simple wrapper around `Process` that automatically pipes between AutoTasks.

StdErr is ignored.

###### Init

```Swift
let task = AutoTask(cmd: "echo", args: "a", "b", "c")
```
```Swift
let task: AutoTask = "echo a b c"
```
```Swift
let task: AutoTask = ["echo", "a", "b", "c"]
```

###### Piping

```Swift
let echo = AutoTask(cmd: "echo", args: "a\nb\nc")
```
```Swift
let grep = AutoTask(cmd: "grep", args: "c")
```
```Swift
let tasks = echo | grep
```

###### Running

```Swift
let output: Data = task.run()
```
```Swift
var output = Data()
task > output
```
```Swift
var output = ""
task > output
```
```Swift
task > standardOut
```
