//
//  EventUsecase.swift
//
//  Created by giorgi kratsashvili on 28.01.24.
//

import Combine

public protocol EventPublishingUsecase {
    var publisher: AnyPublisher<EventType, Never> { get }
}

public protocol EventSendingUsecase {
    func send(event: EventType)
}

public protocol EventUsecase: EventPublishingUsecase, EventSendingUsecase {}

public final class DefaultEventUsecase: EventUsecase {
    private lazy var _publisher = PassthroughSubject<EventType, Never>()

    public init() {}

    public var publisher: AnyPublisher<EventType, Never> {
        _publisher.eraseToAnyPublisher()
    }

    public func send(event: EventType) {
        _publisher.send(event)
    }
}
