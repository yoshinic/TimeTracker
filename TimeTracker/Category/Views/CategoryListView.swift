import SwiftUI
import TimeTrackerAPI

struct CategoryListView: View {
    @StateObject var state: CategoryListViewState

    var body: some View {
        List {
            Section("") {
                ForEach(state.categories) { category in
                    NavigationLink {
                        CategoryFormView(selectedCategory: category)
                    } label: {
                        HStack {
                            Image(systemName: category.icon ?? "")
                                .renderingMode(.original)
                                .foregroundColor(.blue)
                            Text(category.name)
                            Spacer()
                            Circle()
                                .fill(Color(hex: category.color))
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                .onDelete { idx in Task { await state.onDelete(at: idx) } }
                .onMove { idx, i in Task { await state.onMove(from: idx, to: i) } }
            }
        }
        .environment(
            \.editMode,
            state.isEditMode ? .constant(.active) : .constant(.inactive)
        )
        .sheet(isPresented: $state.isModalPresented) { CategoryFormView() }
        .navigationBarTitle("カテゴリ一覧", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                Button {
                    state.onTapEditButton()
                } label: {
                    Text(state.isEditMode ? "完了" : "編集")
                }
                Button {
                    state.onTapAddButton()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            }
        )
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(state: .init())
    }
}
