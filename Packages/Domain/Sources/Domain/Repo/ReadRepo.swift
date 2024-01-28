//
//  ReadRepo.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public protocol ReadRepo {
    func read(afterIndex: IndexType, pageMaxSize: UInt, _: @escaping (Result<[WordEntity], Error>) -> Void)
}
