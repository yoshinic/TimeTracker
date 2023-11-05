import Combine
import TimeTrackerAPI

@MainActor
class RecordGraphViewState: ObservableObject {
    @Published var records: [RecordData]

    init(_ records: [RecordData]) {
        self.records = records
    }
}
