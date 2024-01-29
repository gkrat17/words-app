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
    private(set) var page = CurrentValueSubject<Loadable<[WordType]>, Never>(.notRequested)
    private(set) var replace = PassthroughSubject<ReplaceModel, Never>()
    private(set) var remove = PassthroughSubject<WordType, Never>()
    private var favorites = NSMutableOrderedSet() // OrderedSet<WordModel>
    private var nonfavorites = NSMutableOrderedSet() // OrderedSet<WordModel>
    private var loaded = false
    /* Deps */
    @Inject(container: .usecases) private var readUsecase: ReadUsecase
    @Inject(container: .usecases) private var addUsecase: AddUsecase
    @Inject(container: .usecases) private var eventUsecase: EventUsecase
    @Inject(container: .coordinators) private var coordinator: ListCoordinator
    /* Misc */
    private var cancellable: AnyCancellable?

    func configure() {
        cancellable = eventUsecase.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.handle(event: $0)
            }
    }
}

extension ListViewModel {
    func viewDidLoad() {
        tryFetchNextPage()
    }

    func cellWillDisplay(at indexPath: IndexPath) {
        if indexPath.section == SectionType.main.rawValue,
           favorites.count + indexPath.row == nonfavorites.count - 1 {
            tryFetchNextPage()
        }
    }

    func didSelect(word: WordType) {
        coordinator.on(word: word)
    }

    func add(word: WordType) {
        addUsecase.add(word: word) {
            switch $0 {
            case .success: ()
            case .failure(let error): print(error)
            }
        }
    }
}

fileprivate extension ListViewModel {
    func tryFetchNextPage() {
        if loaded { return }

        if case .isLoading = page.value { return }
        page.value = .isLoading

        readUsecase.read(startIndex: count, pageMaxSize: 20) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                if result.isEmpty {
                    loaded = true
                } else {
                    let count = count
                    result
                        .enumerated()
                        .forEach {
                            self.nonfavorites.add(FavoriteModel(word: $1, index: count + $0))
                        }
                    page.value = .loaded(result)
                }
            case .failure(let error): print(error)
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
        guard event.index == count else { return }
        nonfavorites.add(FavoriteModel(word: event.word, index: event.index))
        page.send(.loaded([event.word]))
    }

    func handleDelete(event: EventEntity) {
        let model = FavoriteModel(word: event.word, index: event.index)
        favorites.remove(model)
        nonfavorites.remove(model)
        remove.send(event.word)
    }

    func handleFavorite(event: EventEntity) {
        let favorite = FavoriteModel(word: event.word, index: event.index)

        guard !favorites.contains(favorite), nonfavorites.contains(favorite) else { return }

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
        nonfavorites.remove(favorite)

        replace.send(.init(section: .favorites, item: favorite.word, neighbor: neighbor))
    }

    func handleUnfavorite(event: EventEntity) {
        let favorite = FavoriteModel(word: event.word, index: event.index)

        guard favorites.contains(favorite), !nonfavorites.contains(favorite) else { return }

        let insertionIndex = nonfavorites.insertionIndex(of: favorite) {
            ($0 as! FavoriteModel).index < ($1 as! FavoriteModel).index
        }

        var neighbor: ReplaceModel.NeighborType? = nil
        if insertionIndex == .zero {
            if nonfavorites.count > .zero {
                neighbor = .before((nonfavorites[.zero] as! FavoriteModel).word)
            }
        } else {
            neighbor = .after((nonfavorites[insertionIndex - 1] as! FavoriteModel).word)
        }

        nonfavorites.insert(favorite, at: insertionIndex)
        favorites.remove(favorite)

        replace.send(.init(section: .main, item: favorite.word, neighbor: neighbor))
    }

    var count: Int { favorites.count + nonfavorites.count }
}
