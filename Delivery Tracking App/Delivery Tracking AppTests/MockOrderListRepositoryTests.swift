//
//  MockOrderListRepositoryTests.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import XCTest
@testable import Delivery_Tracking_App
import Domain
import Data

@MainActor
final class MockOrderListRepositoryTests: XCTestCase {

    var repository: MockOrderListRepository!

    override func setUp() async throws {
        repository = MockOrderListRepository()
    }

    override func tearDown() async throws {
        repository = nil
    }

    func testFetchOrdersReturnsAllOrders() async throws {
        let orders = try await repository.fetchOrders()
        XCTAssertEqual(orders.count, 7)
        XCTAssertEqual(orders[0].title, "Order #001")
        XCTAssertEqual(orders[6].status, .delivered)
    }

    func testUpdateOrderStatusChangesStatus() async throws {
        let order = try await repository.fetchOrders().first!
        XCTAssertEqual(order.status, .pending)

        repository.updateOrderStatus(orderId: order.id, newStatus: .delivered)

        let updatedOrder = try await repository.fetchOrders().first!
        XCTAssertEqual(updatedOrder.status, .delivered)
    }
    
}
