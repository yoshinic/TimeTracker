import SwiftUI
import TimeTrackerAPI

@MainActor
class CategoryListViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]

    @Published var isModalPresented: Bool = false
    @Published private(set) var isEditMode: Bool = false

    init() {
        self.categories = CategoryStore.shared.values
    }

    func onDelete(at idx: IndexSet) async {
        do {
            try await CategoryStore.shared.delete(at: idx)
            CategoryStore.shared.$values.assign(to: &$categories)
        } catch {
            print(error)
        }
    }

    func onMove(from source: IndexSet, to destination: Int) async {
        do {
            try await CategoryStore.shared.move(from: source, to: destination)
            CategoryStore.shared.$values.assign(to: &$categories)
        } catch {
            print(error)
        }
    }

    func onTapAddButton() {
        isModalPresented = true
    }

    func onTapEditButton() {
        isEditMode.toggle()
    }
}
