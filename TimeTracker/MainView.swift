import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            RecordingView(state: .init())
                .tabItem {
                    Label("開始", systemImage: "video")
                }
            RecordMainView(state: .init())
                .tabItem {
                    Label("記録", systemImage: "chart.bar")
                }
            SettingsView(state: .init())
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
