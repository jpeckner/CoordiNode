//
//  CoordinatorTree.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

enum CoordinatorTree {
    case leaf(
        nodeProperties: CoordinatorNodeProperties
    )

    case nonLeaf(
        nodeProperties: CoordinatorNodeProperties,
        treeChildren: TreeChildren
    )
}

// TreeChildren allows us to gather, validate, and store details of ALL of a CoordinatorTree's children up-front
struct TreeChildren {
    enum ChildType {
        case immediateChild(CoordinatorTree)
        case notImmediateChild(CoordinatorTree, owningImmediateChild: CoordinatorTree)
    }

    let immediateChildren: [CoordinatorTree]
    let destinationChildren: [CoordinatorTree]
    let allChildren: [ChildType]
}

extension CoordinatorTree {

    var allTrees: [CoordinatorTree] {
        switch self {
        case .leaf:
            return [self]
        case let .nonLeaf(_, treeChildren):
            return [self] + treeChildren.allChildTrees
        }
    }

    var nodeProperties: CoordinatorNodeProperties {
        switch self {
        case let .leaf(nodeProperties),
             let .nonLeaf(nodeProperties, _):
            return nodeProperties
        }
    }

    var name: String {
        return nodeProperties.name
    }

    var enumCaseName: String {
        return nodeProperties.enumCaseName
    }

}

extension TreeChildren {

    var allChildTrees: [CoordinatorTree] {
        return allChildren.map { $0.tree }
    }

}

extension TreeChildren.ChildType {

    var tree: CoordinatorTree {
        switch self {
        case let .immediateChild(tree),
             let .notImmediateChild(tree, _):
            return tree
        }
    }

    var owningImmediateChild: CoordinatorTree {
        switch self {
        case let .immediateChild(owningImmediateChild),
             let .notImmediateChild(_, owningImmediateChild):
            return owningImmediateChild
        }
    }

}
