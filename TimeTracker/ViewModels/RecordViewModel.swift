import SwiftUI
import TimeTrackerAPI

class RecordViewModel: ObservableObject {
    @Published var records: [RecordData] = []
    @Published var sortType: RecordDataSortType = .time

    private var service: RecordService?  { DatabaseServiceManager.shared.record }
    var count: Int = 0

    @MainActor
    func fetch(
        recordId: UUID? = nil,
        nullEnd: Bool = false,
        from: Date? = nil,
        to: Date? = nil,
        categoryIds: [UUID] = [],
        activityIds: [UUID] = []
    ) async throws {
        guard let service = service else { return }
        records = try await service.fetch(
            recordId: recordId,
            nullEnd: nullEnd,
            from: from,
            to: to,
            categoryIds: categoryIds,
            activityIds: activityIds
        )
        sort()
        count = records.count
    }

    @MainActor
    func create(
        id: UUID? = nil,
        activityId: UUID? = nil,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        note: String = ""
    ) async throws {
        guard let service = service else { return }
        let new = try await service.create(
            activityId: activityId,
            startedAt: startedAt,
            endedAt: endedAt,
            note: note
        )
        records.append(new)
        sort()
        
        count += 1
    }

    @MainActor
    func update(
        id: UUID,
        activityId: UUID?,
        startedAt: Date,
        endedAt: Date?,
        note: String
    ) async throws {
        guard let service = service else { return  }
        let updated = try await service.update(
            recordId: id,
            activityId: activityId,
            startedAt: startedAt,
            endedAt: endedAt,
            note: note
        )
        guard let i = records.firstIndex(where: { $0.id == id }) else { return }
        records[i] = updated
        sort()
    }

    @MainActor
    func delete(id: UUID) async throws {
        guard let i = records.firstIndex(where: { $0.id == id }) else { return }
        try await delete(at: IndexSet([i]))
    }

    @MainActor
    func delete(at offsets: IndexSet) async throws {
        guard let service = service else { return }
        for i in offsets {
            try await service.delete(id: records[i].id)
        }
        records.remove(atOffsets: offsets)
        try await fetch()
        sort()
    }

    @MainActor
    func sort() {
        switch sortType {
        case .kind:
            return
        case .time:
            records.sort {
                if $0.endedAt == nil, $1.endedAt == nil {
                    $0.startedAt > $1.startedAt
                } else if let d0 = $0.endedAt, let d1 = $1.endedAt {
                    d0 == d1 ? $0.startedAt > $1.startedAt : d0 > d1
                } else {
                    $0.endedAt == nil
                }
            }
        }
    }
}

enum RecordDataSortType {
    case kind
    case time
}
