import SwiftUI
import TimeTrackerAPI

struct ContentView: View {
    @State private var isReady: Bool = false
    @State private var filePath: String = {
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = url.appendingPathComponent("records.sqlite3")
        return path.absoluteString
    }()

    var body: some View {
        #if os(macOS)
        if isReady {
            _ContentView(filePath: filePath)
        } else {
            DatabasePathPicker {
                switch $0 {
                case let .success(url):
                    filePath = url.absoluteString
                    isReady = true
                case let .failure(error):
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
        }
        #elseif os(iOS)
        _ContentView(filePath: filePath)
        #else
        EmptyView()
        #endif
    }
}

struct _ContentView: View {
    @State private var isReady: Bool = false

    let filePath: String

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
                    try await DatabaseServiceManager
                        .shared
                        .setDatabase(filePath: filePath)
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
