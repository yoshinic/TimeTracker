import SwiftUI
import TimeTrackerAPI

@MainActor
class CategoryFormViewState: ObservableObject {
    @Published var selectedName: String
    @Published var selectedColor: Color
    @Published var selectedColorHex: String
    @Published var selectedIcon: String

    let selectedId: UUID!
    let isAdd: Bool

    init(_ selectedCategory: CategoryData? = nil) {
        if let selectedCategory {
            self.selectedId = selectedCategory.id
            self.selectedName = selectedCategory.name
            self.selectedColor = .init(hex: selectedCategory.color)
            self.selectedColorHex = selectedCategory.color
            self.selectedIcon = selectedCategory.icon ?? ""
        } else {
            self.selectedId = nil
            self.selectedName = ""
            self.selectedColor = .white
            self.selectedColorHex = "#FFFFFF"
            self.selectedIcon = ""
        }

        self.isAdd = selectedCategory == nil
    }

    func onChangeSelectedColor(new: Color) {
        selectedColorHex = new.toHex()
    }

    func onTapAddOrEditButton() async {
        do {
            if isAdd {
                try await CategoryStore.shared.create(
                    name: selectedName,
                    color: selectedColorHex,
                    icon: selectedIcon
                )
            } else {
                try await CategoryStore.shared.update(
                    id: selectedId,
                    name: selectedName,
                    color: selectedColorHex,
                    icon: selectedIcon
                )
            }

        } catch {
            print(error)
        }
    }
}
