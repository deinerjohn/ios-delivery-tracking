//
//  OrderDetailsViewModel.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import SwiftUI
import Domain

final class OrderDetailsViewModel: ObservableObject {

    @Published private(set) var status: OrderStatus

    private let useCase: OrderStatusUseCase
    private let orderId: UUID
    private var task: Task<Void, Never>?

    init(order: Order, useCase: OrderStatusUseCase) {
        self.status = order.status
        self.orderId = order.id
        self.useCase = useCase
    }

    @MainActor func startObserving() {
        task = Task {
            for await newStatus in useCase.execute(id: orderId) {
                status = newStatus
            }
        }
    }
    
    func stopObserving() {
        task?.cancel()
    }
}
