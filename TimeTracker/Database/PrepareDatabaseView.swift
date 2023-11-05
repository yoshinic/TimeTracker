import SwiftUI
import TimeTrackerAPI

struct PrepareDatabaseView: View {
    @StateObject var state: PrepareDatabaseViewState

    var body: some View {
        if state.isReady {
            MainView()
        } else {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("準備中...")
                    Spacer()
                }
                Spacer()
            }
            .task { await state.onAppear() }
        }
    }
}
