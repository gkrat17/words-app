//
//  DefaultRepo+FavoriteRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: FavoriteRepo {
    public func favorite(word: String, _ handler: @escaping (Result<WordEntity?, Error>) -> Void) {
        update(word: word, favorite: true, handler)
    }

    public func unfavorite(word: String, _ handler: @escaping (Result<WordEntity?, Error>) -> Void) {
        update(word: word, favorite: false, handler)
    }

    private func update(word: String, favorite: Bool, _ handler: @escaping (Result<WordEntity?, Error>) -> Void) {
        let index = keys.index(of: word)
        guard index != NSNotFound else { return handler(.failure(ErrorEntity.error)) }
        values[index].favorite = favorite
        handler(.success(.init(word: word, index: index)))
    }
}
