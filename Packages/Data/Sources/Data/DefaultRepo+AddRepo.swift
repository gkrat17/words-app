//
//  DefaultRepo+AddRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: AddRepo {
    public func add(word: String, _ handler: @escaping (Result<WordEntity?, Error>) -> Void) {
        // write to the end of the file

        let index = keys.index(of: word)

        if index == NSNotFound {
            keys.add(word)
            values.append(.init(favorite: false, count: 1))
            handler(.success(.init(word: word, index: values.count - 1)))
        } else {
            values[index].count += 1
            handler(.success(nil))
        }
    }
}
