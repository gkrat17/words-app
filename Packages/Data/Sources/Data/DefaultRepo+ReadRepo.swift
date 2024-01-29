//
//  DefaultRepo+ReadRepo.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

import Domain
import Foundation

extension DefaultRepo: ReadRepo {
    public func read(startIndex: Int, pageMaxSize: Int, _ handler: @escaping (Result<[WordEntity], Error>) -> Void) {
        guard startIndex < keys.count else {
            return handler(.success([]))
        }
        let endIndex = min(startIndex - 1 + pageMaxSize, keys.count - 1)
        var result = [WordEntity]()
        for i in startIndex...endIndex {
            result.append(keys[i] as! WordEntity)
        }
        handler(.success(result))
    }
}
