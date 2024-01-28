//
//  ListCoordinator.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import Domain
import UIKit

protocol ListCoordinator {
    func start()
    func on(word: WordType)
}

final class DefaultListCoordinator: ListCoordinator {
    @Inject(container: .default) private var navigationController: UINavigationController
    @Inject(container: .coordinators) private var detailsCoordinator: DetailsCoordinator

    func start() {
        navigationController.pushViewController(ListViewController(), animated: true)
    }

    func on(word: WordType) {
        detailsCoordinator.start(with: word)
    }
}
