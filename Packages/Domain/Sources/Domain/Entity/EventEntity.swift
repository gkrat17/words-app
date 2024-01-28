//
//  EventEntity.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

public final class EventEntity {
    public let type: EventType
    public let index: IndexType
    public let word: WordType

    public init(type: EventType, index: IndexType, word: WordType) {
        self.type = type
        self.index = index
        self.word = word
    }
}
