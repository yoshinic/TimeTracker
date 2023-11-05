import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordActivityViewState: ObservableObject {
    @Published private(set) var activities: [UUID: [ActivityData]]
    @Published var selectedActivities: Set<ActivityData>

    let flattedActivities: [ActivityData]

    var filteredActivities: [ActivityData] {
        flattedActivities.filter { selectedActivities.contains($0) }
    }

    init(_ selectedActivities: Set<ActivityData>) {
        self.activities = ActivityStore.shared.values
        self.selectedActivities = selectedActivities
        flattedActivities = ActivityStore.shared.values.values.flatMap { $0 }
    }
}

@MainActor
class SearchRecordActivitySelectionViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]
    @Published private(set) var activities: [UUID: [ActivityData]]
    @Published var selectedActivities: Set<ActivityData>

    init(_ selectedActivities: Set<ActivityData>) {
        self.categories = CategoryStore.shared.values
        self.activities = ActivityStore.shared.values
        self.selectedActivities = selectedActivities
    }
}
