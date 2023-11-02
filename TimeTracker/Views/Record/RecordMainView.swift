import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var isEditMode: Bool = false
    @State private var showListView: Bool = true
    @State private var categories: [CategoryData] = []
    @State private var activities: [ActivityData] = []

    @State private var selectedCategories: Set<CategoryData> = []
    @State private var selectedActivities: Set<ActivityData> = []
    @State private var selectedStartDatetime: Date = .init()
    @State private var selectedEndDatetime: Date = .init()
    @State private var sortType: RecordDataSortType = .time

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
            .onChange(of: sortType) { new in
                recordViewModel.sortType = new
                recordViewModel.sort()
            }
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
                try await recordViewModel.fetch()
            }
        }
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
