import SwiftUI

struct RecordMainView: View {
    @StateObject var state: RecordMainViewState

    var body: some View {
        Form {
            SearchRecordView(state: .init())
            Section("") {
                HStack {
                    SearchRecordTitleView("表示切替")
                    Spacer()
                    RadioButton(state: .init(
                        selectedIdx: state.showListView ? 0 : 1,
                        titles: state.titles,
                        onTapItem: state.onTapRadioButton
                    ))
                }
            }

            if state.showListView {
                RecordListView(state: .init())
            } else {
                RecordGraphView(state: .init())
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
            }
        )
    }
}

struct RecordMainView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMainView(state: .init())
    }
}
