//
//  Project.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct Project {
    static let current = Project(projectName: "CoordiNode",
                                 version: "1.0.1",
                                 projectURL: "https://github.com/jpeckner/CoordiNode")

    let projectName: String
    let version: String
    let projectURL: String
}
