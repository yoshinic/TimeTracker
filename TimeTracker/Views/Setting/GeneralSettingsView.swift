import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("selectedTheme") var selectedTheme: String = "Light"

    var body: some View {
        NavigationView {
            Form {
                Picker("Theme", selection: $selectedTheme) {
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                }
            }
        }
        .navigationBarTitle("一般", displayMode: .inline)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
