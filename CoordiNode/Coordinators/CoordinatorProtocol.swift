//
//  CoordinatorProtocol.swift
//  CoordiNode
//
//  Created by Justin Peckner.
//  Copyright © 2018 Justin Peckner. All rights reserved.
//

import Foundation

public protocol RootCoordinatorProtocol {}

public protocol CoordinatorProtocol: AnyObject {
    static var nodeBox: NodeBox { get }
}

public protocol DestinationCoordinatorProtocol: CoordinatorProtocol {
    static var destinationNodeBox: DestinationNodeBox { get }
}

public extension DestinationCoordinatorProtocol {

    static var nodeBox: NodeBox {
        return NodeBox(Self.destinationNodeBox.storedType)
    }

}
