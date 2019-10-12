//
//  RoutingHandler.swift
//  CoordiNode
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
