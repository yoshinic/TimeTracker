import SwiftUI
import TimeTrackerAPI

class CategoryViewModel: ObservableObject {
    @Published var categories: [CategoryData] = []
    let defaultId: UUID = CategoryService.defaultId

    private let service = DefaultServiceFactory.shared.category

    var count: Int = 0

    func fetchCategories() {
        Task.detached { @MainActor in
            self.categories = try await self.service.fetch()
            self.count = self.categories.count
        }
    }

    func addCategory(
        id: UUID? = nil,
        name: String,
        color: String
    ) {
        Task.detached { @MainActor in
            let newCategory = try await self.service.create(
                id: id,
                name: name,
                color: color
            )
            self.categories.append(newCategory)
            self.count += 1
        }
    }

    func updateCategory(
        id: UUID,
        name: String,
        color: String
    ) {
        Task.detached { @MainActor in
            try await self.service.update(
                id: id,
                name: name,
                color: color
            )
        }
    }

    func deleteCategory(id: UUID) {
        guard
            let i = self.categories.firstIndex(where: { $0.id == id })
        else { return }
        deleteCategories(at: IndexSet([i]))
    }

    func deleteCategories(at offsets: IndexSet) {
        Task.detached { @MainActor in
            for i in offsets {
                try await self.service.delete(id: self.categories[i].id)
            }
            self.categories.remove(atOffsets: offsets)
            try await self.service.updateOrder(ids: self.categories.map { $0.id })
            self.fetchCategories()
        }
    }

    func moveCategories(from source: IndexSet, to destination: Int) {
        Task.detached { @MainActor in
            self.categories.move(fromOffsets: source, toOffset: destination)
            try await self.service.updateOrder(ids: self.categories.map { $0.id })
            self.fetchCategories()
        }
    }
}
