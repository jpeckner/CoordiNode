//
//  RouterProtocol.swift
//  CoordiNode
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public protocol RouterProtocol: CoordinatorProtocol {
    associatedtype TDescendent: DescendentProtocol
    typealias TDestinationDescendent = TDescendent.TDestinationDescendent

    func createSubtree(towards destinationDescendent: TDestinationDescendent)

    func switchSubtree(from currentDescendent: TDescendent,
                       to destinationDescendent: TDestinationDescendent)
}

public protocol DestinationRouterProtocol: DestinationCoordinatorProtocol, RouterProtocol {
    func closeAllSubtrees(currentNode: NodeBox)
}
