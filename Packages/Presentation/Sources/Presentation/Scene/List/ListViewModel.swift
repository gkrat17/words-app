//
//  ListViewModel.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine
import DI
import Domain
import Foundation

final class ListViewModel {
    /* State */
    var query = CurrentValueSubject<String, Never>(.init())
    private(set) var page = CurrentValueSubject<Loadable<[WordType]>, Never>(.notRequested)
    private(set) var clear = PassthroughSubject<Void, Never>()
    private(set) var list = [WordType]()
    private var loaded = false
    /* Deps */
    @Inject(container: .usecases) private var readUsecase: ReadUsecase
    @Inject(container: .usecases) private var eventUsecase: EventUsecase
    @Inject(container: .coordinators) private var coordinator: ListCoordinator
    /* Misc */
    private var cancellables = Set<AnyCancellable>()

    nonisolated init() {}

    func configure() {
        query
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                clear.send(())
                page.value = .loaded(list.filter(with: query))
            }.store(in: &cancellables)
    }
}

extension ListViewModel {
    func viewDidLoad() {
        tryFetchNextPage()
    }

    func cellWillDisplay(at index: Int) {
        if index == list.count - 1 {
            tryFetchNextPage()
        }
    }

    func didSelectItemAt(at index: Int) {
        guard index < list.count else { return }
        let entity = list[index]
        coordinator.on(word: entity)
    }
}

fileprivate extension ListViewModel {
    func tryFetchNextPage() {
        if loaded { return }

        if case .isLoading = page.value { return }
        page.value = .isLoading

        readUsecase.read(startIndex: list.count, pageMaxSize: 20) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                if result.isEmpty {
                    loaded = true
                    return
                }
                list.append(contentsOf: result)
                page.value = .loaded(result.filter(with: query.value))
            case .failure(let error):
                print(error)
            }
        }
    }
}
