#!/usr/bin/swift

//
//  main.swift
//  CoordiNodeGenerator
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
