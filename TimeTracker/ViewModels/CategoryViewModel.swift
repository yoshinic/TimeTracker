import SwiftUI
import TimeTrackerAPI

class CategoryViewModel: ObservableObject {
    @Published var categories: [CategoryData] = []

    let defaultId: UUID = CategoryService.defaultId
    private let service: CategoryService? = DatabaseServiceManager.shared.category
    var count: Int = 0

    func fetch() {
        guard let service = service else { return }
        Task.detached { @MainActor in
            self.categories = try await service.fetch()
            self.count = self.categories.count
        }
    }

    func create(
        id: UUID? = nil,
        name: String,
        color: String
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            guard
                let new = try await service.create(
                    id: id,
                    name: name,
                    color: color
                )
            else { return }
            self.categories.append(new)
            self.count += 1
        }
    }

    func update(
        id: UUID,
        name: String,
        color: String
    ) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            try await service.update(
                id: id,
                name: name,
                color: color
            )
        }
    }

    func delete(id: UUID) {
        guard
            let i = self.categories.firstIndex(where: { $0.id == id })
        else { return }
        delete(at: IndexSet([i]))
    }

    func delete(at offsets: IndexSet) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            for i in offsets {
                try await service.delete(id: self.categories[i].id)
            }
            self.categories.remove(atOffsets: offsets)
            try await service.updateOrder(ids: self.categories.map { $0.id })
            self.fetch()
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        guard let service = service else { return }
        Task.detached { @MainActor in
            self.categories.move(fromOffsets: source, toOffset: destination)
            try await service.updateOrder(ids: self.categories.map { $0.id })
            self.fetch()
        }
    }
}
