//
//  DependencyContainer.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

extension DependencyContainer {
    static var repos = DependencyContainer {}
}

extension DependencyContainer {
    static var usecases = DependencyContainer {
        Dependency { DefaultAddUsecase() as AddUsecase }
        Dependency { DefaultEventUsecase() as EventUsecase }
    }
}
