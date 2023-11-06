import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordCategoryViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []
    @Published var selectedCategories: Set<CategoryData>
    @Published private(set) var filteredCategories: [CategoryData] = []

    let onCategoriesChanged: (@MainActor (Set<CategoryData>) -> Void)?

    private var cancellables: Set<AnyCancellable> = []

    init(
        _ selectedCategories: Set<CategoryData> = [],
        _ onCategoriesChanged: (@MainActor (Set<CategoryData>) -> Void)? = nil
    ) {
        self.selectedCategories = selectedCategories
        self.onCategoriesChanged = onCategoriesChanged

        CategoryStore.shared.$values.assign(to: &$categories)
        $selectedCategories
            .map { selected in
                self.categories.filter { selected.contains($0) }
            }
            .assign(to: &$filteredCategories)

        if let onCategoriesChanged {
            $selectedCategories
                .receive(on: DispatchQueue.main)
                .sink { onCategoriesChanged($0) }
                .store(in: &cancellables)
        }
    }

    func onTapAllSelected() {
        selectedCategories = categories.reduce(into: []) { $0.insert($1) }
    }

    func onTapAllRemoved() {
        selectedCategories = []
    }
}
