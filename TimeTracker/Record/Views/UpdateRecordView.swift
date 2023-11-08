import SwiftUI

struct UpdateRecordView: View {
    @StateObject var state: UpdateRecordViewState

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("設定項目") {
                    HStack {
                        TextTitle("カテゴリ", width: 80)
                        Picker("", selection: $state.selectedCategoryId) {
                            ForEach(state.categories) {
                                Text($0.name).tag($0.id)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: state.selectedCategoryId) {
                            state.onCategoryChanged($0)
                        }
                    }

                    HStack {
                        TextTitle("アクティビティ", width: 80)
                        Picker("", selection: $state.selectedActivityId) {
                            ForEach(state.filteredActivities) {
                                Text($0.name).tag($0.id)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    SearchRecordDateView(state: .init(
                        "開始",
                        state.selectedStartDatetime,
                        state.onStartDateChanged
                    ))

                    HStack {
                        TextTitle("終了", width: 80)
                        if state.selectedEndDatetime == nil {
                            TextBorderedTitle(
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
                            Text(state.isEmptyEndDate ? "選択する" : "未選択にする")
                        }
                    }
                    if !state.isEmptyEndDate {
                        SearchRecordDateView(state: .init(
                            "",
                            state.selectedPickerEndDatetime,
                            state.onEndDateChanged
                        ))
                    }

                    HStack(alignment: .top) {
                        TextTitle("メモ", width: 80)
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
            .navigationTitle("記録の編集")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
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
