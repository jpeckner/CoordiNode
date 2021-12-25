//
//  CoordinatorOutputTemplate.swift
//  CoordiNodeGenerator
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

import Foundation

extension CoordinatorTree {

    var output: String {
        switch self {
        case .leaf:
            return selfOutput
        case let .nonLeaf(_, treeChildren):
            return """
            \(selfOutput)

            \(descendentOutput(name, treeChildren: treeChildren))
            """
        }
    }

}

private extension CoordinatorTree {

    var selfOutput: String {
        return """
        enum \(name)Node: \(nodeProtocol) {}

        extension \(name): \(coordinatorProtocols) {}

        extension \(name) {
        \(nodeProperties.isDestinationNode ? destinationNodeBoxProperty : nodeBoxProperty)
        }
        """
    }

    private var nodeProtocol: String {
        return nodeProperties.isDestinationNode ? "DestinationNodeProtocol" : "NodeProtocol"
    }

    private var destinationNodeBoxProperty: String {
        return """
            static var destinationNodeBox: DestinationNodeBox {
                return \(name)Node.destinationNodeBox
            }
        """
    }

    private var nodeBoxProperty: String {
        return """
            static var nodeBox: NodeBox {
                return \(name)Node.nodeBox
            }
        """
    }

    private var coordinatorProtocols: String {
        return
            routerProtocol
            + (nodeProperties.isRootNode ? ", RootCoordinatorProtocol" : "")
    }

    private var routerProtocol: String {
        switch self {
        case .leaf:
            return nodeProperties.isDestinationNode ? "DestinationCoordinatorProtocol" : "CoordinatorProtocol"
        case .nonLeaf:
            return nodeProperties.isDestinationNode ? "DestinationRouterProtocol" : "RouterProtocol"
        }
    }

}

// swiftlint:disable closure_end_indentation
// swiftlint:disable function_body_length
private extension CoordinatorTree {

    func descendentOutput(_ name: String,
                          treeChildren: TreeChildren) -> String {
        return """
        // MARK: \(name)Descendent

        enum \(name)Descendent: CaseIterable {
        \(mapMultiLineString(treeChildren.allChildTrees) { """
            case \($0.enumCaseName)
        """})
        }

        extension \(name)Descendent: DescendentProtocol {

            init?(nodeBox: NodeBox) {
                guard let matchingCase = (\(name)Descendent.allCases.first {
                    $0.nodeBox == nodeBox
                }) else { return nil }

                self = matchingCase
            }

            init(destinationDescendent: \(name)DestinationDescendent) {
                switch destinationDescendent {
        \(mapMultiLineString(treeChildren.destinationChildren) { """
                case .\($0.enumCaseName):
                    self = .\($0.enumCaseName)
        """})
                }
            }

            var nodeBox: NodeBox {
                switch self {
        \(mapMultiLineString(treeChildren.allChildTrees) { """
                case .\($0.enumCaseName):
                    return \($0.name)Node.nodeBox
        """})
                }
            }

            var immediateDescendent: \(name)ImmediateDescendent {
                switch self {
        \(mapMultiLineString(treeChildren.allChildren) { """
                case .\($0.tree.enumCaseName):
                    return .\($0.owningImmediateChild.enumCaseName)
        """})
                }
            }

        }

        // MARK: \(name)ImmediateDescendent

        enum \(name)ImmediateDescendent: CaseIterable {
        \(mapMultiLineString(treeChildren.immediateChildren) { """
            case \($0.enumCaseName)
        """})
        }

        extension \(name)ImmediateDescendent: ImmediateDescendentProtocol {

            init?(nodeBox: NodeBox) {
                guard let matchingCase = (\(name)ImmediateDescendent.allCases.first {
                    $0.nodeBox == nodeBox
                }) else { return nil }

                self = matchingCase
            }

            var nodeBox: NodeBox {
                switch self {
        \(mapMultiLineString(treeChildren.immediateChildren) { """
                case .\($0.enumCaseName):
                    return \($0.name)Node.nodeBox
        """})
                }
            }

        }

        // MARK: \(name)DestinationDescendent

        enum \(name)DestinationDescendent: CaseIterable {
        \(mapMultiLineString(treeChildren.destinationChildren) { """
            case \($0.enumCaseName)
        """})
        }

        extension \(name)DestinationDescendent: DestinationDescendentProtocol {

            init?(destinationNodeBox: DestinationNodeBox) {
                guard let matchingCase = (\(name)DestinationDescendent.allCases.first {
                    $0.destinationNodeBox == destinationNodeBox
                }) else { return nil }

                self = matchingCase
            }

            var destinationNodeBox: DestinationNodeBox {
                switch self {
        \(mapMultiLineString(treeChildren.destinationChildren) { """
                case .\($0.enumCaseName):
                    return \($0.name)Node.destinationNodeBox
        """})
                }
            }

        }
        """
    }

    private func mapMultiLineString<T>(_ array: [T],
                                       mappingBlock: (T) -> String) -> String {
        var result = ""
        for idx in 0..<array.count {
            if idx != 0 { result.append("\n") }
            result.append(mappingBlock(array[idx]))
        }

        return result
    }

}
// swiftlint:enable closure_end_indentation
// swiftlint:enable function_body_length
