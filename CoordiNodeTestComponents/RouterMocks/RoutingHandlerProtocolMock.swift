//
//  RoutingHandlerProtocolMock.swift
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

// swiftlint:disable large_tuple
public class RoutingHandlerProtocolMock<TTestedRouter: RouterProtocol>: RoutingHandlerProtocol {

    public typealias ResultType = RoutingHandlerResult<TTestedRouter.TDescendent>?

    public init() {}

    // MARK: - determineRouting<TRouter: RouterProtocol>

    public var determineRoutingFromToForCallsCount = 0
    public var determineRoutingFromToForCalled: Bool {
        return determineRoutingFromToForCallsCount > 0
    }
    public var determineRoutingFromToForReceivedArguments: (currentNode: NodeBox, destinationDescendent: TTestedRouter.TDestinationDescendent, router: TTestedRouter)?
    public var determineRoutingFromToForReturnValue: ResultType!
    public var determineRoutingFromToForClosure: ((NodeBox, TTestedRouter.TDestinationDescendent, TTestedRouter) -> ResultType)?

    public func determineRouting<TRouter: RouterProtocol>(
        from currentNode: NodeBox,
        to destinationDescendent: TRouter.TDestinationDescendent,
        for router: TRouter
    ) -> RoutingHandlerResult<TRouter.TDescendent>? {
        determineRoutingFromToForCallsCount += 1
        determineRoutingFromToForReceivedArguments = (
            currentNode: currentNode,
            destinationDescendent: destinationDescendent as! TTestedRouter.TDescendent.TDestinationDescendent,
            router: router as! TTestedRouter
        )

        let resultFromClosure =
            determineRoutingFromToForClosure.flatMap({ closure in closure(
                currentNode,
                destinationDescendent as! TTestedRouter.TDescendent.TDestinationDescendent,
                router as! TTestedRouter)
            })

        return
            (resultFromClosure.flatMap({ $0 as? RoutingHandlerResult<TRouter.TDescendent> }))
            ?? (determineRoutingFromToForReturnValue.flatMap({ $0 as? RoutingHandlerResult<TRouter.TDescendent> }))
    }

}
