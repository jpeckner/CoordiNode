//
//  CoordinatorTree+File.swift
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

extension CoordinatorTree {

    func writeOutputFiles(_ outputPath: URL,
                          project: Project) throws {
        for tree in allTrees {
            // This deliberately uses extension .autogen.swift instead of .generated.swift; otherwise, Sourcery can't
            // parse these files without resorting to the --force-parse option.
            let filename = "\(tree.name)+\(project.projectName).autogen.swift"
            let outputFilePath = outputPath.appendingPathComponent(filename,
                                                                   isDirectory: false)

            try writeFile(tree.output,
                          outputPath: outputFilePath,
                          project: project)
        }
    }

    private func writeFile(_ fileBody: String,
                           outputPath: URL,
                           project: Project) throws {
        let toWrite = """
        \(project.fileHeader)

        import \(project.projectName)

        \(fileBody)

        """

        try toWrite.write(to: outputPath,
                          atomically: true,
                          encoding: .utf8)
    }

}

private extension Project {

    var fileHeader: String {
        return """
        // Generated using \(projectName) \(version) — \(projectURL)
        // DO NOT EDIT
        """
    }

}
