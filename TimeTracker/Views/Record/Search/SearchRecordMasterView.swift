import SwiftUI
import TimeTrackerAPI

struct SearchRecordMasterView: View {
    @State private var selectedMasters: [CategoryData: [ActivityData]] = [:]

    let masters: [CategoryData: [ActivityData]]
    let color: Color = .init(hex: "#CCCCCC")

    var body: some View {
        ScrollTextTitleCategoryView(
            $selectedMasters,
            masters.keys.map { $0 },
            color
        )
        ScrollTextTitleActivityView($selectedMasters, masters, color)
    }
}

struct ScrollTextTitleCategoryView: View {
    @State private var show = false
    @State private var all = true
    @Binding var selectedMasters: [CategoryData: [ActivityData]]

    let masters: [CategoryData]
    let color: Color

    private var selectedCategories: [CategoryData] {
        selectedMasters.keys.sorted { $0.order < $1.order }
    }

    init(
        _ selectedMasters: Binding<[CategoryData: [ActivityData]]>,
        _ masters: [CategoryData],
        _ color: Color
    ) {
        self._selectedMasters = selectedMasters
        self.masters = masters
        self.color = color
    }

    var body: some View {
        HStack {
            SearchTitleView("カテゴリ")
            if all {
                TextTitle("全て", color: color)
            } else {
                ForEach(selectedCategories) {
                    TextTitle($0.name, color: $0.color)
                }
            }
        }
        .onTapGesture { withAnimation { show.toggle() }}

        if show {
            HStack {
                TextTitle("全て", color: color, active: all)
                    .onTapGesture {
                        selectedMasters = [:]
                        all = true
                    }
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(masters.sorted { $0.order < $1.order }) { m in
                            TogglableTextTitle(
                                m.name,
                                color: m.color,
                                active: !all,
                                complition: {
                                    selectedMasters[m] = $1 ? [] : nil
                                    all = selectedMasters == [:]
                                }
                            )
                        }
                    }
                }
            }
        }
    }
}

struct ScrollTextTitleActivityView: View {
    @State private var show = false
    @Binding var selectedMasters: [CategoryData: [ActivityData]]

    let masters: [CategoryData: [ActivityData]]
    let color: Color

    private var selectedCategories: [CategoryData] {
        selectedMasters.keys.sorted { $0.order < $1.order }
    }

    private var selectedActivities: [ActivityData] {
        selectedCategories
            .compactMap {
                selectedMasters[$0]?.sorted { $0.order < $1.order }
            }
            .flatMap { $0 }
    }

    init(
        _ selectedMasters: Binding<[CategoryData: [ActivityData]]>,
        _ masters: [CategoryData: [ActivityData]],
        _ color: Color
    ) {
        self._selectedMasters = selectedMasters
        self.masters = masters
        self.color = color
    }

    var body: some View {
        HStack {
            SearchTitleView("アクティビティ")
            if selectedMasters.values.first == nil {
                TextTitle("全て", color: color)
            } else {
                ForEach(selectedActivities) {
                    TextTitle($0.name, color: $0.color)
                }
            }
        }
        .onTapGesture { withAnimation { show.toggle() }}
        if show {
            ForEach(selectedCategories) { category in
                ScrollTextTitleActivityMasterView(
                    $selectedMasters,
                    masters,
                    color,
                    category
                )
            }
        }
    }
}

private struct ScrollTextTitleActivityMasterView: View {
    @State private var all = true
    @Binding var selectedMasters: [CategoryData: [ActivityData]]

    let masters: [CategoryData: [ActivityData]]
    let color: Color
    let category: CategoryData

    private func activities(at category: CategoryData) -> [ActivityData] {
        masters[category]?.sorted { $0.order < $1.order } ?? []
    }

    init(
        _ selectedMasters: Binding<[CategoryData: [ActivityData]]>,
        _ masters: [CategoryData: [ActivityData]],
        _ color: Color,
        _ category: CategoryData
    ) {
        self._selectedMasters = selectedMasters
        self.masters = masters
        self.color = color
        self.category = category
    }

    var body: some View {
        HStack {
            SearchTitleView(category.name)
            TextTitle("全て", color: color, active: all)
                .onTapGesture {
                    selectedMasters[category] = []
                    all = true
                }
            scrollView(category)
        }
    }

    private func scrollView(
        _ category: CategoryData,
        active: Bool = false
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 20) {
                ForEach(activities(at: category)) { activity in
                    TogglableTextTitle(
                        activity.name,
                        color: activity.color,
                        active: active,
                        complition: {
                            let i = selectedMasters[category]?.firstIndex {
                                $0.id == activity.id
                            }
                            if !$0, $1, i == nil {
                                if selectedMasters[category] == nil {
                                    selectedMasters[category] = []
                                }
                                selectedMasters[category]!.append(activity)
                            } else if $0, !$1 {
                                guard let i = i else { return }
                                selectedMasters[category]!.remove(at: i)
                            }

                            all = selectedMasters[category] == []
                        }
                    )
                }
            }
        }
    }
}

struct SearchRecordMasterView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordMasterView(masters: [:])
    }
}
