import SwiftUI
import TimeTrackerAPI

struct SearchRecordActivityView: View {
    @Binding var activities: [ActivityData]
    @Binding var selectedActivities: Set<UUID>

    @State private var dic: [CategoryData: [ActivityData]] = [:]

    var body: some View {
        NavigationLink {
            NavigationView {
                List(selection: $selectedActivities) {
                    Section("") {
                        HStack {
                            Button("全て選択") {
                                activities.forEach { selectedActivities.insert($0.id) }
                            }
                        }

                        HStack {
                            Button("全て解除") {
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
                                .tag(activity.id)
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
                if activities.count == selectedActivities.count {
                    TextTitle(
                        "全て",
                        color: .gray,
                        fontSize: 10,
                        opacity: 0.2,
                        active: false
                    )
                } else {
                    HStack(spacing: 10) {
                        ForEach(activities.filter { selectedActivities.contains($0.id) }) {
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
        .onAppear {
            dic = activities.toDataDic
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
