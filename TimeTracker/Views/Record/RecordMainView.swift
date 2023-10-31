import SwiftUI
import TimeTrackerAPI

struct RecordMainView: View {
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State var showListView: Bool = true

    var body: some View {
        Form {
            SearchRecordView(
                activities: $activityViewModel.activities,
                records: $recordViewModel.records,
                fetchRecords: recordViewModel.fetch
            )
            if showListView {
                RecordListView(records: $recordViewModel.records)
            } else {
                RecordGraphView(records: $recordViewModel.records)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            Task { 
                try await activityViewModel.fetch()
                try await recordViewModel.fetch()
            }
        }
    }
}

struct RecordMainView_Previews: PreviewProvider {
    static var previews: some View {
        RecordMainView(
            activityViewModel: .init(),
            recordViewModel: .init()
        )
    }
}
