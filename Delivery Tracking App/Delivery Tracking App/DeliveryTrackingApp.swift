//
//  DeliveryTrackingApp.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import SwiftUI

@main
struct DeliveryTrackingApp: App {
    private let appDIContainer = AppDIContainer()
    var body: some Scene {
        WindowGroup {
            OrderListView(
                appDiContainer: appDIContainer,
                viewModel: appDIContainer.makeOrderListViewModel()
            )
        }
    }
}
