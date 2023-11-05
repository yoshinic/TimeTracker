import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordSortViewState: ObservableObject {
    @Published private(set) var selectedSortType: RecordDataSortType

    init(_ selectedSortType: RecordDataSortType) {
        self.selectedSortType = selectedSortType
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
