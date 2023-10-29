import SwiftUI
import TimeTrackerAPI

struct SearchRecordView: View {
    @State private var showCategory = false
    @State private var showActivity = false

    @State private var selectedCategories: [CategoryData] = []
    @State private var selectedActivities: [ActivityData] = []

    @State private var selectedStartDate: Date = .init()
    @State private var selectedStartTime: Date = .init()

    @State private var selectedEndDate: Date = .init()
    @State private var selectedEndTime: Date = .init()

    @Binding var activities: [ActivityData]

    let fetchRecords: (UUID?, Bool, Date?, Date?, [UUID], [UUID]) async throws -> Void

    var body: some View {
        Section("検索") {
            SearchRecordMasterView(masters: activities.toDic)
            SearchRecordDateView(
                selectedDate: $selectedStartDate,
                selectedTime: $selectedStartTime,
                title: "開始"
            )
            SearchRecordDateView(
                selectedDate: $selectedEndDate,
                selectedTime: $selectedEndTime,
                title: "終了"
            )
            SearchRecordSortView()
        }
    }
}

private extension Array where Element == ActivityData {
    var toDic: [CategoryData: [ActivityData]] {
        self.reduce(into: [:]) { res, activity in
            if res[activity.category] == nil {
                res[activity.category] = []
            }
            res[activity.category]!.append(activity)
        }
    }
}

struct SearchRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordView(
            activities: .constant([]),
            fetchRecords: { _, _, _, _, _, _ in }
        )
    }
}
