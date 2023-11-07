import SwiftUI
import TimeTrackerAPI

@MainActor
class ActivityFormViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []

    @Published var circleState: CustomCircleState = .init()
    @Published var imageState: CustomSystemImageState = .init("")
    
    @Published var selectedCategoryId: UUID?
    @Published var selectedName: String
    @Published var selectedColor: Color
    @Published var selectedColorHex: String
    @Published var selectedIcon: String

    let selectedActivity: ActivityData!
    let isAdd: Bool

    init(_ selectedActivity: ActivityData? = nil) {
        if let selectedActivity {
            self.selectedActivity = selectedActivity
            self.selectedCategoryId = selectedActivity.category?.id
            self.selectedName = selectedActivity.name
            self.selectedColor = .init(hex: selectedActivity.color)
            self.selectedColorHex = selectedActivity.color
            self.selectedIcon = selectedActivity.icon

        } else {
            self.selectedActivity = nil
            self.selectedCategoryId = CategoryStore.shared.values.first?.id
            self.selectedName = ""
            self.selectedColor = .white
            self.selectedColorHex = "#FFFFFF"
            self.selectedIcon = ""
        }

        self.isAdd = selectedActivity == nil

        CategoryStore.shared.$values.assign(to: &$categories)
        $selectedIcon.assign(to: &imageState.$systemName)
        
        self.circleState.color = selectedColorHex
    }

    func onChangeSelectedColor() {
        let hex = selectedColor.toHex()
        selectedColorHex = hex
        imageState.color = hex
        circleState.color = hex
    }

    func onTapAddOrEditButton() async {
        do {
            if isAdd {
                try await ActivityStore.shared.create(
                    categoryId: selectedCategoryId,
                    name: selectedName,
                    color: selectedColorHex,
                    icon: selectedIcon
                )
            } else {
                try await ActivityStore.shared.update(
                    original: selectedActivity,
                    categoryId: selectedCategoryId,
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
