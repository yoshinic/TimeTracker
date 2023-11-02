import SwiftUI
import TimeTrackerAPI

struct SearchRecordActivityView: View {
    @State private var allSelected: Bool = false
    @State private var noSelected: Bool = false

    @Binding var activities: [ActivityData]
    @Binding var selectedActivities: Set<ActivityData>

    @State private var dic: [CategoryData: [ActivityData]] = [:]

    init(
        activities: Binding<[ActivityData]>,
        selectedActivities: Binding<Set<ActivityData>>
    ) {
        self._activities = activities
        self._selectedActivities = selectedActivities
        self._dic = .init(initialValue: activities.wrappedValue.toDataDic)
    }

    var body: some View {
        NavigationLink {
            NavigationView {
                List(selection: $selectedActivities) {
                    Section("") {
                        HStack {
                            Text("全て選択")
                            Spacer()
                            Toggle("", isOn: $allSelected)
                                .onChange(of: allSelected) { new in
                                    guard new else { return }
                                    activities.forEach { selectedActivities.insert($0) }
                                }
                        }
                        HStack {
                            Text("全て解除")
                            Spacer()
                            Toggle("", isOn: $noSelected)
                                .onChange(of: noSelected) { new in
                                    guard new else { return }
                                    selectedActivities.removeAll()
                                }
                        }
                    }

                    ForEach(dic.keys.map { $0 }) { category in
                        Section(category.name) {
                            ForEach(dic[category] ?? []) { activity in
                                HStack {
                                    Text(activity.name)
                                    Spacer()
                                    Circle()
                                        .fill(Color(hex: activity.color))
                                        .frame(width: 24, height: 24)
                                }
                                .tag(activity)
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(.active))
                .navigationBarTitle("アクティビティの絞込み", displayMode: .inline)
            }
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text("アクティビティ")
                HStack(spacing: 10) {
                    ForEach(activities.filter { selectedActivities.contains($0) }) {
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

struct SearchRecordActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordActivityView(
            activities: .constant([]),
            selectedActivities: .constant([])
        )
    }
}
