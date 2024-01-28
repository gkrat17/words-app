//
//  ListViewModel.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine
import DI
import Domain

@MainActor final class ListViewModel: ObservableObject {
    /* State */
    @Published private(set) var latestPage: Loadable<[WordEntity]> = .notRequested
    private var list = [WordEntity]()
    /* Deps */
    @Inject(container: .usecases) private var readUsecase: ReadUsecase
    @Inject(container: .coordinators) private var coordinator: ListCoordinator

    nonisolated init() {}
}

extension ListViewModel {
    func viewDidLoad() {
        fetchNextPage()
    }

    func cellWillDisplay(at index: Int) {
        if index == list.count - 1 {
            fetchNextPage()
        }
    }

    func didSelectItemAt(at index: Int) {
        guard index < list.count else { return }
        let entity = list[index]
        coordinator.onWordEntity(entity: entity)
    }
}

fileprivate extension ListViewModel {
    func fetchNextPage() {
        if case .isLoading = latestPage { return }
        latestPage = .isLoading
        readUsecase.read(startIndex: list.count, pageMaxSize: 5) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                list.append(contentsOf: result)
                latestPage = .loaded(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}
