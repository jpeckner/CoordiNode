//
//  SecondChildCoordinatorMock.swift
//  CoordiNodeTestComponents
//
//  Copyright (c) 2019 Justin Peckner
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CoordiNode

public enum SecondChildCoordinatorMockNode: DestinationNodeProtocol {}

public class SecondChildCoordinatorMock: DestinationRouterProtocol {

    public typealias TDescendent = SecondChildCoordinatorMockDescendent

    public init() {}

    // MARK: createSubtree()

    // swiftlint:disable identifier_name
    public private(set) var receivedCreateSubtreeDestinationDescendent: SecondChildCoordinatorMockDestinationDescendent?

    public func createSubtree(towards destinationDescendent: SecondChildCoordinatorMockDestinationDescendent) {
        receivedCreateSubtreeDestinationDescendent = destinationDescendent
    }

    // MARK: switchSubtree()

    public private(set) var receivedSwitchSubtreeArgs: (
        currentDescendent: SecondChildCoordinatorMockDescendent,
        destinationDescendent: SecondChildCoordinatorMockDestinationDescendent
    )?

    public func switchSubtree(from currentDescendent: SecondChildCoordinatorMockDescendent,
                              to destinationDescendent: SecondChildCoordinatorMockDestinationDescendent) {
        receivedSwitchSubtreeArgs = (currentDescendent, destinationDescendent)
    }

    // MARK: closeAllSubtrees()

    public private(set) var receivedCloseAllSubtreesCurrentNode: NodeBox?

    public func closeAllSubtrees(currentNode: NodeBox) {
        receivedCloseAllSubtreesCurrentNode = currentNode
    }

    public static var destinationNodeBox: DestinationNodeBox {
        return SecondChildCoordinatorMockNode.destinationNodeBox
    }
}

// MARK: SecondChildCoordinatorMockDescendent

public enum SecondChildCoordinatorMockDescendent: DescendentProtocol, CaseIterable {
    case firstGrandchild
    case secondGrandchild

    public init?(nodeBox: NodeBox) {
        guard let matchingCase = (SecondChildCoordinatorMockDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    public init(destinationDescendent: SecondChildCoordinatorMockDestinationDescendent) {
        switch destinationDescendent {
        case .firstGrandchild:
            self = .firstGrandchild
        case .secondGrandchild:
            self = .secondGrandchild
        }
    }

    public var nodeBox: NodeBox {
        switch self {
        case .firstGrandchild:
            return FirstGrandchildCoordinatorMockNode.nodeBox
        case .secondGrandchild:
            return SecondGrandchildCoordinatorMockNode.nodeBox
        }
    }

    public var immediateDescendent: SecondChildCoordinatorMockImmediateDescendent {
        switch self {
        case .firstGrandchild:
            return .firstGrandchild
        case .secondGrandchild:
            return .secondGrandchild
        }
    }

}

// MARK: SecondChildCoordinatorMockImmediateDescendent

// swiftlint:disable type_name
public enum SecondChildCoordinatorMockImmediateDescendent: ImmediateDescendentProtocol, CaseIterable {
    case firstGrandchild
    case secondGrandchild

    public init?(nodeBox: NodeBox) {
        guard let matchingCase = (SecondChildCoordinatorMockImmediateDescendent.allCases.first {
            $0.nodeBox == nodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    public var nodeBox: NodeBox {
        switch self {
        case .firstGrandchild:
            return FirstGrandchildCoordinatorMockNode.nodeBox
        case .secondGrandchild:
            return SecondGrandchildCoordinatorMockNode.nodeBox
        }
    }

}

// MARK: SecondChildCoordinatorMockDestinationDescendent

// swiftlint:disable type_name
public enum SecondChildCoordinatorMockDestinationDescendent: DestinationDescendentProtocol, CaseIterable {
    case firstGrandchild
    case secondGrandchild

    public init?(destinationNodeBox: DestinationNodeBox) {
        guard let matchingCase = (SecondChildCoordinatorMockDestinationDescendent.allCases.first {
            $0.destinationNodeBox == destinationNodeBox
        }) else {
            return nil
        }

        self = matchingCase
    }

    public var destinationNodeBox: DestinationNodeBox {
        switch self {
        case .firstGrandchild:
            return FirstGrandchildCoordinatorMockNode.destinationNodeBox
        case .secondGrandchild:
            return SecondGrandchildCoordinatorMockNode.destinationNodeBox
        }
    }

}
