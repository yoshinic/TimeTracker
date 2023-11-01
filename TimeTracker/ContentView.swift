import SwiftUI
import TimeTrackerAPI

struct ContentView: View {
    @State private var isReady: Bool = false
    @State private var filePath: String = {
        // iOS用のファイルパスを初期値にしておく
        let fm = FileManager.default
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = url.appendingPathComponent("records.sqlite3")
        return path.absoluteString
    }()

    var body: some View {
        #if os(macOS)
        if isReady {
            DatabaseView(filePath: filePath)
        } else {
            DatabasePathPicker {
                switch $0 {
                case let .success(url):
                    filePath = url.absoluteString
                    isReady = true
                case let .failure(error):
                    print("Error selecting file: \(error.localizedDescription)")
                }
            }
        }
        #elseif os(iOS)
        DatabaseView(filePath: filePath)
        #else
        EmptyView()
        #endif
    }
}

// データベース読込み
private struct DatabaseView: View {
    @State private var isReady: Bool = false

    let filePath: String

    var body: some View {
        if isReady {
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
            .onAppear {
                Task {
                    do {
                        try await DatabaseServiceManager
                            .shared
                            .setDatabase(filePath: filePath)
                        isReady = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
