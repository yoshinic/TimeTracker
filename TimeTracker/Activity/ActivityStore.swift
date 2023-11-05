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
        var fetchedValues = try await service.fetch(
            id: id,
            categoryId: categoryId,
            name: name
        )

        values = ([CategoryStore.shared.dummy] + CategoryStore.shared.values)
            .reduce(into: [:]) { res, c in
                let a: [ActivityData]
                if c.id == CategoryStore.shared.dummy.id {
                    a = fetchedValues.filter { $0.category?.id == nil }
                } else {
                    a = fetchedValues.filter { $0.category?.id == c.id }
                }
                res[c.id] = a
                a.forEach {
                    guard
                        let i = fetchedValues.firstIndex(of: $0)
                    else { return }
                    fetchedValues.remove(at: i)
                }
            }
    }

    func create(
        id: UUID? = nil,
        categoryId: UUID?,
        name: String,
        color: String
    ) async throws {
        let new = try await service.create(
            id: id,
            categoryId: categoryId,
            name: name,
            color: color
        )

        let id = categoryId ?? CategoryStore.shared.dummy.id
        values[id]?.append(new)
    }

    func update(
        id: UUID,
        categoryId: UUID?,
        name: String,
        color: String
    ) async throws {
        let updated = try await service.update(
            id: id,
            categoryId: categoryId,
            name: name,
            color: color
        )

        let cid = categoryId ?? CategoryStore.shared.dummy.id
        guard
            let i = values[cid]?.firstIndex(where: { $0.id == id }),
            values[cid] != nil
        else { throw AppError.notFound }
        values[cid]![i] = updated
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
