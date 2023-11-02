import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var isEditMode: Bool = false
    @State private var showListView: Bool = true
    @State private var categories: [CategoryData] = []
    @State private var activities: [UUID: [ActivityData]] = [:]
    @State private var sortType: RecordDataSortType = .time

    var body: some View {
        Form {
            SearchRecordView(
                categories: $categories,
                activities: $activities,
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
                    categories: $categories,
                    activities: $activities,
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
                categories = categoryViewModel.categories

                try await activityViewModel.fetch()
                activities = activityViewModel.activities.toUUIDDic

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
