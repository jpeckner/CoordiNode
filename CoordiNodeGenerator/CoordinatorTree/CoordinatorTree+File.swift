//
//  CoordinatorTree+File.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
