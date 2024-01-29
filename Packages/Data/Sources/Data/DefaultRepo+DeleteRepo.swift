//
//  DefaultRepo+DeleteRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: DeleteRepo {
    public func delete(word: WordType, _ handler: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try deleteLast(string: word)
        } catch {
            return handler(.failure(ErrorEntity.error))
        }

        let word = WordEntity(word: word)
        let index = keys.index(of: word)

        guard index != NSNotFound,
              values[index].count > .zero
        else { return handler(.failure(ErrorEntity.error)) }

        values[index].count -= 1

        if values[index].count == .zero {
            keys.remove(word)
            values.remove(at: index) // insufficient part :(
            handler(.success(true))
        } else {
            handler(.success(false))
        }
    }
}
