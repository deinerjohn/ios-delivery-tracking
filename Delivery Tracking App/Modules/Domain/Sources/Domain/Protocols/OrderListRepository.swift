//
//  OrderListRepository.swift
//  Domain
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

public protocol OrderListRepository {
    func fetchOrders() async throws -> [Order]
    func observeOrderStatus(orderId: UUID) -> AsyncStream<OrderStatus>
}
