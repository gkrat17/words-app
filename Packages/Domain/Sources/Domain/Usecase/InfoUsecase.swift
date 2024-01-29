//
//  InfoUsecase.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import DI

public protocol InfoUsecase {
    func info(of: WordType, _: @escaping (Result<WordInfoEntity, Error>) -> Void)
}

public final class DefaultDetailsUsecase: InfoUsecase {
    @Inject(container: .repos) private var repo: InfoRepo

    public init() {}

    public func info(of word: WordType, _ handler: @escaping (Result<WordInfoEntity, Error>) -> Void) {
        repo.info(of: word, handler)
    }
}
