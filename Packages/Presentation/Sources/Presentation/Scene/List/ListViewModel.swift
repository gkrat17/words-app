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
    @Inject(container: .usecases) private var eventUsecase: EventPublishingUsecase
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
        if indexPath.section == SectionType.nonfavorites.rawValue,
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
            case .success(let entity):
                if entity.isEmpty {
                    loaded = true
                } else {
                    entity.forEach { self.nonfavorites.add($0) }
                    page.value = .loaded(entity.map { $0.word })
                }
            case .failure(let error): print(error)
            }
        }
    }

    func handle(event: EventType) {
        switch event {
        case .add(let entity):        handleAddEvent(entity: entity)
        case .delete(let word):       handleDeleteEvent(word: word)
        case .favorite(let entity):   handleFavoriteEvent(entity: entity)
        case .unfavorite(let entity): handleUnfavoriteEvent(entity: entity)
        }
    }

    func handleAddEvent(entity: WordEntity) {
        guard loaded else { return }
        nonfavorites.add(entity)
        page.send(.loaded([entity.word]))
    }

    func handleDeleteEvent(word: WordType) {
        let entity = WordEntity(word: word)
        favorites.remove(entity)
        nonfavorites.remove(entity)
        remove.send(entity.word)
    }

    func handleFavoriteEvent(entity: WordEntity) {
        replace(entity: entity, from: nonfavorites, to: favorites, section: .favorites)
    }

    func handleUnfavoriteEvent(entity: WordEntity) {
        replace(entity: entity, from: favorites, to: nonfavorites, section: .nonfavorites)
    }

    func replace(
        entity: WordEntity,
        from: NSMutableOrderedSet,
        to: NSMutableOrderedSet,
        section: SectionType
    ) {
        guard from.contains(entity), !to.contains(entity) else { return }

        let insertionIndex = to.insertionIndex(of: entity) {
            ($0 as! WordEntity).index < ($1 as! WordEntity).index
        }

        var neighbor: ReplaceModel.NeighborType? = nil
        if insertionIndex == .zero {
            if to.count > .zero {
                neighbor = .before((to[.zero] as! WordEntity).word)
            }
        } else {
            neighbor = .after((to[insertionIndex - 1] as! WordEntity).word)
        }

        to.insert(entity, at: insertionIndex)
        from.remove(entity)

        replace.send(.init(section: section, item: entity.word, neighbor: neighbor))
    }

    var count: Int {
        favorites.count + nonfavorites.count
    }
}
