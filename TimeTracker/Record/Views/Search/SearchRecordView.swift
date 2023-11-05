import SwiftUI
import TimeTrackerAPI

struct SearchRecordView: View {
    @StateObject var state: SearchRecordViewState

    var body: some View {
        Section("検索") {
            SearchRecordCategoryView(state: .init(state.selectedCategories))
            SearchRecordActivityView(state: .init(state.selectedActivities))
            SearchRecordDateView(state: .init("開始", state.selectedStartDatetime))
            SearchRecordDateView(state: .init("終了", state.selectedEndDatetime))
            SearchRecordSortView(state: .init(.time))
        }
    }
}

struct SearchRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordView(
            state: .init(
                selectedCategories: [],
                selectedActivities: [],
                selectedStartDatetime: .init(),
                selectedSortType: .time
            )
        )
    }
}
