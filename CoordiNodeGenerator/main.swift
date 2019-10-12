#!/usr/bin/swift

//
//  main.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Yams

private enum CommandLineError: Error {
    case invalidArgsCount(message: String)
    case outputPathNotADirectory(path: URL)
}

private struct CommandLineArgs {
    let inputFile: String
    let outputPath: URL

    init(args: [String]) throws {
        guard args.count == 3 else {
            throw CommandLineError.invalidArgsCount(message: """
                Invalid args count; expected args format is: <inputFile> <outputDir>
                """
            )
        }

        self.inputFile = args[1]

        self.outputPath = URL(fileURLWithPath: args[2])
        guard outputPath.hasDirectoryPath else {
            throw CommandLineError.outputPathNotADirectory(path: outputPath.standardizedFileURL)
        }
    }
}

do {
    print("Starting CoordiNodeGenerator...")
    let commandLineArgs = try CommandLineArgs(args: CommandLine.arguments)

    let yamlTree = try String(contentsOfFile: commandLineArgs.inputFile)
    let decoder = YAMLDecoder(encoding: .utf8)
    let coordinatorDict = try decoder.decodeCoordinatorPropsDict(yamlTree)
    print("Config file syntax is valid!")

    let coordinatorTree = try CoordinatorTree(coordinatorDict: coordinatorDict,
                                              isRootNode: true)
    print("Coordinator hierarchy is valid!")

    try coordinatorTree.writeOutputFiles(commandLineArgs.outputPath,
                                         project: Project.current)
    print("Successfully generated components! Output path: \(commandLineArgs.outputPath.standardizedFileURL)")
} catch {
    print(error)
    exit(EXIT_FAILURE)
}
