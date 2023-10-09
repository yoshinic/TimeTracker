import SwiftUI

@main
struct TimeTrackerApp: App {
    @AppStorage("selectedTheme") var selectedTheme: String = "Light"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.theme, selectedTheme == "Light" ? lightTheme : darkTheme)
        }
    }
}
