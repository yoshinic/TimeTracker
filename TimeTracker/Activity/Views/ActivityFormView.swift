import SwiftUI

struct ActivityFormView: View {
    @StateObject var state: ActivityFormViewState

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("アクティビティ作成項目") {
                Picker("カテゴリー名", selection: $state.selectedCategoryId) {
                    ForEach(state.categories) { Text($0.name).tag($0) }
                }
                TextField("アクティビティ名", text: $state.selectedName)
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
        .navigationTitle("アクティビティ\(state.isAdd ? "作成" : "更新")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
