//
//  DescendentProtocol.swift
//  CoordiNode
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public protocol ImmediateDescendentProtocol {
    init?(nodeBox: NodeBox)

    var nodeBox: NodeBox { get }
}

public protocol DestinationDescendentProtocol {
    init?(destinationNodeBox: DestinationNodeBox)

    var destinationNodeBox: DestinationNodeBox { get }
}

public protocol DescendentProtocol {
    associatedtype TImmediateDescendent: ImmediateDescendentProtocol
    associatedtype TDestinationDescendent: DestinationDescendentProtocol

    init?(nodeBox: NodeBox)
    init(destinationDescendent: TDestinationDescendent)

    var nodeBox: NodeBox { get }
    var immediateDescendent: TImmediateDescendent { get }
}
