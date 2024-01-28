//
//  DependencyContainer.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import UIKit

extension DependencyContainer {
    static var Usecases = DependencyContainer {}
}

extension DependencyContainer {
    static var viewModels = DependencyContainer {
        Dependency(instanceType: .new) { ListViewModel() }
        Dependency(instanceType: .new) { DetailsViewModel() }
    }
    static var coordinators = DependencyContainer {
        Dependency { DefaultListCoordinator() as ListCoordinator }
        Dependency { DefaultDetailsCoordinator() as DetailsCoordinator }
    }
    static var `default` = DependencyContainer {
        Dependency { UINavigationController() }
    }
}
