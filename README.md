CommandLine [![Swift Version](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org/download/#releases) [![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg)](https://swift.org/download/#releases) [![Build Status](https://travis-ci.org/DavidSkrundz/CommandLine.svg?branch=master)](https://travis-ci.org/DavidSkrundz/CommandLine) [![Codebeat Status](https://codebeat.co/badges/46f0d430-fa26-401f-94d1-b95130fcf9c2)](https://codebeat.co/projects/github-com-davidskrundz-commandline) [![Codecov](https://codecov.io/gh/DavidSkrundz/CommandLine/branch/master/graph/badge.svg)](https://codecov.io/gh/DavidSkrundz/CommandLine)
===========

Parse arguments and use command-line tools from Swift.

```Swift
"ls -l" | "head -5" > standardOut
```

ArgumentParser
--------------

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

AutoTask
--------

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
