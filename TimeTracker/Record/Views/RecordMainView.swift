import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @StateObject var state: RecordMainViewState

    var body: some View {
        Form {
            SearchRecordView(state: .init())
            if state.showListView {
                RecordListView(state: .init())
            } else {
                RecordGraphView(state: .init(state.records))
            }
        }
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
