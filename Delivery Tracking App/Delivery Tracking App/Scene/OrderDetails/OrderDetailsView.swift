//
//  OrderDetailsView.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import SwiftUI
import Domain

struct OrderDetailsView: View {

    @StateObject var viewModel: OrderDetailsViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Order Status")
                .font(.title)

            Text(viewModel.status.rawValue.capitalized)
                .font(.headline)
                .foregroundColor(color(for: viewModel.status))

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.startObserving()
        }
        .onDisappear {
            viewModel.stopObserving()
        }
    }
    
    private func color(for status: OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .inTransit: return .blue
        case .delivered: return .green
        }
    }
}
