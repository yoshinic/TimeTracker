import SwiftUI

struct ContentView: View {
    @StateObject private var activityviewModel: ActivityViewModel = .init()
    @StateObject private var categoryViewModel: CategoryViewModel = .init()
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
