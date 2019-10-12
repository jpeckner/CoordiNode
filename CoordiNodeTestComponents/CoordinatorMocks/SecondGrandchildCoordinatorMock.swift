//
//  SecondGrandchildCoordinatorMock.swift
//  CoordiNodeTestComponents
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

public enum SecondGrandchildCoordinatorMockNode: DestinationNodeProtocol {}

public class SecondGrandchildCoordinatorMock: DestinationCoordinatorProtocol {
    public init() {}

    public static var destinationNodeBox: DestinationNodeBox {
        return SecondGrandchildCoordinatorMockNode.destinationNodeBox
    }
}
