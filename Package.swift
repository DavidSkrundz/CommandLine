//
//  Package.swift
//  CommandLine
//

import PackageDescription

let package = Package(
	name: "CommandLine"
)

let staticLibrary = Product(
	name: "CommandLine",
	type: .Library(.Static),
	modules: ["CommandLine"]
)
let dynamicLibrary = Product(
	name: "CommandLine",
	type: .Library(.Dynamic),
	modules: ["CommandLine"]
)

products.append(staticLibrary)
products.append(dynamicLibrary)
