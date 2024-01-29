//
//  ReadUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

public protocol ReadUsecase {
    func read(startIndex: IndexType, pageMaxSize: Int, _: @escaping (Result<[WordEntity], Error>) -> Void)
}

public final class DefaultReadUsecase: ReadUsecase {
    @Inject(container: .repos) private var readRepo: ReadRepo

    public init() {}

    public func read(startIndex: IndexType, pageMaxSize: Int, _ handler: @escaping (Result<[WordEntity], Error>) -> Void) {
        readRepo.read(startIndex: startIndex, pageMaxSize: pageMaxSize, handler)
    }
}
