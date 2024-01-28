//
//  DetailsCoordinator.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import Domain
import UIKit

protocol DetailsCoordinator {
    func start(with entity: WordType)
}

final class DefaultDetailsCoordinator: DetailsCoordinator {
    @Inject(container: .default) private var navigationController: UINavigationController

    func start(with entity: WordType) {
        let viewController = DetailsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
