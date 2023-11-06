import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordActivityViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []
    @Published private(set) var activities: [UUID: [ActivityData]] = [:]
    @Published var selectedActivities: Set<ActivityData>
    @Published private(set) var filteredActivities: [ActivityData] = []

    let flattedActivities: [ActivityData]
    let onActivitiesChanged: (@MainActor (Set<ActivityData>) -> Void)?

    private var cancellables: Set<AnyCancellable> = []

    init(
        _ selectedActivities: Set<ActivityData> = [],
        _ onActivitiesChanged: (@MainActor (Set<ActivityData>) -> Void)? = nil
    ) {
        self.selectedActivities = selectedActivities
        self.onActivitiesChanged = onActivitiesChanged
        self.flattedActivities = ActivityStore.shared.values.values.flatMap { $0 }

        CategoryStore.shared.$values.assign(to: &$categories)
        ActivityStore.shared.$values.assign(to: &$activities)

        $selectedActivities
            .map { selected in
                self.flattedActivities.filter { selected.contains($0) }
            }
            .assign(to: &$filteredActivities)

        if let onActivitiesChanged {
            $selectedActivities
                .receive(on: DispatchQueue.main)
                .sink { onActivitiesChanged($0) }
                .store(in: &cancellables)
        }
    }
}
