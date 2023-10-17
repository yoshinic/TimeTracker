import SwiftUI
import TimeTrackerAPI

class RecordViewModel: ObservableObject {
    @Published var records: [RecordData] = []

    private let service = DefaultServiceFactory.shared.record

    var count: Int = 0

    func fetchRecords(
        recordId: UUID? = nil,
        nullEnd: Bool = false,
        from: Date? = nil,
        to: Date? = nil,
        activityIds: [UUID] = [],
        activityNames: [String] = [],
        activityColors: [String] = []
    ) {
        Task.detached { @MainActor in
            self.records = try await self.service.fetch(
                recordId: recordId,
                nullEnd: nullEnd,
                from: from,
                to: to,
                activityIds: activityIds,
                activityNames: activityNames,
                activityColors: activityColors
            )
            self.count = self.records.count
        }
    }

    func addRecord(
        id: UUID? = nil,
        activityId: UUID? = nil,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        note: String = ""
    ) {
        Task.detached { @MainActor in
            let newRecord = try await self.service.create(
                activityId: activityId,
                startedAt: startedAt,
                endedAt: endedAt,
                note: note
            )
            self.records.append(newRecord)
            self.count += 1
        }
    }

    func updateRecord(
        id: UUID,
        activityId: UUID,
        startedAt: Date,
        endedAt: Date?,
        note: String
    ) {
        Task.detached { @MainActor in
            try await self.service.update(
                recordId: id,
                activityId: activityId,
                startedAt: startedAt,
                endedAt: endedAt,
                note: note
            )
        }
    }

    func deleteRecord(id: UUID) {
        guard
            let i = self.records.firstIndex(where: { $0.id == id })
        else { return }
        deleteRecords(at: IndexSet([i]))
    }

    func deleteRecords(at offsets: IndexSet) {
        Task.detached { @MainActor in
            for i in offsets {
                try await self.service.delete(recordId: self.records[i].id)
            }
            self.records.remove(atOffsets: offsets)
            self.fetchRecords()
        }
    }
}
