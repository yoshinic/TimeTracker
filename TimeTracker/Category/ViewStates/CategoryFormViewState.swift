import SwiftUI
import TimeTrackerAPI

@MainActor
class CategoryFormViewState: ObservableObject {
    @Published var circleState: CustomCircleState = .init()
    @Published var imageState: CustomSystemImageState = .init("")

    @Published var selectedName: String
    @Published var selectedColor: Color
    @Published var selectedColorHex: String
    @Published var selectedIcon: String

    let selectedCategory: CategoryData!
    let isAdd: Bool

    init(_ selectedCategory: CategoryData? = nil) {
        if let selectedCategory {
            self.selectedCategory = selectedCategory
            self.selectedName = selectedCategory.name
            self.selectedColor = .init(hex: selectedCategory.color)
            self.selectedColorHex = selectedCategory.color
            self.selectedIcon = selectedCategory.icon
        } else {
            self.selectedCategory = nil
            self.selectedName = ""
            self.selectedColor = .white
            self.selectedColorHex = "#FFFFFF"
            self.selectedIcon = ""
        }

        self.isAdd = selectedCategory == nil

        $selectedIcon.assign(to: &imageState.$systemName)

        self.circleState.color = selectedColorHex
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
                    selectedCategory,
                    name: selectedName,
                    color: selectedColorHex,
                    icon: selectedIcon
                )
            }
        } catch {
            print(error)
        }
    }

    func onChangeSelectedColor() {
        let hex = selectedColor.toHex()
        selectedColorHex = hex
        imageState.color = hex
        circleState.color = hex
    }
}
