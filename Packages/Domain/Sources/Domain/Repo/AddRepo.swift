//
//  AddRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public protocol AddRepo {
    func add(word: WordType, _: @escaping (Result<WordEntity?, Error>) -> Void)
}
