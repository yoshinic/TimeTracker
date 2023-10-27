import SwiftUI
import TimeTrackerAPI

class ActivityViewModel: ObservableObject {
    @Published var activities: [ActivityData] = []

    let defaultId: UUID = ActivityService.defaultId
    private let service: ActivityService? = DatabaseServiceManager.shared.activity
    var count: Int = 0

    func fetch(
        id: UUID? = nil,
        categoryId: UUID? = nil,
        name: String? = nil
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            self.activities = try await service.fetch(
                id: id, categoryId: categoryId, name: name
            )
            self.count = self.activities.count
        }
    }

    func create(
        id: UUID? = nil,
        categoryId: UUID,
        name: String,
        color: String
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            let new = try await service.create(
                id: id,
                categoryId: categoryId,
                name: name,
                color: color
            )
            self.activities.append(new)
            self.count += 1
        }
    }

    func update(
        id: UUID,
        categoryId: UUID,
        name: String,
        color: String
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            try await service.update(
                id: id,
                categoryId: categoryId,
                name: name,
                color: color
            )
        }
    }

    func delete(id: UUID) {
        guard
            let i = self.activities.firstIndex(where: { $0.id == id })
        else { return }
        delete(at: IndexSet([i]))
    }

    func delete(at offsets: IndexSet) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            for i in offsets {
                try await service.delete(id: self.activities[i].id)
            }
            self.activities.remove(atOffsets: offsets)
            try await service.updateOrder(ids: self.activities.map { $0.id })
            self.fetch()
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            self.activities.move(fromOffsets: source, toOffset: destination)
            try await service.updateOrder(ids: self.activities.map { $0.id })
            self.fetch()
        }
    }
}
