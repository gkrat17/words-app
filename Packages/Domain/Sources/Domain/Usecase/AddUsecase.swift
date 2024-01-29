//
//  AddUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

public protocol AddUsecase {
    func add(word: WordType, _: @escaping (Result<Void, Error>) -> Void)
}

public final class DefaultAddUsecase: AddUsecase {
    @Inject(container: .usecases) private var eventSendingUsecase: EventSendingUsecase
    @Inject(container: .repos) private var addRepo: AddRepo

    public init() {}

    public func add(word: WordType, _ handler: @escaping (Result<Void, Error>) -> Void) {
        addRepo.add(word: word) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entity):
                if let entity {
                    eventSendingUsecase.send(event: .add(entity))
                }
                handler(.success(()))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
