//
//  ListViewModel.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine
import DI
import Domain
import Foundation

@MainActor final class ListViewModel {
    /* State */
    var query = CurrentValueSubject<String, Never>("")
    private(set) var latestPage = CurrentValueSubject<Loadable<[WordEntity]>, Never>(.notRequested)
    private(set) var clear = PassthroughSubject<Void, Never>()
    private(set) var list = [WordEntity]()
    /* Deps */
    @Inject(container: .usecases) private var readUsecase: ReadUsecase
    @Inject(container: .coordinators) private var coordinator: ListCoordinator
    /* Misc */
    private var cancellable: AnyCancellable?

    nonisolated init() {}

    func configure() {
        cancellable = query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] in
                guard let self else { return }
                list.removeAll()
                clear.send(())
                fetchNextPage(startIndex: .zero, query: $0)
            }
    }
}

extension ListViewModel {
    func viewDidLoad() {
        fetchNextPage(startIndex: .zero)
    }

    func cellWillDisplay(at index: Int) {
        if index == list.count - 1 {
            fetchNextPage(startIndex: list.count)
        }
    }

    func didSelectItemAt(at index: Int) {
        guard index < list.count else { return }
        let entity = list[index]
        coordinator.onWordEntity(entity: entity)
    }
}

fileprivate extension ListViewModel {
    func fetchNextPage(startIndex: Int, query: String? = nil, pageMaxSize: Int = 5) {
        if case .isLoading = latestPage.value { return }
        latestPage.value = .isLoading
        readUsecase.read(startIndex: startIndex, pageMaxSize: pageMaxSize) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                list.append(contentsOf: result)
                latestPage.value = .loaded(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}
