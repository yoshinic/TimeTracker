import SwiftUI
import TimeTrackerAPI

@MainActor
class PrepareDatabaseViewState: ObservableObject {
    @Published var isReady: Bool = false

    let filePath: String

    init(_ filePath: String) {
        self.filePath = filePath
    }

    func onAppear() async {
        do {
            try await DatabaseServiceManager
                .shared
                .setDatabase(filePath: filePath)
            try await CategoryStore.shared.fetch()
            try await ActivityStore.shared.fetch()
            isReady = true
        } catch {
            print(error.localizedDescription)
        }
    }
}
