import SwiftUI
import TimeTrackerAPI

struct SearchRecordMasterView: View {
    @State var selectedMasters: [CategoryData: [ActivityData]] = [:]
    @State private var showCategory = false
    @State private var showActivity = false

    let masters: [CategoryData: [ActivityData]]

    var selectedCategories: [CategoryData] {
        selectedMasters.keys.sorted { $0.order < $1.order }
    }

    var selectedActivities: [ActivityData] {
        selectedCategories
            .compactMap {
                selectedMasters[$0]?.sorted { $0.order < $1.order }
            }
            .flatMap { $0 }
    }

    private func activities(at category: CategoryData) -> [ActivityData] {
        masters[category]?.sorted { $0.order < $1.order } ?? []
    }

    var body: some View {
        HStack {
            SearchTitleView(title: "カテゴリ")
            if selectedMasters.keys.count == 0 {
                MasterView("全て", Color(hex: "#CCCCCC"))
            } else {
                ForEach(selectedCategories) {
                    MasterView($0.name, Color(hex: $0.color))
                }
            }
        }
        .onTapGesture { withAnimation { showCategory.toggle() }}
        if showCategory {
            HStack {
                if selectedMasters.keys.first == nil {
                    MasterView("全て", Color(hex: "#CCCCCC")) { _ in
                        selectedMasters = [:]
                    }
                } else {
                    MasterView("全て", Color(hex: "#CCCCCC")) { _ in
                        selectedMasters = [:]
                    }
                }

                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(masters.keys.sorted { $0.order < $1.order }) { m in
                            MasterView(m.name, Color(hex: m.color), true) { isSelected in
                                selectedMasters[m] = isSelected ? [] : nil
                            }
                        }
                    }
                }
            }
        }
        HStack {
            SearchTitleView(title: "アクティビティ")
            if selectedMasters.keys.count == 0 {
                MasterView("全て", Color(hex: "#CCCCCC"))
            } else {
                ForEach(selectedActivities) {
                    MasterView($0.name, Color(hex: $0.color))
                }
            }
        }
        .onTapGesture {
            withAnimation {
                showActivity.toggle()
            }
        }
        if showActivity {
            ForEach(selectedCategories) { category in
                HStack {
                    SearchTitleView(title: category.name)
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 20) {
                            ForEach(activities(at: category)) {
                                Rectangle()
                                    .fill(Color(hex: $0.color).opacity(0.2))
                                    .overlay(
                                        Text($0.name)
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                    )
                                    .onTapGesture {}
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

private extension SearchRecordMasterView {
    private struct MasterView: View {
        @State var isSelected: Bool = false

        let title: String
        let color: Color
        let fontSize: CGFloat?
        let togglable: Bool
        let onTapGesture: ((Bool) -> Void)?

        init(
            _ title: String,
            _ color: Color,
            fontSize: CGFloat? = nil,
            _ togglable: Bool = false,
            _ onTapGesture: ((Bool) -> Void)? = nil
        ) {
            self.title = title
            self.color = color
            self.fontSize = fontSize
            self.togglable = togglable
            self.onTapGesture = onTapGesture
        }

        var body: some View {
            Text(title)
                .titleProps(isSelected: $isSelected, color, fontSize: fontSize, 0.2, togglable, onTapGesture)
        }
    }
}

struct SearchRecordMasterView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordView(
            activities: .constant([]),
            fetchRecords: { _, _, _, _, _, _ in }
        )
    }
}
