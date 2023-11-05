import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @StateObject var state: RecordMainViewState

    var body: some View {
        Form {
            SearchRecordView(
                state: .init(
                    selectedCategories: state.selectedCategories,
                    selectedActivities: state.selectedActivities,
                    selectedStartDatetime: state.selectedStartDatetime,
                    selectedEndDatetime: state.selectedEndDatetime,
                    selectedSortType: state.selectedSortType
                )
            )
            .onChange(of: state.selectedCategories) { _ in
                Task { await state.onChangeParameter() }
            }
            .onChange(of: state.selectedActivities) { _ in
                Task { await state.onChangeParameter() }
            }
            .onChange(of: state.selectedStartDatetime) { _ in
                Task { await state.onChangeParameter() }
            }
            .onChange(of: state.selectedEndDatetime) { _ in
                Task { await state.onChangeParameter() }
            }
            .onChange(of: state.selectedSortType) { _ in
                state.onChangeSort()
            }
            if state.showListView {
                RecordListView(state: .init(state.records))
            } else {
                RecordGraphView(state: .init(state.records))
            }
        }
        .task { await state.task() }
        .environment(
            \.editMode,
            state.isEditMode ? .constant(.active) : .constant(.inactive)
        )
        .navigationBarItems(trailing:
            Button {
                state.onTapCompleteButton()
            } label: {
                Text(state.isEditMode ? "完了" : "編集")
            })
    }
}

struct RecordMainView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMainView(state: .init())
    }
}
