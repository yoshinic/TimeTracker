import Foundation
import Combine
import TimeTrackerAPI

@MainActor
final class CategoryStore {
    static let shared: CategoryStore = .init()

    @Published private(set) var values: [CategoryData] = []

    private var service: CategoryService = DatabaseServiceManager.shared.category

    let dummy: CategoryData = .init(
        id: .init(),
        name: "未設定",
        color: "#FFFFFF",
        icon: nil,
        order: -1
    )

    func fetch() async throws {
        values = try await service.fetch()
    }

    func create(
        id: UUID? = nil,
        name: String,
        color: String,
        icon: String?
    ) async throws {
        guard
            let new = try await service.create(
                id: id,
                name: name,
                color: color,
                icon: icon
            )
        else { return }
        values.append(new)
    }

    func update(
        id: UUID,
        name: String,
        color: String,
        icon: String?
    ) async throws {
        let updated = try await service.update(
            id: id,
            name: name,
            color: color,
            icon: icon
        )

        guard let i = values.firstIndex(where: { $0.id == id }) else { return }
        values[i] = updated
    }

    func delete(id: UUID) async throws {
        guard let i = values.firstIndex(where: { $0.id == id }) else { return }
        try await delete(at: IndexSet([i]))
    }

    func delete(at offsets: IndexSet) async throws {
        var values = values
        for i in offsets {
            let uuid = values[i].id
            try await service.delete(id: uuid)
        }
        values.remove(atOffsets: offsets)
        try await service.updateOrder(ids: values.map { $0.id })
        try await fetch()
    }

    func move(from source: IndexSet, to destination: Int) async throws {
        var values = values
        values.move(fromOffsets: source, toOffset: destination)
        try await service.updateOrder(ids: values.map { $0.id })
        try await fetch()
    }
}
