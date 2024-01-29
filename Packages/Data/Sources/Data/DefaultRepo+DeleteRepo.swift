//
//  DefaultRepo+DeleteRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: DeleteRepo {
    public func delete(word: String, _ handler: @escaping (Result<WordEntity?, Error>) -> Void) {
        do {
            try deleteLast(string: word)
        } catch {
            handler(.failure(ErrorEntity.error))
        }

        let index = keys.index(of: word)

        guard index != NSNotFound,
              values[index].count > .zero
        else {
            handler(.failure(ErrorEntity.error))
            return
        }

        values[index].count -= 1

        if values[index].count == .zero {
            keys.remove(word)
            values.remove(at: index) // insufficient part :(
            handler(.success(.init(word: word, index: index)))
        } else {
            handler(.success(nil))
        }
    }
}
