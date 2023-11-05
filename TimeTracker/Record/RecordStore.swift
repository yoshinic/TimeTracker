import Foundation
import Combine
import TimeTrackerAPI

@MainActor
final class RecordStore {
    static let shared: RecordStore = .init()

    @Published private(set) var values: [RecordData] = []

    private var service: RecordService = DatabaseServiceManager.shared.record

    func fetch(
        id: UUID? = nil,
        categories: Set<UUID> = [],
        activities: Set<UUID> = [],
        from: Date? = nil,
        to: Date? = nil
    ) async throws {
        values = try await service.fetch(
            id: id,
            categories: categories,
            activities: activities,
            from: from,
            to: to
        )
    }

    func create(
        id: UUID? = nil,
        activityId: UUID? = nil,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        note: String = ""
    ) async throws {
        let new = try await service.create(
            activityId: activityId,
            startedAt: startedAt,
            endedAt: endedAt,
            note: note
        )
        values.append(new)
    }

    func update(
        id: UUID,
        activityId: UUID?,
        startedAt: Date,
        endedAt: Date?,
        note: String
    ) async throws {
        let updated = try await service.update(
            id: id,
            activityId: activityId,
            startedAt: startedAt,
            endedAt: endedAt,
            note: note
        )
        guard let i = values.firstIndex(where: { $0.id == id }) else { return }
        values[i] = updated
    }

    func delete(id: UUID) async throws {
        guard let i = values.firstIndex(where: { $0.id == id }) else { return }
        try await delete(at: IndexSet([i]))
    }

    func delete(at offsets: IndexSet) async throws {
        for i in offsets {
            let uuid = values[i].id
            try await service.delete(id: uuid)
        }
        values.remove(atOffsets: offsets)
        try await fetch()
    }

    func sort(
        _ records: inout [RecordData],
        by sortType: RecordDataSortType
    ) {
        switch sortType {
        case .kind:
            records.sort(by: kindSort)
        case .time:
            records.sort(by: timeSort)
        }
    }

    func sorted(
        _ records: [RecordData],
        using sortType: RecordDataSortType
    ) -> [RecordData] {
        switch sortType {
        case .kind:
            records.sorted { kindSort($0, $1) }
        case .time:
            records.sorted { timeSort($0, $1) }
        }
    }

    private func kindSort(_ lhs: RecordData, _ rhs: RecordData) -> Bool {
        if let a0 = lhs.activity, let a1 = rhs.activity {
            if let c0 = a0.category, let c1 = a1.category {
                if c0.id == c1.id {
                    a0.order < a1.order
                } else {
                    c0.order < c1.order
                }
            } else if a0.category == nil, a1.category == nil {
                timeSort(lhs, rhs)
            } else {
                rhs.activity == nil
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
