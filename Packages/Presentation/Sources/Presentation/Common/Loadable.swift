//
//  Loadable.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

enum Loadable<T> {
    case notRequested
    case isLoading
    case loaded(T)
    case failed(Error)
}
