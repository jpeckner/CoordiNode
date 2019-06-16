//
//  CoordinatorProps.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation
import Yams

typealias CoordinatorPropsDict = [String: CoordinatorProps]

struct CoordinatorProps: Decodable {
    let enumCaseName: String?
    let isDestinationNode: Bool?
    let children: [CoordinatorPropsDict]?
}

extension YAMLDecoder {

    func decodeCoordinatorPropsDict(_ yamlTree: String) throws -> CoordinatorPropsDict {
        return try decode(CoordinatorPropsDict.self,
                          from: yamlTree,
                          userInfo: [:])
    }

}
