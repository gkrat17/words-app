//
//  EventType.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

public enum EventType {
    case add(WordEntity)
    case delete(WordType)
    case favorite(WordEntity)
    case unfavorite(WordEntity)
}
