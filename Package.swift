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
			targets: ["CommandLine"])
	],
	dependencies: [
		.package(url: "https://github.com/DavidSkrundz/Collections.git",
		         .upToNextMinor(from: "1.0.0"))
	],
	targets: [
		.target(
			name: "CommandLine",
			dependencies: ["Generator"]),
		.testTarget(
			name: "CommandLineTests",
			dependencies: ["CommandLine"])
	]
)
