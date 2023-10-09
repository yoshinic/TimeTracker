import SwiftUI
import TimeTrackerAPI

class RecordViewModel: ObservableObject {
    @Published var records: [RecordData] = []
    private let service = DefaultServiceFactory.shared.record

    func fetchRecords() {
        Task.detached { @MainActor in
            self.records = try await self.service.fetch()
        }
    }

    // その他のCRUD操作もこちらに追加...
}
