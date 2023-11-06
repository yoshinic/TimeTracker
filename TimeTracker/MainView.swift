import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            NavigationView {
                RecordingView(state: .init())
            }
            .tabItem {
                Label("記録", systemImage: "figure.run")
            }
            NavigationView {
                RecordMainView(state: .init())
            }
            .tabItem {
                Label("Record", systemImage: "chart.bar")
            }
            NavigationView {
                SettingsView(state: .init())
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
