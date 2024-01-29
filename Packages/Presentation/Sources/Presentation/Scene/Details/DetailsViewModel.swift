//
//  DetailsViewModel.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine
import DI
import Domain

final class DetailsViewModel {
    /* State */
    private(set) var word = CurrentValueSubject<WordType, Never>(.init())
    private(set) var count = CurrentValueSubject<Int, Never>(.zero)
    private(set) var favorite = CurrentValueSubject<Bool, Never>(false)
    private(set) var isEnabledAdd = CurrentValueSubject<Bool, Never>(true)
    private(set) var isEnabledDelete = CurrentValueSubject<Bool, Never>(true)
    /* Deps */
    @Inject(container: .usecases) private var infoUsecase: InfoUsecase
    @Inject(container: .usecases) private var favoriteUsecase: FavoriteUsecase
    @Inject(container: .usecases) private var deleteUsecase: DeleteUsecase
    @Inject(container: .usecases) private var addUsecase: AddUsecase
}

extension DetailsViewModel {
    func set(word: WordType) {
        self.word.value = word
    }

    func viewDidLoad() {
        infoUsecase.info(of: word.value) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entity):
                count.value = entity.count
                favorite.value = entity.favorite
            case .failure(let error): print(error)
            }
        }
    }

    func delete() {
        enable(false)
        deleteUsecase.delete(word: word.value) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                count.value -= 1
                if count.value == .zero {
                    favorite.value = false
                    isEnabledDelete.value = false
                    isEnabledAdd.value = true
                    return
                }
            case .failure(let error): print(error)
            }
            enable(true)
        }
    }

    func favorite(isOn: Bool) {
        let handler: ((Result<Void, Error>) -> Void) = {
            switch $0 {
            case .success: ()
            case .failure(let error): print(error)
            }
        }
        if isOn {
            favoriteUsecase.favorite(word: word.value, handler)
        } else {
            favoriteUsecase.unfavorite(word: word.value, handler)
        }
    }

    func add() {
        enable(false)
        addUsecase.add(word: word.value) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success:
                count.value += 1
            case .failure(let error): print(error)
            }
            enable(true)
        }
    }
}

fileprivate extension DetailsViewModel {
    func enable(_ value: Bool) {
        isEnabledAdd.value = value
        isEnabledDelete.value = value
    }
}
