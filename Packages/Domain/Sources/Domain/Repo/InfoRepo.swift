//
//  InfoRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

public protocol InfoRepo {
    func info(of: WordType, _: @escaping (Result<WordInfoEntity, Error>) -> Void)
}
