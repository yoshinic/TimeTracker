import Combine
import TimeTrackerAPI

@MainActor
class RecordGraphViewState: ObservableObject {
    @Published var records: [RecordData] = []

    init() {
        RecordStore.shared.$values.assign(to: &$records)
    }
}
