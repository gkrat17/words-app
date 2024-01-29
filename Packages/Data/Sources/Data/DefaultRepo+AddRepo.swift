//
//  DefaultRepo+AddRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: AddRepo {
    public func add(word: WordType, _ handler: @escaping (Result<WordEntity?, Error>) -> Void) {
        do {
            try append(string: word)
        } catch {
            return handler(.failure(ErrorEntity.error))
        }

        let index = keys.index(of: WordEntity(word: word))

        if index == NSNotFound {
            let entity = WordEntity(word: word, index: _index)
            _index += 1
            keys.add(entity)
            values.append(.init(favorite: false, count: 1))
            handler(.success(entity))
        } else {
            values[index].count += 1
            handler(.success(nil))
        }
    }
}
