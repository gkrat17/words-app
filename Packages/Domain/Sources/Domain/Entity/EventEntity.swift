//
//  EventEntity.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

public final class EventEntity {
    public let type: EventType
    public let index: IndexType

    public init(type: EventType, index: IndexType) {
        self.type = type
        self.index = index
    }
}
