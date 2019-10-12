//
//  RoutingHandlerTests.swift
//  CoordiNodeTests
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

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
