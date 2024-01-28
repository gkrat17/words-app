//
//  EventUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine

public protocol EventPublishingUsecase {
    var publisher: AnyPublisher<EventEntity, Never> { get }
}

public protocol EventSendingUsecase {
    func send(entity: EventEntity)
}

public protocol EventUsecase: EventPublishingUsecase, EventSendingUsecase {}

public final class DefaultEventUsecase: EventUsecase {
    private lazy var _publisher = PassthroughSubject<EventEntity, Never>()

    public var publisher: AnyPublisher<EventEntity, Never> {
        _publisher.eraseToAnyPublisher()
    }

    public func send(entity: EventEntity) {
        _publisher.send(entity)
    }
}
