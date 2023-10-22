import SwiftUI
import TimeTrackerAPI

struct CategoryFormView: View {
    @ObservedObject var viewModel: CategoryViewModel

    let category: CategoryData!
    let mode: CategoryFormMode

    @State private var name: String = ""
    @State private var selectedColor: Color = .white
    @State private var color: String = "#FFFFFF"

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Form {
                Section(header: Text("カテゴリー作成項目")) {
                    TextField("カテゴリー名", text: $name)
                    ColorPicker("カラー選択", selection: $selectedColor)
                }

                Section(header: Text("")) {
                    HStack(alignment: .center, spacing: 30) {
                        Spacer()
                        Button {
                            switch mode {
                            case .add:
                                viewModel.create(
                                    id: UUID(),
                                    name: name,
                                    color: color
                                )
                            case .edit:
                                viewModel.update(
                                    id: category.id,
                                    name: name,
                                    color: color
                                )
                            }
                            dismiss()
                        } label: {
                            Text(mode == .add ? "Add" : "Update")
                        }

                        Button { dismiss() } label: { Text("Cancel") }
                    }
                }
            }
        }
//        .navigationBarTitle("カテゴリー\(mode == .add ? "作成" : "更新")", displayMode: .inline)
        .onAppear {
            guard mode == .edit else { return }
            name = category.name
            selectedColor = Color(hex: category.color)
            color = category.color
        }
        .onChange(of: selectedColor) { newColor in
            color = newColor.toHex()
        }
    }
}

enum CategoryFormMode {
    case add, edit
}
