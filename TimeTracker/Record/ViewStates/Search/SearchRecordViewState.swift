import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordViewState: ObservableObject {
    @Published var selectedCategories: Set<CategoryData>
    @Published var selectedActivities: Set<ActivityData>
    @Published var selectedStartDatetime: Date
    @Published var selectedEndDatetime: Date?
    @Published var selectedSortType: RecordDataSortType

    init(
        selectedCategories: Set<CategoryData>,
        selectedActivities: Set<ActivityData>,
        selectedStartDatetime: Date,
        selectedEndDatetime: Date? = nil,
        selectedSortType: RecordDataSortType
    ) {
        self.selectedCategories = selectedCategories
        self.selectedActivities = selectedActivities
        self.selectedStartDatetime = selectedStartDatetime
        self.selectedEndDatetime = selectedEndDatetime
        self.selectedSortType = selectedSortType
    }
}
