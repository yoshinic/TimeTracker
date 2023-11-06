import SwiftUI

struct SearchRecordView: View {
    @StateObject var state: SearchRecordViewState

    var body: some View {
        Section("検索") {
            SearchRecordCategoryView(state: .init(
                state.selectedCategories,
                state.onCategoriesChanged
            ))
            SearchRecordActivityView(state: .init(
                state.selectedActivities,
                state.onActivitiesChanged
            ))
            SearchRecordDateView(state: .init(
                "開始",
                state.selectedStartDatetime,
                state.onStartDateChanged
            ))

            SearchRecordDateView(state: .init(
                "終了",
                state.selectedEndDatetime,
                state.onEndDateChanged
            ))
            SearchRecordSortView(state: .init(
                state.selectedSortType,
                state.onSortTypeChanged
            ))
        }
    }
}

struct SearchRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordView(state: .init())
    }
}
