//
//  RootCoordinatorMock.swift
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

public enum RootCoordinatorMockNode: NodeProtocol {}

open class RootCoordinatorMock: RouterProtocol, RootCoordinatorProtocol {

    public typealias TDescendent = RootCoordinatorMockDescendent

    public static var nodeBox: NodeBox {
        return RootCoordinatorMockNode.nodeBox
    }

    public init() {}

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
        }) else {
            return nil
        }

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
        }) else {
            return nil
        }

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
        }) else {
            return nil
        }

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
