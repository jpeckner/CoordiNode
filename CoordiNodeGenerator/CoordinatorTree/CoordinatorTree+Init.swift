//
//  CoordinatorTree+Init.swift
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

    private func validateCoordinatorNames(_ trees: [CoordinatorTree]) throws {
        let duplicates = trees.filterDuplicates { $0.name }
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

        if nodeProperties.isDestinationNode {
            destinationChildren.append(self)
        }

        switch self {
        case .leaf:
            break
        case let .nonLeaf(_, treeChildren):
            treeChildren.immediateChildren.forEach {
                $0.gatherChildren(owningImmediateChild: owningImmediateChild,
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
