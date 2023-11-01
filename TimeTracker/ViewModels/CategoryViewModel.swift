import SwiftUI
import TimeTrackerAPI

class CategoryViewModel: ObservableObject {
    @Published var categories: [CategoryData] = []

    let defaultId: UUID = CategoryService.defaultId
    private var service: CategoryService? { DatabaseServiceManager.shared.category }
    var count: Int = 0

    @MainActor
    func fetch() async throws {
        guard let service = service else { return }
        categories = try await service.fetch()
        count = categories.count
    }

    @MainActor
    func create(
        id: UUID? = nil,
        name: String,
        color: String
    ) async throws {
        guard let service = service else { return }
        guard
            let new = try await service.create(
                id: id,
                name: name,
                color: color
            )
        else { return }
        categories.append(new)
        count += 1
    }

    @MainActor
    func update(
        id: UUID,
        name: String,
        color: String
    ) async throws {
        guard let service = service else { return }
        let updated = try await service.update(
            id: id,
            name: name,
            color: color
        )
        guard let i = categories.firstIndex(where: { $0.id == id }) else { return }
        categories[i] = updated
    }

    @MainActor
    func delete(id: UUID) async throws {
        guard let i = categories.firstIndex(where: { $0.id == id }) else { return }
        try await delete(at: IndexSet([i]))
    }

    @MainActor
    func delete(at offsets: IndexSet) async throws {
        guard let service = service else { return }
        for i in offsets {
            try await service.delete(id: categories[i].id)
        }
        categories.remove(atOffsets: offsets)
        try await service.updateOrder(ids: categories.map { $0.id })
        try await fetch()
    }

    @MainActor
    func move(from source: IndexSet, to destination: Int) async throws {
        guard let service = service else { return }
        categories.move(fromOffsets: source, toOffset: destination)
        try await service.updateOrder(ids: categories.map { $0.id })
        try await fetch()
    }
}
