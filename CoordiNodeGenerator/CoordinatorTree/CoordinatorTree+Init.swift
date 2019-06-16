//
//  CoordinatorTree+Init.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

enum CoordinatorTreeError: Error {
    case mustHaveSingleRootForSubtree(CoordinatorPropsDict)
    case containsDuplicateCoordinatorNames([String])
    case containsDuplicateEnumCaseNames([String])
}

extension CoordinatorTree {

    init(coordinatorDict: CoordinatorPropsDict,
         isRootNode: Bool) throws {
        guard let firstElement = coordinatorDict.first,
            coordinatorDict.count == 1
        else {
            throw CoordinatorTreeError.mustHaveSingleRootForSubtree(coordinatorDict)
        }

        let nodeProperties = CoordinatorNodeProperties(dictElement: firstElement,
                                                       isRootNode: isRootNode)

        guard let children = firstElement.value.children else {
            self = .leaf(nodeProperties: nodeProperties)
            return
        }

        let childTrees = try children.map {
            try CoordinatorTree(coordinatorDict: $0,
                                isRootNode: false)
        }
        self = .nonLeaf(nodeProperties: nodeProperties,
                        treeChildren: childTrees.treeChildren)

        try validateNonLeafType(allTrees)
    }

}

private extension CoordinatorTree {

    func validateNonLeafType(_ allTrees: [CoordinatorTree]) throws {
        try validateCoordinatorNames(allTrees)
        try validateEnumCaseNames(allTrees)
    }

    private func validateCoordinatorNames(_ allTrees: [CoordinatorTree]) throws {
        let duplicates = allTrees.filterDuplicates { $0.name }
        guard duplicates.isEmpty else {
            throw CoordinatorTreeError.containsDuplicateCoordinatorNames(duplicates)
        }
    }

    private func validateEnumCaseNames(_ allTrees: [CoordinatorTree]) throws {
        let duplicates = allTrees.filterDuplicates { $0.enumCaseName }
        guard duplicates.isEmpty else {
            throw CoordinatorTreeError.containsDuplicateEnumCaseNames(duplicates)
        }
    }

}

private extension CoordinatorTree {

    func gatherChildren(owningImmediateChild: CoordinatorTree,
                        isImmediateChild: Bool,
                        destinationChildren: inout [CoordinatorTree],
                        allChildren: inout [TreeChildren.ChildType]) {
        let childType: TreeChildren.ChildType = isImmediateChild ?
            .immediateChild(self)
            : .notImmediateChild(self, owningImmediateChild: owningImmediateChild)
        allChildren.append(childType)

        switch self {
        case .leaf:
            if nodeProperties.isDestinationNode {
                destinationChildren.append(self)
            }
        case let .nonLeaf(_, treeChildren):
            treeChildren.allChildren.forEach {
                $0.tree.gatherChildren(owningImmediateChild: owningImmediateChild,
                                       isImmediateChild: false,
                                       destinationChildren: &destinationChildren,
                                       allChildren: &allChildren)
            }
        }
    }

}

private extension Array where Element == CoordinatorTree {

    var treeChildren: TreeChildren {
        var destinationChildren: [CoordinatorTree] = []
        var allChildren: [TreeChildren.ChildType] = []

        forEach {
            $0.gatherChildren(owningImmediateChild: $0,
                              isImmediateChild: true,
                              destinationChildren: &destinationChildren,
                              allChildren: &allChildren)
        }

        return TreeChildren(immediateChildren: self,
                            destinationChildren: destinationChildren,
                            allChildren: allChildren)
    }

}
