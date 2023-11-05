import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordingViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]
    @Published private(set) var activities: [UUID: [ActivityData]]

    @Published var selectedCategoryId: UUID
    @Published var selectedActivityId: UUID

    private let dummyCategoryId: UUID
    let dummyActivityId: UUID

    init() {
        self.categories = CategoryStore.shared.values
        self.activities = ActivityStore.shared.values

        self.selectedCategoryId = CategoryStore.shared.dummy.id
        self.selectedActivityId = ActivityStore.shared.dummy.id
        self.dummyCategoryId = CategoryStore.shared.dummy.id
        self.dummyActivityId = ActivityStore.shared.dummy.id
    }

    func onChange(id: UUID) {
        guard id != dummyCategoryId else { return }
        selectedActivityId = activities[id]?.first?.id ?? dummyActivityId
    }

    func onTapStart() async {
        do {
            try await RecordStore.shared.create(activityId: selectedActivityId)
        } catch {
            print(error)
        }
    }
}
