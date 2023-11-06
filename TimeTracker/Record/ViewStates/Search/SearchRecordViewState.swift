import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordViewState: ObservableObject {
    @Published var selectedCategories: Set<CategoryData> = []
    @Published var selectedActivities: Set<ActivityData> = []
    @Published var selectedStartDatetime: Date = Calendar
        .current
        .date(byAdding: .day, value: -7, to: .init()) ?? Date()
    @Published var selectedEndDatetime: Date? = nil
    @Published var selectedSortType: RecordDataSortType = .time

    private var cancellables = Set<AnyCancellable>()

    init() {
//        Publishers
//            .CombineLatest(
//                $selectedCategories,
//                $selectedActivities
//            )
//            .combineLatest(
//                $selectedStartDatetime,
//                $selectedEndDatetime,
//                $selectedSortType
//            )
//            .sink { ca, startTime, endTime, type in
//                let (categories, activities) = ca
//
//                let categoryIds = Set(categories.map { $0.id })
//                let activityIds = Set(activities.map { $0.id })
//
//                Task {
//                    do {
//                        try await RecordStore.shared.fetch(
//                            categories: categoryIds,
//                            activities: activityIds,
//                            from: startTime,
//                            to: endTime
//                        )
//                        RecordStore.shared.sort(by: type)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//            .store(in: &cancellables)
    }

    func onCategoriesChanged(categories: Set<CategoryData>) {
        selectedCategories = categories
        load()
    }

    func onActivitiesChanged(activities: Set<ActivityData>) {
        selectedActivities = activities
        load()
    }

    func onStartDateChanged(date: Date) {
        selectedStartDatetime = date
        load()
    }

    func onEndDateChanged(date: Date) {
        selectedEndDatetime = date
        load()
    }

    func onSortTypeChanged(sortType: RecordDataSortType) {
        guard selectedSortType != sortType else { return }
        selectedSortType = sortType
        sort()
    }

    private func load() {
        Task {
            do {
                try await RecordStore.shared.fetch(
                    categories:  Set(selectedCategories.map { $0.id }),
                    activities: Set(selectedActivities.map { $0.id }),
                    from: selectedStartDatetime,
                    to: selectedEndDatetime
                )
                sort()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func sort() {
        RecordStore.shared.sort(by: selectedSortType)
    }
}
