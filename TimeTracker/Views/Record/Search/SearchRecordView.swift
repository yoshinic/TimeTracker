import SwiftUI
import TimeTrackerAPI

struct SearchRecordView: View {
    @State private var showCategory = false
    @State private var showActivity = false

    @State private var selectedCategories: [CategoryData] = []
    @State private var selectedActivities: [ActivityData] = []

    @State private var selectedStartDatetime: Date = .init()
    @State private var selectedEndDatetime: Date = .init()

    @Binding var categories: [CategoryData]
    @Binding var activities: [UUID: [ActivityData]]
    @Binding var sortType: RecordDataSortType

    var body: some View {
        Section("検索") {
            SearchRecordMasterView(
                categories: $categories,
                activities: $activities
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
            activities: .constant([:]),
            sortType: .constant(.time)
        )
    }
}
