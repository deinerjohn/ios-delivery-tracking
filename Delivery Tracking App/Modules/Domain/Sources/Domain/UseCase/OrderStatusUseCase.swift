//
//  OrderStatusUseCase.swift
//  Domain
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

public protocol OrderStatusUseCase {
    func execute(id: UUID) -> AsyncStream<OrderStatus>
}

public class OrderStatusUseCaseImpl: OrderStatusUseCase {
    
    private let repository: OrderListRepository
    
    public init(repository: OrderListRepository) {
        self.repository = repository
    }
    
    public func execute(id: UUID) -> AsyncStream<OrderStatus> {
        repository.observeOrderStatus(orderId: id)
    }
}
