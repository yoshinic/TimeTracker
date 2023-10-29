import SwiftUI
import TimeTrackerAPI

class RecordViewModel: ObservableObject {
    @Published var records: [RecordData] = []

    private let service: RecordService? = DatabaseServiceManager.shared.record
    var count: Int = 0

    func fetch(
        recordId: UUID? = nil,
        nullEnd: Bool = false,
        from: Date? = nil,
        to: Date? = nil,
        categoryIds: [UUID] = [],
        activityIds: [UUID] = []
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            self.records = try await service.fetch(
                recordId: recordId,
                nullEnd: nullEnd,
                from: from,
                to: to,
                categoryIds: categoryIds,
                activityIds: activityIds
            )
            self.count = self.records.count
        }
    }

    func create(
        id: UUID? = nil,
        activityId: UUID? = nil,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        note: String = ""
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            let new = try await service.create(
                activityId: activityId,
                startedAt: startedAt,
                endedAt: endedAt,
                note: note
            )
            self.records.append(new)
            self.count += 1
        }
    }

    func update(
        id: UUID,
        activityId: UUID,
        startedAt: Date,
        endedAt: Date?,
        note: String
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            try await service.update(
                recordId: id,
                activityId: activityId,
                startedAt: startedAt,
                endedAt: endedAt,
                note: note
            )
        }
    }

    func delete(id: UUID) {
        guard
            let i = self.records.firstIndex(where: { $0.id == id })
        else { return }
        delete(at: IndexSet([i]))
    }

    func delete(at offsets: IndexSet) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            for i in offsets {
                try await service.delete(recordId: self.records[i].id)
            }
            self.records.remove(atOffsets: offsets)
            self.fetch()
        }
    }
}
