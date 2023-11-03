import SwiftUI
import TimeTrackerAPI

struct SearchRecordView: View {
    @Binding var categories: [CategoryData]
    @Binding var activities: [ActivityData]

    @Binding var selectedCategories: Set<UUID>
    @Binding var selectedActivities: Set<UUID>
    @Binding var selectedStartDatetime: Date
    @Binding var selectedEndDatetime: Date
    @Binding var sortType: RecordDataSortType

    var body: some View {
        Section("検索") {
            SearchRecordCategoryView(
                categories: $categories,
                selectedCategories: $selectedCategories
            )
            SearchRecordActivityView(
                activities: $activities,
                selectedActivities: $selectedActivities
            )
            SearchRecordDateView(
                selectedDatetime: $selectedStartDatetime,
                title: "開始"
            )
            SearchRecordDateView(
                selectedDatetime: $selectedEndDatetime,
                title: "終了"
            )
            SearchRecordSortView(sortType: $sortType)
        }
    }
}

struct SearchRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordView(
            categories: .constant([]),
            activities: .constant([]),
            selectedCategories: .constant([]),
            selectedActivities: .constant([]),
            selectedStartDatetime: .constant(Date()),
            selectedEndDatetime: .constant(Date()),
            sortType: .constant(.time)
        )
    }
}
