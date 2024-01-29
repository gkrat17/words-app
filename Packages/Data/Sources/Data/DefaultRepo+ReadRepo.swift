//
//  DefaultRepo+ReadRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//


import Domain
import Foundation

extension DefaultRepo: ReadRepo {
    public func read(startIndex: IndexType, pageMaxSize: Int, _ handler: @escaping (Result<[WordEntity], Error>) -> Void) {
        guard startIndex < keys.count else {
            handler(.success([]))
            return
        }
        let endIndex = min(startIndex - 1 + pageMaxSize, keys.count - 1)
        var result = Array<WordEntity>()
        for i in startIndex...endIndex {
            result.append(.init(word: keys[i] as! WordType, index: i))
        }
        handler(.success(result))
    }
}
