//
//  MockOrderListRepository.swift
//  Data
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation
import Domain

@MainActor
public final class MockOrderListRepository: @preconcurrency OrderListRepository {

    private var orders: [Order]

    public init(initialOrders: [Order]? = nil) {
        self.orders = initialOrders ?? [
            Order(id: UUID(), title: "Order #001", status: .pending),
            Order(id: UUID(), title: "Order #002", status: .pending),
            Order(id: UUID(), title: "Order #003", status: .pending),
            Order(id: UUID(), title: "Order #004", status: .pending),
            Order(id: UUID(), title: "Order #005", status: .pending),
            Order(id: UUID(), title: "Order #006", status: .inTransit),
            Order(id: UUID(), title: "Order #007", status: .delivered)
        ]
    }

    public func fetchOrders() async throws -> [Order] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return orders
    }

    public func updateOrderStatus(orderId: UUID, newStatus: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = newStatus
        }
    }

    public func observeOrderStatus(orderId: UUID) -> AsyncStream<OrderStatus> {
        AsyncStream { continuation in
            guard let orderIndex = orders.firstIndex(where: { $0.id == orderId }) else {
                continuation.finish()
                return
            }

            let initialStatus = orders[orderIndex].status
            continuation.yield(initialStatus)

            let task = Task {
                let statuses: [OrderStatus] = [.pending, .inTransit, .delivered]
                guard let startIndex = statuses.firstIndex(of: initialStatus) else {
                    continuation.finish()
                    return
                }

                for index in (startIndex+1)..<statuses.count {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    let nextStatus = statuses[index]
                    updateOrderStatus(orderId: orderId, newStatus: nextStatus)
                    continuation.yield(nextStatus)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
