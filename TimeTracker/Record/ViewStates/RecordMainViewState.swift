import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordMainViewState: ObservableObject {
    @Published var records: [RecordData] = []
    @Published var showListView: Bool = true
    @Published var isEditMode: Bool = false

    init() {}

    func onTapCompleteButton() {
        isEditMode.toggle()
    }
}
