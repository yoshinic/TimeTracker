import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class UpdateRecordViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData] = []
    @Published private(set) var activities: [UUID: [ActivityData]] = [:]
    @Published private(set) var filteredActivities: [ActivityData] = []

    @Published var selectedRecordId: UUID
    @Published var selectedCategoryId: UUID
    @Published var selectedActivityId: UUID
    @Published var selectedStartDatetime: Date
    @Published var selectedEndDatetime: Date?
    @Published var selectedNote: String

    @Published var selectedPickerEndDatetime: Date
    @Published var isEmptyEndDate: Bool

    let defaultCategoryId: UUID = CategoryStore.shared.dummy.id
    let defaultActivityId: UUID = ActivityStore.shared.dummy.id

    private var cancellables: Set<AnyCancellable> = []

    init(_ selectedRecord: RecordData) {
        self.selectedRecordId = selectedRecord.id
        self.selectedCategoryId
            = selectedRecord.activity?.category?.id ?? defaultCategoryId
        self.selectedActivityId
            = selectedRecord.activity?.id ?? defaultActivityId
        self.selectedStartDatetime = selectedRecord.startedAt
        self.selectedNote = selectedRecord.note

        let endedAt = selectedRecord.endedAt
        self.selectedEndDatetime = endedAt
        self.selectedPickerEndDatetime = endedAt ?? .init()
        self.isEmptyEndDate = endedAt == nil

        CategoryStore.shared.$values.assign(to: &$categories)
        ActivityStore.shared.$values.assign(to: &$activities)

        $selectedCategoryId
            .map { [weak self] in
                if $0 == self?.defaultCategoryId {
                    self?.activities.values.flatMap { $0 } ?? []
                } else {
                    self?.activities[$0] ?? []
                }
            }
            .assign(to: &$filteredActivities)
    }

    func onCategoryChanged(_ id: UUID) {
        guard id != defaultCategoryId else { return }
        selectedActivityId = filteredActivities.first?.id
            ?? defaultActivityId
    }

    func onStartDateChanged(date: Date) {
        selectedStartDatetime = date
    }

    func onEndDateChanged(date: Date) {
        selectedEndDatetime = date
    }

    func onTapSelectionOptionButton() {
        isEmptyEndDate.toggle()
        guard isEmptyEndDate else { return }
        selectedEndDatetime = nil
    }

    func onTapUpdateButton() async {
        do {
            try await RecordStore.shared.update(
                id: selectedRecordId,
                activityId: selectedActivityId,
                startedAt: selectedStartDatetime,
                endedAt: selectedEndDatetime,
                note: selectedNote
            )
        } catch {
            print(error)
        }
    }
}
