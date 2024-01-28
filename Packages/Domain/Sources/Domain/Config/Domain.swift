//
//  Domain.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

public enum Domain {
    public static func configure(usecases: DependencyContainer) {
        DependencyContainer.usecases = usecases
    }

    public static func configure(repos: DependencyContainer) {
        DependencyContainer.repos = repos
    }
}
