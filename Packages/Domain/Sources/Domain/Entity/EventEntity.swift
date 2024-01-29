//
//  EventEntity.swift
//
//  Created by giorgi kratsashvili on 29.01.24.
//

public final class EventEntity {
    public let type: EventType
    public let entity: WordEntity

    public init(type: EventType, entity: WordEntity) {
        self.type = type
        self.entity = entity
    }
}
