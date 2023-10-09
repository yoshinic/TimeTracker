import SwiftUI

struct RecordListView: View {
    @StateObject private var viewModel = RecordViewModel()
    @State private var isGraphView = false

    var body: some View {
        VStack {
            if isGraphView {
                RecordGraphView(records: viewModel.records)
            } else {
                List(viewModel.records) { record in
                    // Record の詳細表示など
                    Text(record.activity.name)
                }
            }
            Toggle("Switch to \(isGraphView ? "List" : "Graph") View", isOn: $isGraphView)
        }
        .navigationTitle("Records")
        .onAppear {
            Task {
                viewModel.fetchRecords()
            }
        }
    }
}
