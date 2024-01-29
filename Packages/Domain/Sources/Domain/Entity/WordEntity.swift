//
//  WordEntity.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public struct WordEntity: Hashable {
    public let word: WordType
    public let index: IndexType

    public init(word: WordType, index: IndexType) {
        self.word = word
        self.index = index
    }

    public static func == (lhs: WordEntity, rhs: WordEntity) -> Bool {
        lhs.word == rhs.word && lhs.index == rhs.index
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(word)
        hasher.combine(index)
    }
}
