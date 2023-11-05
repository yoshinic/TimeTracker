import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordCategoryViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]
    @Published var selectedCategories: Set<CategoryData>

    var filteredCategories: [CategoryData] {
        categories.filter { selectedCategories.contains($0) }
    }

    init(_ selectedCategories: Set<CategoryData>) {
        self.categories = CategoryStore.shared.values
        self.selectedCategories = selectedCategories
    }
}

@MainActor
class SearchRecordCategorySelectionViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]
    @Published var selectedCategories: Set<CategoryData>

    init(
        _ categories: [CategoryData],
        _ selectedCategories: Set<CategoryData>
    ) {
        self.categories = categories
        self.selectedCategories = selectedCategories
    }

    func onTapAllSelected() {
        selectedCategories = categories.reduce(into: []) { $0.insert($1) }
    }

    func onTapAllRemoved() {
        selectedCategories = []
    }
}
