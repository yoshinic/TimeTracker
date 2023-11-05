import SwiftUI
import TimeTrackerAPI

@MainActor
class ActivityListViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]
    @Published private(set) var activities: [UUID: [ActivityData]]
    @Published var isModalPresented: Bool = false
    @Published private(set) var isEditMode: Bool = false

    init() {
        self.categories = CategoryStore.shared.values
        self.activities = ActivityStore.shared.values
    }

    func onTapAddButton() {
        isModalPresented = true
    }

    func onTapEditButton() {
        isEditMode.toggle()
    }
}

@MainActor
class ActivityListDetailViewState: ObservableObject {
    @Published private(set) var activities: [ActivityData]

    let categoryId: UUID

    init(activities: [ActivityData], categoryId: UUID) {
        self.activities = activities
        self.categoryId = categoryId
    }

    func onDelete(at idx: IndexSet) async {
        do {
            try await ActivityStore.shared.delete(
                at: idx,
                categoryId: categoryId
            )
        } catch {
            print(error)
        }
    }

    func onMove(from source: IndexSet, to destination: Int) async {
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
}
