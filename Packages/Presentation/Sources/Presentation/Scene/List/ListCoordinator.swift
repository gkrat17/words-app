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
    func onWordEntity(entity: WordEntity)
}

final class DefaultListCoordinator: ListCoordinator {
    @Inject(container: .default) private var navigationController: UINavigationController
    @Inject(container: .coordinators) private var detailsCoordinator: DetailsCoordinator

    func start() {
        navigationController.pushViewController(ListViewController(), animated: true)
    }

    func onWordEntity(entity: WordEntity) {
        detailsCoordinator.start(with: entity)
    }
}
