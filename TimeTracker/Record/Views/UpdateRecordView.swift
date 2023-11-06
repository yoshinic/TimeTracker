import SwiftUI

struct UpdateRecordView: View {
    @StateObject var state: UpdateRecordViewState

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("設定項目") {
                    HStack {
                        SearchRecordTitleView("カテゴリ")
                        Picker("", selection: $state.selectedCategoryId) {
                            ForEach(state.categories) {
                                Text($0.name).tag($0.id)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: state.selectedCategoryId) {
                            state.onChange(id: $0)
                        }
                    }

                    HStack {
                        SearchRecordTitleView("アクティビティ")
                        Picker("", selection: $state.selectedActivityId) {
                            ForEach(state.filteredActivities) {
                                Text($0.name).tag($0.id)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    SearchRecordDateView(state: .init(
                        "開始",
                        state.selectedStartDatetime
                    ))
                    SearchRecordEndDateView(state: .init(state.selectedEndDatetime))
                    HStack(alignment: .top) {
                        SearchRecordTitleView("メモ")
                        TextEditor(text: $state.selectedNote)
                            .frame(height: 200)
                    }
                }

                Section {
                    HStack(spacing: 50) {
                        Spacer()
                        Button {
                            Task {
                                await state.onTapUpdateButton()
                                dismiss()
                            }
                        } label: { Text("更新") }
                        Button {
                            dismiss()
                        } label: {
                            Text("戻る")
                        }
                    }
                }
            }
        }
        .navigationBarTitle("記録一覧", displayMode: .inline)
    }
}

private struct SearchRecordEndDateView: View {
    @StateObject var state: SearchRecordEndDateViewState

    var body: some View {
        HStack {
            SearchRecordTitleView("終了")
            if state.selectedEndDatetime == nil {
                TextTitle(
                    "未選択",
                    color: "#FF1111",
                    fontSize: 14,
                    opacity: 0.1,
                    active: false
                )
            }
            Spacer()
            Button {
                state.onTapSelectionOptionButton()
            } label: {
                Text(state.emptyEndDate ? "選択する" : "未選択にする")
            }
        }

        if !state.emptyEndDate {
            SearchRecordDateView(state: .init("", state.selectedPickerEndDatetime))
                .onChange(of: state.selectedPickerEndDatetime) { state.onChange($0) }
        }
    }
}

struct UpdateRecordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateRecordView(state: .init(
            .init(
                id: .init(),
                activity: nil,
                startedAt: .init(),
                endedAt: .init(),
                note: "sample"
            )
        ))
    }
}
