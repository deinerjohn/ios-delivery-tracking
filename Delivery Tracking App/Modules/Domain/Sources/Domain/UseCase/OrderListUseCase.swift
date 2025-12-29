//
//  OrderListUseCase.swift
//  Domain
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

public protocol OrderListUseCase {
    func execute() async throws -> [Order]
}

public class OrderListUseCaseImpl: OrderListUseCase {
    
    private let repository: OrderListRepository
    
    public init(repository: OrderListRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Order] {
        return try await repository.fetchOrders()
    }
}
