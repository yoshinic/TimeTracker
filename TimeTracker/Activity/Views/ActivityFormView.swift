import SwiftUI
import TimeTrackerAPI

struct ActivityFormView: View {
    @StateObject var state: ActivityFormViewState

    var body: some View {
        Form {
            Section("アクティビティ作成項目") {
                Picker("カテゴリー名", selection: $state.selectedCategoryId) {
                    ForEach(state.categories) {
                        Text($0.name).tag($0.id)
                    }
                }
                TextField("アクティビティ名", text: $state.selectedName)
                ColorPicker("カラー選択", selection: $state.selectedColor)
            }

            Section("") {
                HStack(alignment: .center, spacing: 30) {
                    Spacer()
                    Button {
                        Task { await state.onTapAddOrEditButton() }
                    } label: {
                        Text(state.isAdd ? "追加" : "更新")
                    }
                    Button {
                        state.onTapBackButton()
                    } label: {
                        Text("戻る")
                    }
                }
            }
        }
        .onChange(of: state.selectedColor) {
            state.onChangeSelectedColor(new: $0)
        }
        .navigationBarTitle(
            "アクティビティ\(state.isAdd ? "作成" : "更新")",
            displayMode: .inline
        )
    }
}