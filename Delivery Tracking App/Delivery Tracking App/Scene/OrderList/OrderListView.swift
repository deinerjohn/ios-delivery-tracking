//
//  OrderListView.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import SwiftUI
import Domain

struct OrderListView: View {

    let appDiContainer: AppDIContainer
    @StateObject var viewModel: OrderListViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Filter by Status", selection: $viewModel.selectedStatus) {
                    Text("All").tag(OrderStatus?.none)
                    ForEach(OrderStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized).tag(OrderStatus?.some(status))
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Group {
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView()
                    case .empty:
                        Text("No orders found")
                    case .error(let message):
                        VStack {
                            Text(message)
                            Button("Retry") {
                                Task { await viewModel.loadOrders() }
                            }
                        }
                    case .loaded:
                        List(viewModel.filteredOrders) { order in
                            NavigationLink {
                                OrderDetailsView(
                                    viewModel: appDiContainer.makeOrderDetailsViewModel(order: order)
                                )
                            } label: {
                                Text(order.title)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // <-- fill space
            }
            .navigationTitle("Orders")
            .task {
                await viewModel.loadOrders()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()

        case .empty:
            Text("No orders found")

        case .error(let message):
            VStack {
                Text(message)
                Button("Retry") {
                    Task { await viewModel.loadOrders() }
                }
            }

        case .loaded:
            List(viewModel.filteredOrders) { order in
                NavigationLink {
                    OrderDetailsView(
                        viewModel: appDiContainer.makeOrderDetailsViewModel(order: order)
                    )
                } label: {
                    Text(order.title)
                }
            }
        }
    }
}
