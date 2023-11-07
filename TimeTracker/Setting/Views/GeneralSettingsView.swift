import SwiftUI

struct GeneralSettingsView: View {
    @StateObject var state: GeneralSettingsViewState

    var body: some View {
        NavigationView {
            Form {
                Picker("Theme", selection: $state.selectedTheme) {
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                }
            }
        }
        .navigationTitle("一般")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(state: .init())
    }
}
