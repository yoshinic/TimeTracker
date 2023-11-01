import SwiftUI
import TimeTrackerAPI

struct MainView: View {
    @StateObject private var categoryViewModel: CategoryViewModel = .init()
    @StateObject private var activityViewModel: ActivityViewModel = .init()
    @StateObject private var recordViewModel: RecordViewModel = .init()

    @State private var isReady: Bool = false

    var body: some View {
        TabView {
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
                RecordMainView(
                    categoryViewModel: categoryViewModel,
                    activityViewModel: activityViewModel,
                    recordViewModel: recordViewModel
                )
            }
            .tabItem {
                Label("Record", systemImage: "chart.bar")
            }
            NavigationView {
                SettingsView(
                    categoryViewModel: categoryViewModel,
                    activityViewModel: activityViewModel
                )
            }
            .tabItem {
                Label("Setting", systemImage: "gear")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
