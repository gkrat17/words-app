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
    private(set) var replace = PassthroughSubject<ReplaceModel, Never>()
    private(set) var remove = PassthroughSubject<WordType, Never>()
    private var favorites = NSMutableOrderedSet()
    private var list = [WordType]()
    private var loaded = false
    /* Deps */
    @Inject(container: .usecases) private var readUsecase: ReadUsecase
    @Inject(container: .usecases) private var addUsecase: AddUsecase
    @Inject(container: .usecases) private var eventUsecase: EventUsecase
    @Inject(container: .coordinators) private var coordinator: ListCoordinator
    /* Misc */
    private var cancellables = Set<AnyCancellable>()

    func configure() {
        query
            .dropFirst()
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

    func didSelect(word: WordType) {
        coordinator.on(word: word)
    }

    func add(word: WordType) {
        addUsecase.add(word: word) { _ in
            {}()
        }
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
        case .add:        handleAdd(event: event)
        case .delete:     handleDelete(event: event)
        case .favorite:   handleFavorite(event: event)
        case .unfavorite: handleUnfavorite(event: event)
        }
    }

    func handleAdd(event: EventEntity) {
        guard event.index == list.count else { return }
        list.append(event.word)
        page.send(.loaded([event.word]))
    }

    func handleDelete(event: EventEntity) {
        if event.index < list.count {
            list.remove(at: event.index)
        }
        remove.send(event.word)
    }

    func handleFavorite(event: EventEntity) {
        let favorite = FavoriteModel(word: event.word, index: event.index)

        guard event.index < list.count, !favorites.contains(favorite) else { return }

        let insertionIndex = favorites.insertionIndex(of: favorite) {
            ($0 as! FavoriteModel).index < ($1 as! FavoriteModel).index
        }

        var neighbor: ReplaceModel.NeighborType? = nil
        if insertionIndex == .zero {
            if favorites.count > .zero {
                neighbor = .before((favorites[.zero] as! FavoriteModel).word)
            }
        } else {
            neighbor = .after((favorites[insertionIndex - 1] as! FavoriteModel).word)
        }

        favorites.insert(favorite, at: insertionIndex)

        replace.send(.init(section: .favorites, item: favorite.word, neighbor: neighbor))
    }
    func handleUnfavorite(event: EventEntity) {
        let favorite = FavoriteModel(word: event.word, index: event.index)

        guard favorites.contains(favorite), favorite.index < list.count else { return }

        favorites.remove(favorite)

        let neighbor: ReplaceModel.NeighborType = if favorite.index == .zero {
            .before(list[.zero])
        } else {
            .after(list[favorite.index - 1])
        }

        replace.send(.init(section: .main, item: favorite.word, neighbor: neighbor))
    }
}

extension NSMutableOrderedSet {
    func insertionIndex(of elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid // found at position mid
            }
        }
        return lo // not found, would be inserted at position lo
    }
}
