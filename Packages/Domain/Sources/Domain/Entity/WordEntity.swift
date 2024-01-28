//
//  WordEntity.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public final class WordEntity {
    public var word: WordType
    public var favorite: Bool
    public var count: UInt

    public init(word: WordType, favorite: Bool, count: UInt) {
        self.word = word
        self.favorite = favorite
        self.count = count
    }
}
