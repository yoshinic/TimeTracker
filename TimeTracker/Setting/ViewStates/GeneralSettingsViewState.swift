import SwiftUI

@MainActor
class GeneralSettingsViewState: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: String = "Light"
}
