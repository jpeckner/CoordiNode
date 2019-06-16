//
//  NodeProtocol.swift
//  CoordiNode
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

public protocol NodeProtocol {}

public extension NodeProtocol {

    static var nodeBox: NodeBox {
        return NodeBox(Self.self)
    }

}

public struct NodeBox {
    public let storedType: NodeProtocol.Type

    public init(_ storedType: NodeProtocol.Type) {
        self.storedType = storedType
    }
}

extension NodeBox: Equatable {

    public static func == (lhs: NodeBox, rhs: NodeBox) -> Bool {
        return lhs.storedType == rhs.storedType
    }

}
