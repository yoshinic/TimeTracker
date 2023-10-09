import SwiftUI
import TimeTrackerAPI

class ActivityViewModel: ObservableObject {
    @Published var activities: [ActivityData] = []

    private let service = DefaultServiceFactory.shared.activity

    var count: Int = 0

    func fetchActivities() {
        Task.detached { @MainActor in
            self.activities = try await self.service.fetch()
            self.count = self.activities.count
        }
    }

    func addActivity(
        id: UUID? = nil,
        name: String,
        color: String
    ) {
        Task.detached { @MainActor in
            let newActivity = try await self.service.create(id: id, name: name, color: color)
            self.activities.append(newActivity)
            self.count += 1
        }
    }

    func updateActivity(
        id: UUID,
        name: String,
        color: String
    ) {
        Task.detached { @MainActor in
            try await self.service.update(id: id, name: name, color: color)
        }
    }

    func deleteActivity(id: UUID) {
        guard
            let i = self.activities.firstIndex(where: { $0.id == id })
        else { return }
        deleteActivities(at: IndexSet([i]))
    }

    func deleteActivities(at offsets: IndexSet) {
        Task.detached { @MainActor in
            for i in offsets {
                try await self.service.delete(id: self.activities[i].id)
            }
            self.activities.remove(atOffsets: offsets)
            try await self.service.updateOrder(ids: self.activities.map { $0.id })
            self.fetchActivities()
        }
    }

    func moveActivities(from source: IndexSet, to destination: Int) {
        Task.detached { @MainActor in
            self.activities.move(fromOffsets: source, toOffset: destination)
            try await self.service.updateOrder(ids: self.activities.map { $0.id })
            self.fetchActivities()
        }
    }
}
