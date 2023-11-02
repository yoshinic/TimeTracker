import SwiftUI
import TimeTrackerAPI

struct SearchRecordCategoryView: View {
    @State private var allSelected: Bool = false
    @State private var noSelected: Bool = false

    @Binding var categories: [CategoryData]
    @Binding var selectedCategories: Set<CategoryData>

    var body: some View {
        NavigationLink {
            NavigationView {
                List(selection: $selectedCategories) {
                    Section("") {
                        HStack {
                            Text("全て選択")
                            Spacer()
                            Toggle("", isOn: $allSelected)
                                .onChange(of: allSelected) { new in
                                    guard new else { return }
                                    categories.forEach { selectedCategories.insert($0) }
                                }
                        }
                        HStack {
                            Text("全て解除")
                            Spacer()
                            Toggle("", isOn: $noSelected)
                                .onChange(of: noSelected) { new in
                                    guard new else { return }
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

struct SearchRecordCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordCategoryView(
            categories: .constant([]),
            selectedCategories: .constant([])
        )
    }
}
