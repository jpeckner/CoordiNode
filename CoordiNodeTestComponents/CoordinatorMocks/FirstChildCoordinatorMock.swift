//
//  FirstChildCoordinatorMock.swift
//  CoordiNodeTestComponents
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

public enum FirstChildCoordinatorMockNode: DestinationNodeProtocol {}

public class FirstChildCoordinatorMock: DestinationCoordinatorProtocol {
    public init() {}

    public static var destinationNodeBox: DestinationNodeBox {
        return FirstChildCoordinatorMockNode.destinationNodeBox
    }
}
