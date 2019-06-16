//
//  RootCoordinatorMock.swift
//  CoordiNodeTestComponents
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import CoordiNode

public enum RootCoordinatorMockNode: NodeProtocol {}

public class RootCoordinatorMock: RouterProtocol, RootCoordinatorProtocol {

    public typealias TDescendent = RootCoordinatorMockDescendent

    public init() {}

    // MARK: createSubtree()

    // swiftlint:disable identifier_name
    public private(set) var receivedCreateSubtreeDestinationDescendent: RootCoordinatorMockDestinationDescendent?

    public func createSubtree(towards destinationDescendent: RootCoordinatorMockDestinationDescendent) {
        receivedCreateSubtreeDestinationDescendent = destinationDescendent
    }

    // MARK: switchSubtree()

    public private(set) var receivedSwitchSubtreeArgs: (
        currentDescendent: RootCoordinatorMockDescendent,
        destinationDescendent: RootCoordinatorMockDestinationDescendent
    )?

    public func switchSubtree(from currentDescendent: RootCoordinatorMockDescendent,
                              to destinationDescendent: RootCoordinatorMockDestinationDescendent) {
        receivedSwitchSubtreeArgs = (currentDescendent, destinationDescendent)
    }

    public static var nodeBox: NodeBox {
        return RootCoordinatorMockNode.nodeBox
    }
}

// MARK: RootCoordinatorMockDescendent

public enum RootCoordinatorMockDescendent: DescendentProtocol, CaseIterable {
    case firstChild
    case secondChild
    case firstGrandchild
    case secondGrandchild

    public init?(nodeBox: NodeBox) {
        guard let matchingCase = (RootCoordinatorMockDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else { return nil }

        self = matchingCase
    }

    public init(destinationDescendent: RootCoordinatorMockDestinationDescendent) {
        switch destinationDescendent {
        case .firstChild:
            self = .firstChild
        case .firstGrandchild:
            self = .firstGrandchild
        case .secondGrandchild:
            self = .secondGrandchild
        }
    }

    public var nodeBox: NodeBox {
        switch self {
        case .firstChild:
            return FirstChildCoordinatorMockNode.nodeBox
        case .secondChild:
            return SecondChildCoordinatorMockNode.nodeBox
        case .firstGrandchild:
            return FirstGrandchildCoordinatorMockNode.nodeBox
        case .secondGrandchild:
            return SecondGrandchildCoordinatorMockNode.nodeBox
        }
    }

    public var immediateDescendent: RootCoordinatorMockImmediateDescendent {
        switch self {
        case .firstChild:
            return .firstChild
        case .secondChild:
            return .secondChild
        case .firstGrandchild:
            return .secondChild
        case .secondGrandchild:
            return .secondChild
        }
    }

}

// MARK: RootCoordinatorMockImmediateDescendent

public enum RootCoordinatorMockImmediateDescendent: ImmediateDescendentProtocol, CaseIterable {
    case firstChild
    case secondChild

    public init?(nodeBox: NodeBox) {
        guard let matchingCase = (RootCoordinatorMockImmediateDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else { return nil }

        self = matchingCase
    }

    public var nodeBox: NodeBox {
        switch self {
        case .firstChild:
            return FirstChildCoordinatorMockNode.nodeBox
        case .secondChild:
            return SecondChildCoordinatorMockNode.nodeBox
        }
    }

}

// MARK: RootCoordinatorMockDestinationDescendent

public enum RootCoordinatorMockDestinationDescendent: DestinationDescendentProtocol, CaseIterable {
    case firstChild
    case firstGrandchild
    case secondGrandchild

    public init?(destinationNodeBox: DestinationNodeBox) {
        guard let matchingCase = (RootCoordinatorMockDestinationDescendent.allCases.first {
            $0.destinationNodeBox == destinationNodeBox
        }) else { return nil }

        self = matchingCase
    }

    public var destinationNodeBox: DestinationNodeBox {
        switch self {
        case .firstChild:
            return FirstChildCoordinatorMockNode.destinationNodeBox
        case .firstGrandchild:
            return FirstGrandchildCoordinatorMockNode.destinationNodeBox
        case .secondGrandchild:
            return SecondGrandchildCoordinatorMockNode.destinationNodeBox
        }
    }

}
