//
//  DeleteUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

public protocol DeleteUsecase {
    func delete(word: WordType, _: @escaping (Result<Void, Error>) -> Void)
}

public final class DefaultDeleteUsecase: DeleteUsecase {
    @Inject(container: .usecases) private var eventSendingUsecase: EventSendingUsecase
    @Inject(container: .repos) private var deleteRepo: DeleteRepo

    public init() {}

    public func delete(word: WordType, _ handler: @escaping (Result<Void, Error>) -> Void) {
        deleteRepo.delete(word: word) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entity):
                if let entity {
                    eventSendingUsecase.send(entity: .init(type: .delete, entity: entity))
                }
                handler(.success(()))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
