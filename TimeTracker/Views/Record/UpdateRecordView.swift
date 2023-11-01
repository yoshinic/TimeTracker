import SwiftUI
import TimeTrackerAPI

struct UpdateRecordView: View {
    @State private var selectedCategory: UUID? = nil
    @State private var selectedActivity: UUID? = nil
    @State private var selectedStartDatetime: Date = .init()
    @State private var selectedEndDatetime: Date? = nil
    @State private var note: String = ""

    @ObservedObject var recordViewModel: RecordViewModel

    @Binding var categories: [CategoryData]
    @Binding var activities: [UUID: [ActivityData]]

    @Environment(\.dismiss) private var dismiss

    let defaultCategoryId: UUID
    let record: RecordData

    var body: some View {
        NavigationView {
            Form {
                Section("設定項目") {
                    HStack {
                        SearchTitleView("カテゴリ")
                        Picker("", selection: $selectedCategory) {
                            ForEach(categories) {
                                CustomText($0.name).tag($0.id as UUID?)
                            }
                        }
                        .onChange(of: selectedCategory) { categoryId in
                            guard let categoryId = categoryId else { return }
                            selectedActivity = activities[categoryId]?.first?.id
                        }
                    }

                    if
                        let selectedCategory = selectedCategory,
                        selectedCategory != defaultCategoryId
                    {
                        HStack {
                            SearchTitleView("アクティビティ")
                            Picker("", selection: $selectedActivity) {
                                ForEach(activities[selectedCategory] ?? []) {
                                    CustomText($0.name).tag($0.id as UUID?)
                                }
                            }
                        }
                    }

                    SearchRecordDateView(
                        selectedDatetime: $selectedStartDatetime,
                        title: "開始"
                    )
                    SearchRecordEndDateView(
                        selectedEndDatetime: $selectedEndDatetime
                    )
                    HStack(alignment: .top) {
                        SearchTitleView("メモ")
                        TextEditor(text: $note)
                            .frame(height: 200)
                    }
                }

                Section {
                    HStack(spacing: 50) {
                        Spacer()
                        Button {
                            Task {
                                try await recordViewModel.update(
                                    id: record.id,
                                    activityId: selectedActivity,
                                    startedAt: selectedStartDatetime,
                                    endedAt: selectedEndDatetime,
                                    note: note
                                )
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
        .onAppear {
            selectedCategory = record.activity?.category.id
            selectedActivity = record.activity?.id
            selectedStartDatetime = record.startedAt
            selectedEndDatetime = record.endedAt
            note = record.note
        }
    }

    func CustomText(_ title: String) -> some View {
        Text(title)
            .padding([.horizontal], 14)
            .padding([.vertical], 5)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .truncationMode(.tail)
            .frame(alignment: .leading)
    }
}

private struct SearchRecordEndDateView: View {
    @Binding var selectedEndDatetime: Date?

    @State private var selectedPickerEndDatetime: Date = .init()
    @State private var emptyEndDate: Bool = false

    var body: some View {
        HStack {
            SearchTitleView("終了")
            if selectedEndDatetime == nil {
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
                emptyEndDate.toggle()
                if emptyEndDate {
                    selectedEndDatetime = nil
                }
            } label: {
                Text(emptyEndDate ? "選択する" : "未選択にする")
            }
        }
        .onAppear {
            if let selectedEndDatetime = selectedEndDatetime {
                selectedPickerEndDatetime = selectedEndDatetime
            }
            emptyEndDate = selectedEndDatetime == nil
        }

        if !emptyEndDate {
            SearchRecordDateView(
                selectedDatetime: $selectedPickerEndDatetime,
                title: ""
            )
            .onChange(of: selectedPickerEndDatetime) { _ in
                selectedEndDatetime = selectedPickerEndDatetime
            }
        }
    }
}

struct UpdateRecordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateRecordView(
            recordViewModel: .init(),
            categories: .constant([]),
            activities: .constant([:]),
            defaultCategoryId: UUID(),
            record: .init(
                id: UUID(),
                activity: nil,
                startedAt: Date(),
                endedAt: Date(),
                note: ""
            )
        )
    }
}
