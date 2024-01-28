//
//  WordInfoEntity.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public final class WordInfoEntity {
    public var favorite: Bool
    public var count: UInt

    public init(favorite: Bool, count: UInt) {
        self.favorite = favorite
        self.count = count
    }
}
