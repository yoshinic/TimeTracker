import Foundation
import Combine
import TimeTrackerAPI

@MainActor
final class ActivityStore {
    static let shared: ActivityStore = .init()

    @Published private(set) var values: [UUID: [ActivityData]] = [:]

    private var service: ActivityService = DatabaseServiceManager.shared.activity

    let dummy: ActivityData = .init(
        id: .init(),
        category: CategoryStore.shared.dummy,
        name: "未設定",
        color: "#FFFFFF",
        order: -1
    )

    func fetch(
        id: UUID? = nil,
        categoryId: UUID? = nil,
        name: String? = nil
    ) async throws {
        var data = try await service.fetch(
            id: id,
            categoryId: categoryId,
            name: name
        )

        var dic: [UUID: [ActivityData]] = CategoryStore
            .shared
            .values
            .reduce(into: [:]) { res, c in
                let a = data.filter { $0.category?.id == c.id }
                res[c.id] = a.sorted { $0.order < $1.order }
                a.forEach {
                    guard let i = data.firstIndex(of: $0) else { return }
                    data.remove(at: i)
                }
            }

        dic[CategoryStore.shared.dummy.id] = data.sorted { $0.order < $1.order }
        values = dic
    }

    func create(
        id: UUID? = nil,
        categoryId: UUID?,
        name: String,
        color: String
    ) async throws {
        try await service.create(
            id: id,
            categoryId: categoryId,
            name: name,
            color: color
        )
        try await fetch()
    }

    func update(
        original: ActivityData,
        categoryId: UUID?,
        name: String,
        color: String
    ) async throws {
        let updatingCategoryId: UUID? = {
            guard let cid = categoryId else { return nil }
            guard cid == CategoryStore.shared.dummy.id else { return categoryId }
            return nil
        }()

        try await service.update(
            id: original.id,
            categoryId: updatingCategoryId,
            name: name,
            color: color
        )

        try await fetch()
    }

    func delete(
        at offsets: IndexSet,
        categoryId: UUID
    ) async throws {
        let ids = offsets.compactMap { values[categoryId]?[$0].id }
        for uuid in ids {
            try await service.delete(id: uuid)
        }

        var a = values[categoryId]?.map { $0.id } ?? []
        a.remove(atOffsets: offsets)
        try await service.updateOrder(ids: a)
        try await fetch()
    }

    func move(
        from source: IndexSet,
        to destination: Int,
        categoryId: UUID
    ) async throws {
        var a = values[categoryId]?.map { $0.id } ?? []
        a.move(
            fromOffsets: source,
            toOffset: destination
        )
        try await service.updateOrder(ids: a)
        try await fetch()
    }
}
