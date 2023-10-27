import SwiftUI
import TimeTrackerAPI

struct ContentView: View {
    @State private var isReady: Bool = false

    var filePath: String {
        let fileName = "records.sqlite3"

        let fm = FileManager.default
        let url: URL?
        #if os(macOS)
        url = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        #elseif os(iOS)
        url = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        #else
        url = nil
        #endif

        guard let url = url else { return "" }
        let path = url.appendingPathComponent(fileName)
        return path.absoluteString
    }

    var body: some View {
        TabView {
            if isReady {
                MainView()
            } else {
                EmptyView()
            }
        }
        .onAppear {
            Task { @MainActor in
                do {
                    guard !filePath.isEmpty else { return }
                    try await DatabaseServiceManager.shared.setDatabase(filePath: filePath)
                    isReady = true
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct MainView: View {
    @StateObject private var categoryViewModel: CategoryViewModel = .init()
    @StateObject private var activityViewModel: ActivityViewModel = .init()
    @StateObject private var recordViewModel: RecordViewModel = .init()

    var body: some View {
        NavigationView {
            RecordView(
                categoryViewModel: categoryViewModel,
                activityViewModel: activityViewModel,
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
                activityViewModel: activityViewModel,
                categoryViewModel: categoryViewModel
            )
        }
        .tabItem {
            Label("Setting", systemImage: "gear")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
