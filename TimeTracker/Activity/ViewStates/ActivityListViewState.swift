import SwiftUI
import TimeTrackerAPI

@MainActor
class ActivityListViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []
    @Published private(set) var activities: [UUID: [ActivityData]] = [:]
    @Published var isModalPresented: Bool = false
    @Published private(set) var isEditMode: Bool = false

    init() {
        CategoryStore.shared.$values.assign(to: &$categories)
        ActivityStore.shared.$values.assign(to: &$activities)
    }

    func onDelete(
        at idx: IndexSet,
        _ categoryId: UUID
    ) async {
        do {
            try await ActivityStore.shared.delete(
                at: idx,
                categoryId: categoryId
            )
        } catch {
            print(error)
        }
    }

    func onMove(
        from source: IndexSet,
        to destination: Int,
        _ categoryId: UUID
    ) async {
        do {
            try await ActivityStore.shared.move(
                from: source,
                to: destination,
                categoryId: categoryId
            )
        } catch {
            print(error)
        }
    }

    func onTapAddButton() {
        isModalPresented = true
    }

    func onTapEditButton() {
        isEditMode.toggle()
    }
}
