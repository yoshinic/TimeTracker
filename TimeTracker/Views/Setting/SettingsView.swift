import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedTheme") var selectedTheme: String = "Light"

    var body: some View {
        Form {
            Picker("Theme", selection: $selectedTheme) {
                Text("Light").tag("Light")
                Text("Dark").tag("Dark")
            }
        }
        .navigationTitle("Settings")
    }
}
