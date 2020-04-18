//
//  RoutingHandlerProtocolMock.swift
//  CoordiNodeTestComponents
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

// swiftlint:disable large_tuple
public class RoutingHandlerProtocolMock: RoutingHandlerProtocol {

    public init() {}

    // MARK: - handleRouting<TRouter: RouterProtocol>

    public var handleRoutingFromToForCallsCount = 0
    public var handleRoutingFromToForCalled: Bool {
        return handleRoutingFromToForCallsCount > 0
    }
    public var handleRoutingFromToForReceivedArguments: (
        currentNode: NodeBox,
        destinationDescendent: DestinationDescendentProtocol,
        router: CoordinatorProtocol
    )?
    public var handleRoutingFromToForClosure: ((NodeBox, DestinationDescendentProtocol, CoordinatorProtocol) -> Void)?

    public func handleRouting<TRouter: RouterProtocol>(from currentNode: NodeBox,
                                                       to destinationDescendent: TRouter.TDestinationDescendent,
                                                       for router: TRouter) {
        handleRoutingFromToForCallsCount += 1
        handleRoutingFromToForReceivedArguments = (currentNode: currentNode,
                                                   destinationDescendent: destinationDescendent,
                                                   router: router)
        handleRoutingFromToForClosure?(currentNode, destinationDescendent, router)
    }

}
