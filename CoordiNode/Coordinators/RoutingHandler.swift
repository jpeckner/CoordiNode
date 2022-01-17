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

public enum RoutingHandlerResult<TDescendent: DescendentProtocol> {
    public typealias TDestinationDescendent = TDescendent.TDestinationDescendent

    case createSubtree(currentNode: NodeBox,
                       destinationDescendent: TDestinationDescendent)

    case switchSubtree(currentNode: TDescendent,
                       destinationDescendent: TDestinationDescendent)
}

public protocol RoutingHandlerProtocol {
    func determineRouting<TRouter: RouterProtocol>(
        from currentNode: NodeBox,
        to destinationDescendent: TRouter.TDestinationDescendent,
        for router: TRouter
    ) -> RoutingHandlerResult<TRouter.TDescendent>?
}

public class RoutingHandler: RoutingHandlerProtocol {

    public init() {}

    public func determineRouting<TRouter: RouterProtocol>(
        from currentNode: NodeBox,
        to destinationDescendent: TRouter.TDestinationDescendent,
        for router: TRouter
    ) -> RoutingHandlerResult<TRouter.TDescendent>? {
        return router.performRouting(from: currentNode,
                                     to: destinationDescendent)
    }

}

// MARK: DestinationRoutingHandler

public enum DestinationRoutingHandlerResult<TDescendent: DescendentProtocol> {
    public typealias TDestinationDescendent = TDescendent.TDestinationDescendent

    case createSubtree(currentNode: NodeBox,
                       destinationDescendent: TDestinationDescendent)

    case switchSubtree(currentNode: TDescendent,
                       destinationDescendent: TDestinationDescendent)

    case closeAllSubtrees(currentNode: NodeBox)
}

public protocol DestinationRoutingHandlerProtocol {
    func determineRouting<TDestinationRouter: DestinationRouterProtocol>(
        from currentNode: NodeBox,
        to destinationNodeBox: DestinationNodeBox,
        for router: TDestinationRouter
    ) -> DestinationRoutingHandlerResult<TDestinationRouter.TDescendent>?
}

public class DestinationRoutingHandler: DestinationRoutingHandlerProtocol {

    public init() {}

    public func determineRouting<TDestinationRouter: DestinationRouterProtocol>(
        from currentNode: NodeBox,
        to destinationNodeBox: DestinationNodeBox,
        for router: TDestinationRouter
    ) -> DestinationRoutingHandlerResult<TDestinationRouter.TDescendent>? {
        guard TDestinationRouter.destinationNodeBox != destinationNodeBox else {
            return .closeAllSubtrees(currentNode: currentNode)
        }

        guard let destinationDescendent =
            TDestinationRouter.TDestinationDescendent(destinationNodeBox: destinationNodeBox)
        else {
            return nil
        }

        let routerResult = router.performRouting(from: currentNode,
                                                 to: destinationDescendent)
        switch routerResult {
        case let .createSubtree(currentNode, destinationDescendent):
            return .createSubtree(currentNode: currentNode,
                                  destinationDescendent: destinationDescendent)
        case let .switchSubtree(currentNode, destinationDescendent):
            return .switchSubtree(currentNode: currentNode,
                                  destinationDescendent: destinationDescendent)
        case .none:
            return nil
        }
    }

}

// MARK: Shared logic

private extension RouterProtocol {

    func performRouting(from currentNode: NodeBox,
                        to destinationDescendent: TDestinationDescendent) -> RoutingHandlerResult<TDescendent>? {
        guard let currentDescendent = TDescendent(nodeBox: currentNode) else {
            return .createSubtree(currentNode: currentNode,
                                  destinationDescendent: destinationDescendent)
        }

        let rootOfCurrentSubtree = currentDescendent.immediateDescendent
        let rootOfDestinationSubtree = TDescendent(destinationDescendent: destinationDescendent).immediateDescendent
        let destinationSubtreeAlreadyActive = rootOfCurrentSubtree.nodeBox == rootOfDestinationSubtree.nodeBox
        guard destinationSubtreeAlreadyActive else {
            return .switchSubtree(currentNode: currentDescendent,
                                  destinationDescendent: destinationDescendent)
        }

        // Nothing to do (the subtree with destinationDescendent is already active, so one of its coordinators will
        // handle this routing)
        return nil
    }

}
