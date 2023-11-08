import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordSortViewState: ObservableObject {
    @Published private(set) var selectedSortType: RecordDataSortType
    @Published private(set) var selectedIdx: Int = 0

    let onSortTypeChanged: (@MainActor (RecordDataSortType) -> Void)?
    let viewTitle: String = "ソート"
    let viewTitleWidth: CGFloat = 60
    let sortNames: [String] = ["種別", "時間"]
    let radioColor: String = "#008800"

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

        $selectedSortType
            .map { $0 == .kind ? 0 : 1 }
            .assign(to: &$selectedIdx)
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
