//
//  WordInfoEntity.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public final class WordInfoEntity {
    public var favorite: Bool
    public var count: Int

    public init(favorite: Bool, count: Int) {
        self.favorite = favorite
        self.count = count
    }
}
