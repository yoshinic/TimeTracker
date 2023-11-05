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
        .navigationBarTitle("一般", displayMode: .inline)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(state: .init())
    }
}