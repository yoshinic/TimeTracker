import SwiftUI
import TimeTrackerAPI

@MainActor
class ActivityFormViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]

    @Published var selectedCategoryId: UUID?
    @Published var selectedName: String
    @Published var selectedColor: Color
    @Published var selectedColorHex: String

    let selectedId: UUID!
    let isAdd: Bool

    init(_ selectedActivity: ActivityData? = nil) {
        self.categories = CategoryStore.shared.values

        if let selectedActivity {
            self.selectedId = selectedActivity.id
            self.selectedCategoryId = selectedActivity.category?.id
            self.selectedName = selectedActivity.name
            self.selectedColor = .init(hex: selectedActivity.color)
            self.selectedColorHex = selectedActivity.color

        } else {
            self.selectedId = nil
            self.selectedCategoryId = nil
            self.selectedName = ""
            self.selectedColor = .white
            self.selectedColorHex = "#FFFFFF"
        }

        self.isAdd = selectedActivity == nil
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
                    id: selectedId,
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
