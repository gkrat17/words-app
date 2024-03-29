//
//  FavoriteUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

public protocol FavoriteUsecase: FavoritingUsecase, UnfavoritingUsecase {}

public protocol FavoritingUsecase {
    func favorite(word: WordType, _: @escaping (Result<Void, Error>) -> Void)
}

public protocol UnfavoritingUsecase {
    func unfavorite(word: WordType, _: @escaping (Result<Void, Error>) -> Void)
}

public final class DefaultFavoriteUsecase: FavoriteUsecase {
    @Inject(container: .usecases) private var eventSendingUsecase: EventSendingUsecase
    @Inject(container: .repos) private var favoriteRepo: FavoriteRepo

    public init() {}

    public func favorite(word: WordType, _ handler: @escaping (Result<Void, Error>) -> Void) {
        favoriteRepo.favorite(word: word) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entity):
                eventSendingUsecase.send(event: .favorite(entity))
                handler(.success(()))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    public func unfavorite(word: WordType, _ handler: @escaping (Result<Void, Error>) -> Void) {
        favoriteRepo.unfavorite(word: word) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entity):
                eventSendingUsecase.send(event: .unfavorite(entity))
                handler(.success(()))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
