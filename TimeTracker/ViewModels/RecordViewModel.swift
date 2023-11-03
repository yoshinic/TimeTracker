import SwiftUI
import TimeTrackerAPI

class RecordViewModel: ObservableObject {
    @Published var records: [RecordData] = []
    @Published var sortType: RecordDataSortType = .time

    private var service: RecordService?  { DatabaseServiceManager.shared.record }
    var count: Int = 0

    @MainActor
    func fetch(
        id: UUID? = nil,
        categories: Set<UUID> = [],
        activities: Set<UUID> = [],
        from: Date? = nil,
        to: Date? = nil
    ) async throws {
        guard let service = service else { return }
        records = try await service.fetch(
            id: id,
            categories: categories,
            activities: activities,
            from: from,
            to: to
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
            id: id,
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
            records.sort(by: kindSort)
        case .time:
            records.sort(by: timeSort)
        }
    }

    private func kindSort(_ lhs: RecordData, _ rhs: RecordData) -> Bool {
        if let a0 = lhs.activity, let a1 = rhs.activity {
            if a0.category.id == a1.category.id {
                a0.order < a1.order
            } else {
                a0.category.order < a1.category.order
            }
        } else if lhs.activity == nil, rhs.activity == nil {
            timeSort(lhs, rhs)
        } else {
            rhs.activity == nil
        }
    }

    private func timeSort(_ lhs: RecordData, _ rhs: RecordData) -> Bool {
        if lhs.endedAt == nil, rhs.endedAt == nil {
            lhs.startedAt > rhs.startedAt
        } else if let d0 = lhs.endedAt, let d1 = rhs.endedAt {
            d0 == d1 ? lhs.startedAt > rhs.startedAt : d0 > d1
        } else {
            lhs.endedAt == nil
        }
    }
}

enum RecordDataSortType {
    case kind
    case time
}
