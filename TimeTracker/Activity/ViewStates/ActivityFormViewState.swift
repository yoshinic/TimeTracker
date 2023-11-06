import SwiftUI
import TimeTrackerAPI

@MainActor
class ActivityFormViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []

    @Published var selectedCategoryId: UUID?
    @Published var selectedName: String
    @Published var selectedColor: Color
    @Published var selectedColorHex: String

    let selectedActivity: ActivityData!
    let isAdd: Bool

    init(_ selectedActivity: ActivityData? = nil) {
        if let selectedActivity {
            self.selectedActivity = selectedActivity
            self.selectedCategoryId = selectedActivity.category?.id
            self.selectedName = selectedActivity.name
            self.selectedColor = .init(hex: selectedActivity.color)
            self.selectedColorHex = selectedActivity.color

        } else {
            self.selectedActivity = nil
            self.selectedCategoryId = CategoryStore.shared.values.first?.id
            self.selectedName = ""
            self.selectedColor = .white
            self.selectedColorHex = "#FFFFFF"
        }

        self.isAdd = selectedActivity == nil

        CategoryStore.shared.$values.assign(to: &$categories)
    }

    func onChangeSelectedColor(new: Color) {
        selectedColorHex = new.toHex()
    }

    func onTapAddOrEditButton() async {
        do {
            if isAdd {
                try await ActivityStore.shared.create(
                    categoryId: selectedCategoryId,
                    name: selectedName,
                    color: selectedColorHex
                )
            } else {
                try await ActivityStore.shared.update(
                    original: selectedActivity,
                    categoryId: selectedCategoryId,
                    name: selectedName,
                    color: selectedColorHex
                )
            }
        } catch {
            print(error)
        }
    }
}
