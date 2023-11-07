import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordSortViewState: ObservableObject {
    @Published private(set) var selectedSortType: RecordDataSortType

    let onSortTypeChanged: (@MainActor (RecordDataSortType) -> Void)?
    let titles: [String] = ["種別", "時間"]

    private var cancellables: Set<AnyCancellable> = []

    init(
        _ selectedSortType: RecordDataSortType = .time,
        _ onSortTypeChanged: (@MainActor (RecordDataSortType) -> Void)? = nil
    ) {
        self.selectedSortType = selectedSortType
        self.onSortTypeChanged = onSortTypeChanged

        if let onSortTypeChanged {
            $selectedSortType
                .receive(on: DispatchQueue.main)
                .sink { onSortTypeChanged($0) }
                .store(in: &cancellables)
        }
    }

    func onTapRadioButton(old: Int, new: Int) {
        guard old != new else { return }
        switch new {
        case 0: selectedSortType = .kind
        case 1: selectedSortType = .time
        default: return
        }
    }
}
