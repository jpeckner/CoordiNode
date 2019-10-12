//
//  DestinationNodeProtocol.swift
//  CoordiNode
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public protocol DestinationNodeProtocol: NodeProtocol {}

public extension DestinationNodeProtocol {

    static var destinationNodeBox: DestinationNodeBox {
        return DestinationNodeBox(Self.self)
    }

}

public struct DestinationNodeBox {
    public let storedType: DestinationNodeProtocol.Type

    public init(_ storedType: DestinationNodeProtocol.Type) {
        self.storedType = storedType
    }
}

extension DestinationNodeBox: Equatable {

    public static func == (lhs: DestinationNodeBox, rhs: DestinationNodeBox) -> Bool {
        return lhs.storedType == rhs.storedType
    }

}
