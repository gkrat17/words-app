//
//  WordEntity.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public final class WordEntity {
    public var word: WordType
    public var info: WordInfoEntity

    public init(word: WordType, info: WordInfoEntity) {
        self.word = word
        self.info = info
    }
}
