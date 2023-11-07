import SwiftUI

struct CategoryListView: View {
    @StateObject var state: CategoryListViewState

    var body: some View {
        List {
            Section("") {
                ForEach(state.categories) { category in
                    NavigationLink {
                        CategoryFormView(state: .init(category))
                    } label: {
                        HStack {
                            if category.icon.isEmpty {
                                CustomCircle(color: category.color)
                            } else {
                                CustomSystemImage(category.icon, color: category.color)
                            }
                            Text(category.name)
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
        .sheet(isPresented: $state.isModalPresented) {
            CategoryFormView(state: .init())
        }
        .navigationTitle("カテゴリ一覧")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(state: .init())
    }
}
