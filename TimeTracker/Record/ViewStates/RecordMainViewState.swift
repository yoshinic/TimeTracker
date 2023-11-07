import Combine
import TimeTrackerAPI

@MainActor
class RecordMainViewState: ObservableObject {
    @Published var records: [RecordData] = []
    @Published var showListView: Bool = true
    @Published var isEditMode: Bool = false

    let titles: [String] = ["リスト", "チャート"]

    init() {}

    func onTapCompleteButton() {
        isEditMode.toggle()
    }

    func onTapRadioButton(old: Int, new: Int) {
        guard old != new else { return }
        switch new {
        case 0: showListView = true
        case 1: showListView = false
        default: return
        }
    }
}
