import SwiftUI
import TimeTrackerAPI

struct SearchRecordCategoryView: View {
    @Binding var categories: [CategoryData]
    @Binding var selectedCategories: Set<CategoryData>

    var body: some View {
        NavigationLink {
            NavigationView {
                List(selection: $selectedCategories) {
                    Section("") {
                        HStack {
                            Button("全て選択") {
                                categories.forEach { selectedCategories.insert($0) }
                            }
                        }
                        HStack {
                            Button("全て解除") {
                                selectedCategories.removeAll()
                            }
                        }
                    }
                    Section("選択可能なカテゴリ") {
                        ForEach(categories) { category in
                            HStack {
                                Text(category.name)
                                Spacer()
                                Circle()
                                    .fill(Color(hex: category.color))
                                    .frame(width: 24, height: 24)
                            }
                            .tag(category)
                        }
                    }
                }
                .environment(\.editMode, .constant(.active))
                .navigationBarTitle("カテゴリの絞込み", displayMode: .inline)
            }

        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text("カテゴリ")
                if categories.count == selectedCategories.count {
                    TextTitle(
                        "全て",
                        color: .gray,
                        fontSize: 10,
                        opacity: 0.2,
                        active: false
                    )
                } else {
                    HStack(spacing: 10) {
                        ForEach(categories.filter { selectedCategories.contains($0) }) {
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

struct SearchRecordCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordCategoryView(
            categories: .constant([]),
            selectedCategories: .constant([])
        )
    }
}
