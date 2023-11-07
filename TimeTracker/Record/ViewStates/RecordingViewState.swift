import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordingViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []
    @Published private(set) var activities: [UUID: [ActivityData]] = [:]
    @Published private(set) var filteredActivities: [ActivityData] = []

    @Published var selectedCategoryId: UUID = CategoryStore.shared.dummy.id
    @Published var selectedActivityId: UUID = ActivityStore.shared.dummy.id

    private let dummyCategoryId: UUID = CategoryStore.shared.dummy.id
    let dummyActivityId: UUID = ActivityStore.shared.dummy.id

    init() {
        CategoryStore.shared.$values.assign(to: &$categories)
        ActivityStore.shared.$values.assign(to: &$activities)

        $selectedCategoryId
            .map { [weak self] in
                if $0 == self?.dummyCategoryId {
                    self?.activities.values.flatMap { $0 } ?? []
                } else {
                    self?.activities[$0] ?? []
                }
            }
            .assign(to: &$filteredActivities)

        self.selectedCategoryId = categories.first?.id ?? dummyCategoryId
        self.selectedActivityId = filteredActivities.first?.id ?? dummyActivityId
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
