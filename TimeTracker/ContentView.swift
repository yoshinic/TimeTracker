import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                RecordListView()
            }
            .tabItem {
                Label("Record", systemImage: "chart.bar")
            }
            NavigationView {
                ActivityListView()
            }
            .tabItem {
                Label("Activity", systemImage: "list.bullet")
            }
            NavigationView {
                SettingsView()
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
