import SwiftUI
import TimeTrackerAPI

@MainActor
class UpdateRecordViewState: ObservableObject {
    @Published private(set) var categories: [CategoryData]
    @Published private(set) var activities: [UUID: [ActivityData]]

    @Published var selectedRecordId: UUID
    @Published var selectedCategoryId: UUID
    @Published var selectedActivityId: UUID
    @Published var selectedStartDatetime: Date
    @Published var selectedEndDatetime: Date?
    @Published var selectedNote: String

    let defaultCategoryId: UUID = CategoryStore.shared.dummy.id
    let defaultActivityId: UUID = ActivityStore.shared.dummy.id

    var filteredActivities: [ActivityData] {
        if selectedCategoryId == defaultCategoryId {
            activities.values.flatMap { $0 }
        } else {
            activities[selectedCategoryId] ?? []
        }
    }

    init(_ selectedRecord: RecordData) {
        self.categories = CategoryStore.shared.values
        self.activities = ActivityStore.shared.values

        self.selectedRecordId = selectedRecord.id
        self.selectedCategoryId
            = selectedRecord.activity?.category?.id ?? defaultCategoryId
        self.selectedActivityId
            = selectedRecord.activity?.id ?? defaultActivityId
        self.selectedStartDatetime = selectedRecord.startedAt
        self.selectedEndDatetime = selectedRecord.endedAt
        self.selectedNote = selectedRecord.note
    }

    func onChange(id: UUID) {
        guard id != defaultCategoryId else { return }
        selectedActivityId = filteredActivities.first?.id
            ?? defaultActivityId
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

@MainActor
class SearchRecordEndDateViewState: ObservableObject {
    @Published var selectedEndDatetime: Date?
    @Published var selectedPickerEndDatetime: Date
    @Published var emptyEndDate: Bool

    init(_ selectedEndDatetime: Date?) {
        self.selectedEndDatetime = selectedEndDatetime
        self.emptyEndDate = selectedEndDatetime == nil
        self.selectedPickerEndDatetime = selectedEndDatetime ?? .init()
    }

    func onTapSelectionOptionButton() {
        emptyEndDate.toggle()
        guard emptyEndDate else { return }
        selectedEndDatetime = nil
    }

    func onChange(_ new: Date) {
        selectedEndDatetime = new
    }
}
