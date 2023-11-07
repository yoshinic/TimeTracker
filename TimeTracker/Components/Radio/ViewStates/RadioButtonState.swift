import Combine

@MainActor
class RadioButtonState: ObservableObject {
    @Published var selectedIdx: Int = 0

    let titles: [String]
    let onTapItem: @MainActor (Int, Int) -> Void

    init(
        selectedIdx: Int,
        titles: [String],
        onTapItem: @escaping @MainActor (Int, Int) -> Void
    ) {
        self.selectedIdx = selectedIdx
        self.titles = titles
        self.onTapItem = onTapItem
    }

    func onTapRadioItem(_ new: Int) {
        let old = selectedIdx
        selectedIdx = new
        onTapItem(old, new)
    }
}
