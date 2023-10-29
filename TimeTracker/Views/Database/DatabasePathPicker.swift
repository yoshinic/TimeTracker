import SwiftUI

struct DatabasePathPicker: View {
    @State private var showPicker = false

    let complition: (Result<URL, Error>) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("使用するSQLiteファイルを選択して下さい:")
            Button("選択") {
                showPicker.toggle()
            }
            .fileImporter(
                isPresented: $showPicker,
                allowedContentTypes: [.sqlite, .sqlite3],
                onCompletion: complition
            )
        }
        .bold()
    }
}
