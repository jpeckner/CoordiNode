//
//  FirstGrandchildCoordinatorMock.swift
//  CoordiNodeTestComponents
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

public enum FirstGrandchildCoordinatorMockNode: DestinationNodeProtocol {}

public class FirstGrandchildCoordinatorMock: DestinationCoordinatorProtocol {
    public init() {}

    public static var destinationNodeBox: DestinationNodeBox {
        return FirstGrandchildCoordinatorMockNode.destinationNodeBox
    }
}
