//
//  Order.swift
//  Domain
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

public struct Order: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public var status: OrderStatus
    
    public init(id: UUID, title: String, status: OrderStatus) {
        self.id = id
        self.title = title
        self.status = status
    }
}

public enum OrderStatus: String, CaseIterable, Sendable {
    case pending = "PENDING"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
}
