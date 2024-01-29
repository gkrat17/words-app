//
//  DefaultRepo+InfoRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: InfoRepo {
    public func info(of word: WordType, _ handler: @escaping (Result<WordInfoEntity, Error>) -> Void) {
        let index = keys.index(of: WordEntity(word: word))
        if index == NSNotFound {
            handler(.failure(ErrorEntity.error))
        } else {
            handler(.success(values[index]))
        }
    }
}
