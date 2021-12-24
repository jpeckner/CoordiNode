//
//  DestinationRoutingHandlerTests.swift
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

private enum OtherMockNode: DestinationNodeProtocol {}

class DestinationRoutingHandlerTests: QuickSpec {

    // swiftlint:disable function_body_length
    // swiftlint:disable implicitly_unwrapped_optional
    override func spec() {

        var mockDestinationCoordinator: SecondChildCoordinatorMock!
        var destinationRoutingHandler: DestinationRoutingHandler!

        beforeEach {
            mockDestinationCoordinator = SecondChildCoordinatorMock()
            destinationRoutingHandler = DestinationRoutingHandler()
        }

        describe("handleRouting()") {

            context("when the to: arg is equal to the coordinator's destinationNodeBox") {
                beforeEach {
                    destinationRoutingHandler.handleRouting(
                        from: OtherMockNode.nodeBox,
                        to: SecondChildCoordinatorMockNode.destinationNodeBox,
                        for: mockDestinationCoordinator
                    )
                }

                it("calls mockCoordinator.closeAllSubtrees()") {
                    expect(mockDestinationCoordinator.receivedCloseAllSubtreesCurrentNode) == OtherMockNode.nodeBox
                }
            }

            context("else when the to: arg is not a descendent of the coordinator") {
                beforeEach {
                    destinationRoutingHandler.handleRouting(from: SecondGrandchildCoordinatorMockNode.nodeBox,
                                                            to: OtherMockNode.destinationNodeBox,
                                                            for: mockDestinationCoordinator)
                }

                it("does not call any of its protocol methods") {
                    expect(mockDestinationCoordinator.receivedCreateSubtreeDestinationDescendent).to(beNil())
                    expect(mockDestinationCoordinator.receivedSwitchSubtreeArgs).to(beNil())
                    expect(mockDestinationCoordinator.receivedCloseAllSubtreesCurrentNode).to(beNil())
                }
            }

            context("else when the from: arg is not a descendent of the coordinator") {
                beforeEach {
                    let value = FirstGrandchildCoordinatorMockNode.destinationNodeBox
                    destinationRoutingHandler.handleRouting(from: OtherMockNode.nodeBox,
                                                            to: value,
                                                            for: mockDestinationCoordinator)
                }

                it("calls mockCoordinator.createSubtree(towards:)") {
                    expect(mockDestinationCoordinator.receivedCreateSubtreeDestinationDescendent) == .firstGrandchild
                }
            }

            context("else when the from: arg is part of a different subtree than the destinationDescendent arg") {
                beforeEach {
                    destinationRoutingHandler.handleRouting(
                        from: SecondGrandchildCoordinatorMock.nodeBox,
                        to: FirstGrandchildCoordinatorMockNode.destinationNodeBox,
                        for: mockDestinationCoordinator
                    )
                }

                it("calls mockCoordinator.switchSubtree(towards:)") {
                    expect(mockDestinationCoordinator.receivedSwitchSubtreeArgs?.0) == .secondGrandchild
                    expect(mockDestinationCoordinator.receivedSwitchSubtreeArgs?.1) == .firstGrandchild
                }
            }

            context("else when the from: arg is part of the same subtree as the destinationDescendent arg") {
                beforeEach {
                    destinationRoutingHandler.handleRouting(
                        from: FirstGrandchildCoordinatorMock.nodeBox,
                        to: FirstGrandchildCoordinatorMockNode.destinationNodeBox,
                        for: mockDestinationCoordinator
                    )
                }

                it("does not call any of its protocol methods") {
                    expect(mockDestinationCoordinator.receivedCreateSubtreeDestinationDescendent).to(beNil())
                    expect(mockDestinationCoordinator.receivedSwitchSubtreeArgs).to(beNil())
                    expect(mockDestinationCoordinator.receivedCloseAllSubtreesCurrentNode).to(beNil())
                }
            }

        }

    }

}
