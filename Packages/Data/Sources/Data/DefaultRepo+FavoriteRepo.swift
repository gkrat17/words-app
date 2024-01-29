//
//  DefaultRepo+FavoriteRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: FavoriteRepo {
    public func favorite(word: WordType, _ handler: @escaping (Result<WordEntity, Error>) -> Void) {
        update(word: word, favorite: true, handler)
    }

    public func unfavorite(word: WordType, _ handler: @escaping (Result<WordEntity, Error>) -> Void) {
        update(word: word, favorite: false, handler)
    }

    private func update(word: WordType, favorite: Bool, _ handler: @escaping (Result<WordEntity, Error>) -> Void) {
        let index = keys.index(of: WordEntity(word: word))
        if index == NSNotFound {
            handler(.failure(ErrorEntity.error))
        } else {
            values[index].favorite = favorite
            handler(.success(keys.object(at: index) as! WordEntity))
        }
    }
}
