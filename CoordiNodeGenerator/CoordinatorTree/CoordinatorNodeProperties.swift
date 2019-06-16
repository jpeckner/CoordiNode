//
//  CoordinatorNodeProperties.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

struct CoordinatorNodeProperties {
    let name: String
    let enumCaseName: String
    let isRootNode: Bool
    let isDestinationNode: Bool
}

extension CoordinatorNodeProperties {

    init(dictElement: (key: String, value: CoordinatorProps),
         isRootNode: Bool) {
        self.name = dictElement.key
        self.enumCaseName =
            dictElement.value.enumCaseName
            ?? dictElement.key.withLowerCaseFirstChar
        self.isRootNode = isRootNode
        self.isDestinationNode =
            dictElement.value.isDestinationNode
            ?? dictElement.value.children?.isEmpty
            ?? true
    }

}

private extension String {

    var withLowerCaseFirstChar: String {
        return "\(prefix(1).lowercased())\(dropFirst())"
    }

}
