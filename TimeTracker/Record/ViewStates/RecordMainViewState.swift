import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordMainViewState: ObservableObject {
    @Published var records: [RecordData] = []
    @Published var showListView: Bool = true
    @Published var isEditMode: Bool = false

    @Published var selectedCategories: Set<CategoryData> = []
    @Published var selectedActivities: Set<ActivityData> = []
    @Published var selectedStartDatetime: Date = Calendar
        .current
        .date(byAdding: .day, value: -7, to: .init()) ?? Date()
    @Published var selectedEndDatetime: Date? = nil
    @Published var selectedSortType: RecordDataSortType = .time

    init() {}

    private func fetch() async throws {
        try await RecordStore.shared.fetch(
            categories: selectedCategories.reduce(into: []) {
                $0.insert($1.id)
            },
            activities: selectedActivities.reduce(into: []) {
                $0.insert($1.id)
            },
            from: selectedStartDatetime,
            to: selectedEndDatetime
        )
    }

    func onTapCompleteButton() {
        isEditMode.toggle()
    }

    func onChangeParameter() async {
        do {
            try await fetch()
        } catch {
            print(error)
        }
    }

    func onChangeSort() {
        RecordStore.shared.sort(&records, by: selectedSortType)
    }

    func task() async {
        do {
            try await fetch()
        } catch {
            print(error)
        }
    }
}
