//
//  ReadUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import DI

public protocol ReadUsecase {
    func read(afterIndex: IndexType, pageMaxSize: UInt, _: @escaping (Result<[WordEntity], Error>) -> Void)
}

final class DefaultReadUsecase: ReadUsecase {
    @Inject(container: .repos) private var readRepo: ReadRepo

    func read(afterIndex: IndexType, pageMaxSize: UInt, _ handler: @escaping (Result<[WordEntity], Error>) -> Void) {
        readRepo.read(afterIndex: afterIndex, pageMaxSize: pageMaxSize, handler)
    }
}
