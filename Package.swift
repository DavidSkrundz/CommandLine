// swift-tools-version:4.0
//
//  Package.swift
//  CommandLine
//

import PackageDescription

let package = Package(
	name: "CommandLine",
	products: [
		.library(
			name: "CommandLine",
			type: .static,
			targets: ["CommandLine"]),
		.library(
			name: "CommandLine",
			type: .dynamic,
			targets: ["CommandLine"]),
		],
	targets: [
		.target(
			name: "CommandLine"),
		.testTarget(
			name: "CommandLineTests",
			dependencies: ["CommandLine"]),
		]
)
