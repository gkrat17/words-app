//
//  DetailsCoordinator.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import Domain
import UIKit

protocol DetailsCoordinator {
    func start(with entity: String)
}

final class DefaultDetailsCoordinator: DetailsCoordinator {
    @Inject(container: .default) private var navigationController: UINavigationController

    func start(with entity: String) {
        let viewController = DetailsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
