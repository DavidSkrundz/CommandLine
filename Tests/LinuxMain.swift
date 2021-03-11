//
//  LinuxMain.swift
//  CommandLine
//

#if os(Linux)
import SwiftGlibc.C.stdlib
#endif

print("Run the tests with `swift test --enable-test-discovery`.")
exit(1)
