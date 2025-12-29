# Delivery Tracking iOS Demo App

## Architecture
- A SwiftUI app built in clean architecture and MVVM. Modules are seperated using SPM Package

### Overall Structure
- **Domain**: Business models (`Order`, `OrderStatus`) and use case interfaces (`OrderListUseCase`, `OrderStatusUseCase`).  
- **Data**: Repository implementations (`MockOrderListRepository`) that simulate fetching and updating orders.  
- **Presentation**: SwiftUI Views and ViewModels (`OrderListView`, `OrderDetailsView`).

### Data & State Flow
1. `OrderListViewModel` fetches orders from `OrderListUseCase`.
2. Orders are wrapped in an explicit **state enum**:
   `idle | loading | empty | loaded | error`.
3. `OrderDetailsViewModel` subscribes to `observeOrderStatus(orderId:)` for status simulation.
4. Filtering and presentation logic is handled at the ViewModel level to decouple UI from domain models.

### Why This Approach
- Clear separation of concerns (domain, data, presentation).  
- Testability through dependency injection.  
- Thread safety with `@MainActor`.  
- SwiftUI + MVVM supports reactive UI state and AsyncStreams for status updates.

## Functionality

### OrderListView
- Displays a list of orders.  
- Segmented picker filters by status: Pending, In Transit, Delivered.  

### OrderDetailsView
- Simulates order status progression over time. (with 2 seconds delay)
- Local updates do not affect other orders unless persisted.  
- Returning to OrderListView reflects current persisted state. (Using In memory for persisting)

---

## Unit Testing

### Repository Tests
- Verify `testFetchOrdersReturnsAllOrders` returns all orders.  
- Verify `testUpdateOrderStatusChangesStatus` only updates the intended order.  

## Trade-offs
- Simplified mock repository for deterministic testing.  
- Only one repository implementation; UI tests planned.  
- Fixed delays in simulation for testability.

**Next Refactors**
- Complete UI layout.
- Full UI tests and snapshot tests.  
- Real networking layer with persistence.  
- Enhanced simulation logic possibly using mock json file.

## Future Improvements
- Offline caching and synchronization. 

**Thought Exercise**
- Inject map SDK interface.  
- AsyncStream or Combine to simulate live GPS feed.

## Note on Scope & Timebox
This project was implemented as a **take-home assessment without spending more than 3-4 hour time**.  

- The focus was on **clean architecture, modular code structure, and maintainable design** rather than detailed UI design.  
- SwiftUI layout is functional and responsive, but **visual polish and complex animations were deprioritized** to ensure correct implementation of:  
  - MVVM structure  
  - Domain vs UI separation  
  - Testable state handling  
  - Dependency injection and AsyncStream simulations  

> The architecture is designed for flexibility: new features, additional order states, or backend integration can be added **without major refactoring**, and the ViewModels remain testable and isolated from domain changes.

---

  ## Architecture Diagram
```text
Presentation
(SwiftUI + MVVM)
OrderListView
OrderDetailsView

Domain
UseCases + Entities
Order, OrderStatus

Data
MockOrderListRepository
