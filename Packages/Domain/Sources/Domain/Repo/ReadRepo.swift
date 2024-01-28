//
//  ReadRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public protocol ReadRepo {
    func read(startIndex: IndexType, pageMaxSize: Int, _: @escaping (Result<[WordEntity], Error>) -> Void)
}
