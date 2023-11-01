import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var showListView: Bool = true
    @State private var categories: [CategoryData] = []
    @State private var activities: [UUID: [ActivityData]] = [:]

    var body: some View {
        Form {
            SearchRecordView(
                categories: $categories,
                activities: $activities,
                records: $recordViewModel.records
            )
            if showListView {
                RecordListView(
                    recordViewModel: recordViewModel,
                    categories: $categories,
                    activities: $activities,
                    defaultCategoryId: categoryViewModel.defaultId
                )
            } else {
                RecordGraphView(records: $recordViewModel.records)
            }
        }
        .listStyle(InsetGroupedListStyle())
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
