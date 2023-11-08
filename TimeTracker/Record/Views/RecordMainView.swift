import SwiftUI

struct RecordMainView: View {
    @StateObject var state: RecordMainViewState

    var body: some View {
        NavigationView {
            Form {
                SearchRecordView(state: .init())
                Section("") {
                    HStack {
                        SearchRecordTitleView("表示切替")
                        Spacer()
                        RadioButton(state: .init(
                            selectedIdx: state.showListView ? 0 : 1,
                            titles: state.titles,
                            color: "#008800",
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
            .navigationTitle("記録一覧")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    state.onTapCompleteButton()
                } label: {
                    Text(state.isEditMode ? "完了" : "編集")
                }
            }
        }
    }
}

struct RecordMainView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMainView(state: .init())
    }
}
