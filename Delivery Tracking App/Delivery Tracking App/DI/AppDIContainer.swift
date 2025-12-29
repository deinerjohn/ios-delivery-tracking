//
//  AppDIContainer.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation
import Domain
import Data

@MainActor
final class AppDIContainer {

    private let orderListRepository: OrderListRepository
    private let orderListUseCase: OrderListUseCase
    private let orderStatusUseCase: OrderStatusUseCase

    init() {
        let repository = MockOrderListRepository()
        self.orderListRepository = repository
        self.orderListUseCase = OrderListUseCaseImpl(repository: repository)
        self.orderStatusUseCase = OrderStatusUseCaseImpl(repository: repository)
    }

    func makeOrderListViewModel() -> OrderListViewModel {
        OrderListViewModel(useCase: orderListUseCase)
    }

    func makeOrderDetailsViewModel(order: Order) -> OrderDetailsViewModel {
        OrderDetailsViewModel(order: order, useCase: orderStatusUseCase)
    }
}
