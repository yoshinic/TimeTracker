import SwiftUI
import TimeTrackerAPI

struct ContentView: View {
    @State private var isPathChosen = false

    let keychainHelper = KeychainHelper()

    var body: some View {
        if let _ = keychainHelper.getDatabasePath() {
            _ContentView()
        } else {
            DatabasePathPicker(isPathChosen: $isPathChosen) { result in
                Task {
                    guard let url = try? result.get() else { return }
                    keychainHelper.saveDatabasePath(path: url.path)
                    try await DefaultServiceFactory.shared.setDatabase(filePath: url.path + "/sample.sqlite3")
                    isPathChosen = true
                }
            }
        }
    }
}

private struct _ContentView: View {
    @StateObject private var categoryViewModel: CategoryViewModel = .init()
    @StateObject private var activityviewModel: ActivityViewModel = .init()
    @StateObject private var recordViewModel: RecordViewModel = .init()

    var body: some View {
        TabView {
            NavigationView {
                RecordView(
                    categoryViewModel: categoryViewModel,
                    activityViewModel: activityviewModel,
                    recordViewModel: recordViewModel
                )
            }
            .tabItem {
                Label("記録", systemImage: "figure.run")
            }
            NavigationView {
                RecordListView(recordViewModel: recordViewModel)
            }
            .tabItem {
                Label("Record", systemImage: "chart.bar")
            }
            NavigationView {
                SettingsView(
                    activityViewModel: activityviewModel,
                    categoryViewModel: categoryViewModel
                )
            }
            .tabItem {
                Label("Setting", systemImage: "gear")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
