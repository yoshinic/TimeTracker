import SwiftUI
import TimeTrackerAPI

class ActivityViewModel: ObservableObject {
    @Published var activities: [ActivityData] = []
    @Published var isEditMode: Bool = false

    private let service = DefaultServiceFactory.shared.activity

    func fetchActivities() async {
        do {
            self.activities = try await service.fetch()
        } catch {
            print("Error fetching activities: \(error)")
        }
    }

    func addActivity(name: String, color: String) async {
        do {
            let newActivity = try await service.create(name: name, color: color)
            self.activities.append(newActivity)
        } catch {
            print("Error adding activity: \(error)")
        }
    }

    func deleteActivities(at offsets: IndexSet) {
        for index in offsets {
            let activity = activities[index]
            Task {
                do {
                    try await service.delete(name: activity.name)
                    await fetchActivities()
                } catch {
                    print("Error deleting activity: \(error)")
                }
            }
        }
    }

    func moveActivities(from source: IndexSet, to destination: Int) {
        activities.move(fromOffsets: source, toOffset: destination)
        // ここで、並び替えた結果を永続化するためのロジックを追加できます。
    }
}
