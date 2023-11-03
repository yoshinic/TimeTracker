import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var isEditMode: Bool = false
    @State private var showListView: Bool = true

    @State private var selectedCategories: Set<UUID> = []
    @State private var selectedActivities: Set<UUID> = []
    @State private var selectedStartDatetime: Date
    @State private var selectedEndDatetime: Date
    @State private var sortType: RecordDataSortType = .time

    init(
        categoryViewModel: CategoryViewModel,
        activityViewModel: ActivityViewModel,
        recordViewModel: RecordViewModel
    ) {
        self.categoryViewModel = categoryViewModel
        self.activityViewModel = activityViewModel
        self.recordViewModel = recordViewModel

        let startDate = Calendar.current.date(
            byAdding: .day,
            value: -7,
            to: .init()
        ) ?? .init()
        self._selectedStartDatetime = .init(initialValue: startDate)
        self._selectedEndDatetime = .init(initialValue: .init())
    }

    var body: some View {
        Form {
            SearchRecordView(
                categories: $categoryViewModel.categories,
                activities: $activityViewModel.activities,
                selectedCategories: $selectedCategories,
                selectedActivities: $selectedActivities,
                selectedStartDatetime: $selectedStartDatetime,
                selectedEndDatetime: $selectedEndDatetime,
                sortType: $sortType
            )
            .onChange(of: selectedCategories) { _ in Task { try await fetch() }}
            .onChange(of: selectedActivities) { _ in Task { try await fetch() }}
            .onChange(of: selectedStartDatetime) { _ in Task { try await fetch() }}
            .onChange(of: selectedEndDatetime) { _ in Task { try await fetch() }}
            .onChange(of: sortType) { _ in recordViewModel.sort() }

            if showListView {
                RecordListView(
                    recordViewModel: recordViewModel,
                    isEditMode: $isEditMode,
                    categories: $categoryViewModel.categories,
                    activities: $activityViewModel.activities,
                    defaultCategoryId: categoryViewModel.defaultId
                )
            } else {
                RecordGraphView(records: $recordViewModel.records)
            }
        }
        .environment(\.editMode, isEditMode ? .constant(.active) : .constant(.inactive))
        .navigationBarItems(trailing: Button {
            isEditMode.toggle()
        } label: {
            Text(isEditMode ? "Done" : "Edit")
        })
        .onAppear {
            Task {
                try await categoryViewModel.fetch()
                try await activityViewModel.fetch()
                try await fetch()
            }
        }
    }

    private func fetch() async throws {
        try await recordViewModel.fetch(
            categories: selectedCategories,
            activities: selectedActivities,
            from: selectedStartDatetime,
            to: selectedEndDatetime
        )
        recordViewModel.sort()
    }
}

struct RecordMainView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMainView(
            categoryViewModel: .init(),
            activityViewModel: .init(),
            recordViewModel: .init()
        )
    }
}
