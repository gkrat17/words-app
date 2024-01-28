//
//  ArrayWordType+Extension.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Foundation

public extension [WordType] {
    func filter(with query: String) -> [WordType] {
        if query.isEmpty {
            self
        } else {
            compactMap {
                $0.contains(query) ? $0 : nil
            }
        }
    }
}
