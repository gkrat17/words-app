//
//  DeleteRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public protocol DeleteRepo {
    func delete(word: WordType, _: @escaping (Result<WordEntity?, Error>) -> Void)
}
