import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordSortViewState: ObservableObject {
    @Published private(set) var selectedSortType: RecordDataSortType

    let onSortTypeChanged: (@MainActor (RecordDataSortType) -> Void)?

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
}

@MainActor
class RadioTextTitleViewState: ObservableObject {
    @Published private(set) var selectedSortType: RecordDataSortType

    init(_ selectedSortType: RecordDataSortType) {
        self.selectedSortType = selectedSortType
    }

    func onTapKindSortButton() {
        selectedSortType = .kind
    }

    func onTapTimeSortButton() {
        selectedSortType = .time
    }
}
