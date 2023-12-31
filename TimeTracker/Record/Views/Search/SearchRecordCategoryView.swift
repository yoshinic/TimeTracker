import SwiftUI

struct SearchRecordCategoryView: View {
    @StateObject var state: SearchRecordCategoryViewState

    var body: some View {
        NavigationLink {
            List(selection: $state.selectedCategories) {
                Section("") {
                    Button("全て選択") { state.onTapAllSelected() }
                    Button("全て解除") { state.onTapAllRemoved() }
                }
                Section("選択可能なカテゴリ") {
                    ForEach(state.categories) { category in
                        HStack {
                            if category.icon.isEmpty {
                                CustomCircle(color: category.color)
                            } else {
                                CustomSystemImage(category.icon, color: category.color)
                            }
                            Text(category.name)
                        }
                        .tag(category)
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("カテゴリの絞込み")
            .navigationBarTitleDisplayMode(.inline)
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text("カテゴリ")
                if state.categories.count == state.selectedCategories.count {
                    TextBorderedTitle(
                        "全て",
                        color: .gray,
                        fontSize: 10,
                        opacity: 0.2,
                        active: false
                    )
                } else {
                    HStack(spacing: 10) {
                        ForEach(state.filteredCategories) {
                            TextBorderedTitle(
                                $0.name,
                                color: $0.color,
                                fontSize: 10,
                                opacity: 0.2,
                                paddingH: 10,
                                paddingV: 3,
                                active: false
                            )
                        }
                    }
                }
            }
        }
    }
}

struct SearchRecordCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordCategoryView(state: .init { _ in })
    }
}
