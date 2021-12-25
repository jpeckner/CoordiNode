//
//  RoutingHandlerTests.swift
//  CoordiNodeTests
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
import Nimble
import Quick

private enum OtherMockNode: NodeProtocol {}

class RoutingHandlerTests: QuickSpec {

    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockCoordinator: RootCoordinatorMock!
        var routingHandler: RoutingHandler!

        beforeEach {
            mockCoordinator = RootCoordinatorMock()
            routingHandler = RoutingHandler()
        }

        describe("handleRouting()") {

            context("when the from: arg is not a descendent of the coordinator") {
                beforeEach {
                    routingHandler.handleRouting(from: OtherMockNode.nodeBox,
                                                 to: RootCoordinatorMockDestinationDescendent.firstGrandchild,
                                                 for: mockCoordinator)
                }

                it("calls mockCoordinator.createSubtree(towards:)") {
                    expect(mockCoordinator.receivedCreateSubtreeDestinationDescendent) == .firstGrandchild
                }
            }

            context("else when the from: arg is part of a different subtree than the destinationDescendent arg") {
                beforeEach {
                    routingHandler.handleRouting(from: FirstChildCoordinatorMockNode.nodeBox,
                                                 to: RootCoordinatorMockDestinationDescendent.firstGrandchild,
                                                 for: mockCoordinator)
                }

                it("calls mockCoordinator.switchSubtree(towards:)") {
                    expect(mockCoordinator.receivedSwitchSubtreeArgs?.0) == .firstChild
                    expect(mockCoordinator.receivedSwitchSubtreeArgs?.1) == .firstGrandchild
                }
            }

            context("else when the from: arg is part of the same subtree as the destinationDescendent arg") {
                beforeEach {
                    routingHandler.handleRouting(from: SecondChildCoordinatorMockNode.nodeBox,
                                                 to: RootCoordinatorMockDestinationDescendent.firstGrandchild,
                                                 for: mockCoordinator)
                }

                it("does not call either method") {
                    expect(mockCoordinator.receivedCreateSubtreeDestinationDescendent).to(beNil())
                    expect(mockCoordinator.receivedSwitchSubtreeArgs).to(beNil())
                }
            }

        }

    }

}
