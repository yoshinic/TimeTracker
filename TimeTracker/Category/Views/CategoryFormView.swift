import SwiftUI

struct CategoryFormView: View {
    @StateObject var state: CategoryFormViewState

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("カテゴリ作成項目") {
                TextField("カテゴリ名", text: $state.selectedName)
                ColorPicker("カラー選択", selection: $state.selectedColor)
                    .onChange(of: state.selectedColor) { _ in
                        state.onChangeSelectedColor()
                    }
                HStack {
                    TextField("アイコン", text: $state.selectedIcon)
                    Spacer()
                    if state.selectedIcon.isEmpty {
                        BindingCircle(state: state.circleState)
                    } else {
                        BindingSystemImage(state: state.imageState)
                    }
                }
            }

            Section("") {
                HStack(alignment: .center, spacing: 30) {
                    Spacer()
                    Button {
                        Task {
                            await state.onTapAddOrEditButton()
                            dismiss()
                        }
                    } label: {
                        Text(state.isAdd ? "追加" : "更新")
                    }
                    Button {
                        dismiss()
                    } label: {
                        Text("戻る")
                    }
                }
            }
        }
        .navigationTitle("カテゴリ\(state.isAdd ? "作成" : "更新")")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategoryFormView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFormView(
            state: .init(
                .init(
                    id: UUID(),
                    name: "サンプル",
                    color: "#FF0000",
                    icon: "",
                    order: 1
                )
            )
        )
    }
}
