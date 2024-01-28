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
    private var favorites = CurrentValueSubject<Set<IndexType>, Never>(.init())
    private var list = [WordType]()
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

        eventUsecase.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.handle(event: $0)
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
                } else {
                    list.append(contentsOf: result)
                    page.value = .loaded(result.filter(with: query.value))
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func handle(event: EventEntity) {
        switch event.type {
        case .add(let word): handleEventAdd(word, event.index)
        case .delete:        handleEventDelete(event.index)
        case .favorite:      handleEventFavorite(event.index)
        case .unfavorite:    handleEventUnfavorite(event.index)
        }
    }

    func handleEventAdd(_ word: WordType, _ index: IndexType) {
        let count = list.count
        if index == count {
            list.append(word)
        } else if index < count {
            list.insert(word, at: index)
        }
    }

    func handleEventDelete(_ index: IndexType) {
        if index < list.count {
            list.remove(at: index)
            favorites.value.remove(index)
        }
    }

    func handleEventFavorite(_ index: IndexType) {
        favorites.value.insert(index)
    }

    func handleEventUnfavorite(_ index: IndexType) {
        favorites.value.remove(index)
    }
}
