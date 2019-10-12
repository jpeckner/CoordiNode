//
//  Array+Duplicates.swift
//  CoordiNodeGenerator
//
//  Created by Justin Peckner.
//  Copyright © 2019 Justin Peckner. All rights reserved.
//

import Foundation

extension Array {

    func filterDuplicates<T: Equatable>(propertyBlock: (Element) -> T) -> [T] {
        var duplicates: [T] = []

        for low in 0..<count {
            let lowValue: T = propertyBlock(self[low])

            for high in 1..<count {
                guard low != high else { continue }

                let highValue: T = propertyBlock(self[high])
                if lowValue == highValue,
                    !duplicates.contains(highValue) {
                    duplicates.append(highValue)
                }
            }
        }

        return duplicates
    }

}
