import SwiftUI
import TimeTrackerAPI

struct SearchRecordCategoryView: View {
    @StateObject var state: SearchRecordCategoryViewState

    var body: some View {
        NavigationLink {
            SearchRecordCategorySelectionView(
                state: .init(state.categories, state.selectedCategories)
            )
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text("カテゴリ")
                if state.categories.count == state.selectedCategories.count {
                    TextTitle(
                        "全て",
                        color: .gray,
                        fontSize: 10,
                        opacity: 0.2,
                        active: false
                    )
                } else {
                    HStack(spacing: 10) {
                        ForEach(state.filteredCategories) {
                            TextTitle(
                                $0.name,
                                color: $0.color,
                                fontSize: 10,
                                opacity: 0.2,
                                active: false
                            )
                        }
                    }
                }
            }
        }
    }
}

private struct SearchRecordCategorySelectionView: View {
    @StateObject var state: SearchRecordCategorySelectionViewState

    var body: some View {
        NavigationView {
            List(selection: $state.selectedCategories) {
                Section("") {
                    Button("全て選択") { state.onTapAllSelected() }
                    Button("全て解除") { state.onTapAllRemoved() }
                }
                Section("選択可能なカテゴリ") {
                    ForEach(state.categories) { category in
                        HStack {
                            Image(systemName: category.icon ?? "")
                            Circle()
                                .fill(Color(hex: category.color))
                                .frame(width: 24, height: 24)
                            Text(category.name)
                        }
                        .tag(category.id)
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationBarTitle("カテゴリの絞込み", displayMode: .inline)
        }
    }
}

struct SearchRecordCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordCategoryView(state: .init([]))
    }
}
