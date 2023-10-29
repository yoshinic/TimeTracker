import SwiftUI
import TimeTrackerAPI

class ActivityViewModel: ObservableObject {
    @Published var activities: [ActivityData] = []

    let defaultId: UUID = ActivityService.defaultId
    private let service: ActivityService? = DatabaseServiceManager.shared.activity
    var count: Int = 0

    @MainActor
    func fetch(
        id: UUID? = nil,
        categoryId: UUID? = nil,
        name: String? = nil
    ) async throws {
        guard let service = service else { return }
        activities = try await service.fetch(
            id: id, categoryId: categoryId, name: name
        )
        count = activities.count
    }

    @MainActor
    func create(
        id: UUID? = nil,
        categoryId: UUID,
        name: String,
        color: String
    ) async throws {
        guard let service = service else { return }
        let new = try await service.create(
            id: id,
            categoryId: categoryId,
            name: name,
            color: color
        )
        activities.append(new)
        count += 1
    }

    @MainActor
    func update(
        id: UUID,
        categoryId: UUID,
        name: String,
        color: String
    ) async throws {
        guard let service = service else { return }
        let updated = try await service.update(
            id: id,
            categoryId: categoryId,
            name: name,
            color: color
        )
        guard let i = activities.firstIndex(where: { $0.id == id }) else { return }
        activities[i] = updated
    }

    @MainActor
    func delete(id: UUID) async throws {
        guard let i = activities.firstIndex(where: { $0.id == id }) else { return }
        try await delete(at: IndexSet([i]))
    }

    @MainActor
    func delete(at offsets: IndexSet) async throws {
        guard let service = service else { return }

        for i in offsets {
            try await service.delete(id: activities[i].id)
        }
        activities.remove(atOffsets: offsets)
        try await service.updateOrder(ids: activities.map { $0.id })
        try await fetch()
    }

    @MainActor
    func move(from source: IndexSet, to destination: Int) async throws {
        guard let service = service else { return }

        activities.move(fromOffsets: source, toOffset: destination)
        try await service.updateOrder(ids: activities.map { $0.id })
        try await fetch()
    }
}
