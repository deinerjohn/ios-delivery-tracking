//
//  OrderListViewModel.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation
import SwiftUI
import Combine
import Domain

final class OrderListViewModel: ObservableObject {
    
    @Published private(set) var state: Loadable<[Order]> = .idle
    @Published var selectedStatus: OrderStatus?
    private let useCase: OrderListUseCase
    
    init(useCase: OrderListUseCase) {
        self.useCase = useCase
    }
    
    @MainActor func loadOrders() async {
        do {
            let orders = try await useCase.execute()
            state = orders.isEmpty ? .empty : .loaded(orders)
        } catch {
            state = .error("Failed to load orders")
        }
    }

    var filteredOrders: [Order] {
        guard case let .loaded(orders) = state else { return [] }
        guard let selectedStatus else { return orders }
        return orders.filter { $0.status == selectedStatus }
    }
    
}
