//
//  FavoriteRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public protocol FavoriteRepo: FavoritingRepo, UnfavoritingRepo {}

public protocol FavoritingRepo {
    func favorite(word: WordType, _: @escaping (Result<WordEntity?, Error>) -> Void)
}

public protocol UnfavoritingRepo {
    func unfavorite(word: WordType, _: @escaping (Result<WordEntity?, Error>) -> Void)
}
