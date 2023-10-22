import SwiftUI

struct DatabasePathPicker: View {
    @State private var showPicker = false
    @Binding var isPathChosen: Bool

    let complition: (Result<URL, Error>) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("データの保存先を選択して下さい:")
            Button("選択") {
                showPicker.toggle()
            }
            .fileImporter(
                isPresented: $showPicker,
                allowedContentTypes: [.folder],
                onCompletion: complition
            )
        }
        .bold()
    }
}
