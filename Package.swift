// swift-tools-version:5.0
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
			targets: ["CommandLine"]),
		.library(
			name: "sCommandLine",
			type: .static,
			targets: ["CommandLine"]),
		.library(
			name: "dCommandLine",
			type: .dynamic,
			targets: ["CommandLine"])
	],
	dependencies: [
		.package(url: "https://github.com/DavidSkrundz/Collections.git",
		         .upToNextMinor(from: "2.0.0"))
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
