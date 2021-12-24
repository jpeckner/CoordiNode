//
//  RoutingHandler.swift
//  CoordiNode
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

// MARK: RoutingHandler

public protocol RoutingHandlerProtocol {
    func handleRouting<TRouter: RouterProtocol>(from currentNode: NodeBox,
                                                to destinationDescendent: TRouter.TDestinationDescendent,
                                                for router: TRouter)
}

public class RoutingHandler: RoutingHandlerProtocol {

    public init() {}

    public func handleRouting<TRouter: RouterProtocol>(from currentNode: NodeBox,
                                                       to destinationDescendent: TRouter.TDestinationDescendent,
                                                       for router: TRouter) {
        router.performRouting(from: currentNode,
                              to: destinationDescendent)
    }

}

// MARK: DestinationRoutingHandler

public protocol DestinationRoutingHandlerProtocol {
    func handleRouting<TDestinationRouter: DestinationRouterProtocol>(from currentNode: NodeBox,
                                                                      to destinationNodeBox: DestinationNodeBox,
                                                                      for router: TDestinationRouter)
}

public class DestinationRoutingHandler: DestinationRoutingHandlerProtocol {

    public init() {}

    public func handleRouting<TDestinationRouter: DestinationRouterProtocol>(
        from currentNode: NodeBox,
        to destinationNodeBox: DestinationNodeBox,
        for router: TDestinationRouter
    ) {
        guard TDestinationRouter.destinationNodeBox != destinationNodeBox else {
            router.closeAllSubtrees(currentNode: currentNode)
            return
        }

        guard let destinationDescendent =
            TDestinationRouter.TDestinationDescendent(destinationNodeBox: destinationNodeBox)
        else { return }

        router.performRouting(from: currentNode,
                              to: destinationDescendent)
    }

}

// MARK: Shared logic

private extension RouterProtocol {

    func performRouting(from currentNode: NodeBox,
                        to destinationDescendent: TDestinationDescendent) {
        guard let currentDescendent = TDescendent(nodeBox: currentNode) else {
            createSubtree(towards: destinationDescendent)
            return
        }

        let rootOfCurrentSubtree = currentDescendent.immediateDescendent
        let rootOfDestinationSubtree = TDescendent(destinationDescendent: destinationDescendent).immediateDescendent
        let destinationSubtreeAlreadyActive = rootOfCurrentSubtree.nodeBox == rootOfDestinationSubtree.nodeBox
        guard destinationSubtreeAlreadyActive else {
            switchSubtree(from: currentDescendent,
                          to: destinationDescendent)
            return
        }

        // Nothing to do (the subtree with destinationDescendent is already active, so one of its coordinators will
        // handle this routing)
    }

}
