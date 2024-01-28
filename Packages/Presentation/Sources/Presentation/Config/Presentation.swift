//
//  Presentation.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI
import UIKit

public enum Presentation {
    public static func configure(usecases: DependencyContainer) {
        DependencyContainer.usecases = usecases
    }

    public static func initial() -> UIViewController {
        defer {
            @Inject(container: .coordinators)
            var controller: ListCoordinator
            controller.start()
        }
        @Inject(container: .default)
        var controller: UINavigationController
        return controller
    }
}
