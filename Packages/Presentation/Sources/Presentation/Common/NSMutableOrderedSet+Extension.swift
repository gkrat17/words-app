//
//  NSMutableOrderedSet+Extension.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Foundation

extension NSMutableOrderedSet {
    func insertionIndex(of element: Element, areInIncreasingOrder: (Element, Element) -> Bool) -> Int {
        var low = 0
        var high = count - 1
        while low <= high {
            let middle = (low + high) / 2
            if areInIncreasingOrder(self[middle], element) {
                low = middle + 1
            } else if areInIncreasingOrder(element, self[middle]) {
                high = middle - 1
            } else {
                return middle
            }
        }
        return low
    }
}
