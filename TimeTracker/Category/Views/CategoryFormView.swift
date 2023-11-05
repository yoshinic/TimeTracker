import SwiftUI
import TimeTrackerAPI

struct CategoryFormView: View {
    @StateObject var state: CategoryFormViewState

    init(selectedCategory: CategoryData? = nil) {
        self._state = .init(wrappedValue: .init(selectedCategory))
    }

    var body: some View {
        Form {
            Section("カテゴリ作成項目") {
                TextField("カテゴリ名", text: $state.selectedName)
                ColorPicker("カラー選択", selection: $state.selectedColor)
                TextField("アイコン", text: $state.selectedIcon)
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
            "カテゴリ\(state.isAdd ? "作成" : "更新")",
            displayMode: .inline
        )
    }
}

struct CategoryFormView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFormView(
            selectedCategory: .init(
                id: UUID(),
                name: "サンプル",
                color: "#FF0000",
                icon: "",
                order: 1
            )
        )
    }
}