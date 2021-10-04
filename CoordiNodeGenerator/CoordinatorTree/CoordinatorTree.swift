//
//  CoordinatorTree.swift
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
