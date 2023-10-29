import SwiftUI
import TimeTrackerAPI

struct SearchRecordView: View {
    @State private var showCategory = false
    @State private var showActivity = false

    @State private var selectedCategories: [CategoryData] = []
    @State private var selectedActivities: [ActivityData] = []

    @State private var selectedStartDate: Date = .init()
    @State private var selectedStartTime: Date = .init()

    @State private var selectedEndDate: Date = .init()
    @State private var selectedEndTime: Date = .init()

    @Binding var activities: [ActivityData]

    let fetchRecords: (UUID?, Bool, Date?, Date?, [UUID], [UUID]) -> Void

    var body: some View {
        Section("検索") {
            SearchMasterView(masters: activities.toDic)
            SearchRecordDateView(
                selectedDate: $selectedStartDate,
                selectedTime: $selectedStartTime,
                title: "開始"
            )
            SearchRecordDateView(
                selectedDate: $selectedEndDate,
                selectedTime: $selectedEndTime,
                title: "終了"
            )
        }
    }
}

private extension Array where Element == ActivityData {
    var toDic: [CategoryData: [ActivityData]] {
        self.reduce(into: [:]) { res, activity in
            if res[activity.category] == nil {
                res[activity.category] = []
            }
            res[activity.category]!.append(activity)
        }
    }
}

struct SearchMasterView: View {
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
                SelectedMasterView(title: "全て", color: "#CCCCCC")
            } else {
                ForEach(selectedCategories) {
                    SelectedMasterView(title: $0.name, color: $0.color)
                }
            }
        }
        .onTapGesture { withAnimation { showCategory.toggle() }}
        if showCategory {
            HStack {
                if selectedMasters.keys.first == nil {
                    MasterView(isSelected: true, title: "全て", color: "#CCCCCC", mutable: false) { _ in
                        selectedMasters = [:]
                    }
                } else {
                    MasterView(isSelected: false, title: "全て", color: "#CCCCCC", mutable: false) { _ in
                        selectedMasters = [:]
                    }
                }

                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(masters.keys.sorted { $0.order < $1.order }) { m in
                            MasterView(title: m.name, color: m.color, mutable: true) { isSelected in
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
                SelectedMasterView(title: "全て", color: "#CCCCCC")
            } else {
                ForEach(selectedActivities) {
                    SelectedMasterView(title: $0.name, color: $0.color)
                }
            }
        }
        .onTapGesture {
            withAnimation {
                showActivity.toggle()
            }
        }
        if showActivity {
//            List {
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
//            }
        }
    }

    struct SelectedMasterView: View {
        let title: String
        let color: String
        var body: some View {
            Text(title)
                .padding([.horizontal], 14)
                .padding([.vertical], 5)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: color).opacity(0.2))
                )
        }
    }

    struct MasterView: View {
        @State var isSelected: Bool = false

        let title: String
        let color: String
        let mutable: Bool
        let onTapGesture: ((Bool) -> Void)?

        var body: some View {
            if isSelected {
                titleView
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: color).opacity(0.2))
                    )
            } else {
                titleView
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 1.2)
                    )
                    .foregroundColor(Color(hex: color))
            }
        }

        var titleView: some View {
            Text(title)
                .font(.system(size: 14))
                .bold()
                .padding([.horizontal], 14)
                .padding([.vertical], 5)
                .lineLimit(1)
                .onTapGesture {
                    if mutable {
                        isSelected.toggle()
                    }
                    onTapGesture?(isSelected)
                }
        }
    }
}

struct SearchTitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .frame(width: 70, alignment: .leading)
//            .font(.system(size: 18))
            .minimumScaleFactor(0.6)
//            .bold()
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

struct SearchMasterData {
    let id: UUID
    let name: String
    let color: String
}

struct SearchRecordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordView(
            activities: .constant([]),
            fetchRecords: { _, _, _, _, _, _ in }
        )
    }
}
