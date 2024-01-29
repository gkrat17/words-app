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
    var word = WordType()
    private(set) var info = CurrentValueSubject<Loadable<WordInfoEntity>, Never>(.notRequested)
    /* Deps */
    @Inject(container: .usecases) private var infoUsecase: InfoUsecase
    @Inject(container: .usecases) private var favoriteUsecase: FavoriteUsecase
    @Inject(container: .usecases) private var deleteUsecase: DeleteUsecase
}

extension DetailsViewModel {
    func viewDidLoad() {
        infoUsecase.info(of: word) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let entity):
                info.value = .loaded(entity)
            case .failure(let error):
                print(error)
            }
        }
    }

    func remove() {
        deleteUsecase.delete(word: word) { _ in {}() }
    }

    func favorite(isOn: Bool) {
        favoriteUsecase.favorite(word: word) { _ in {}() }
    }
}
