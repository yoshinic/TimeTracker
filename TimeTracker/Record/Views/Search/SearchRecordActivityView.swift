import SwiftUI

struct SearchRecordActivityView: View {
    @StateObject var state: SearchRecordActivityViewState

    var body: some View {
        NavigationLink {
            List(selection: $state.selectedActivities) {
                ForEach(state.categories) { category in
                    Section(category.name) {
                        ForEach(state.activities[category.id] ?? []) { activity in
                            HStack {
                                if activity.icon.isEmpty {
                                    CustomCircle(color: activity.color)
                                } else {
                                    CustomSystemImage(activity.icon, color: activity.color)
                                }
                                Text(activity.name)
                            }
                            .tag(activity)
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("アクティビティの絞込み")
            .navigationBarTitleDisplayMode(.inline)
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text("アクティビティ")
                if state.activities.count == state.selectedActivities.count {
                    TextBorderedTitle(
                        "全て",
                        color: .gray,
                        fontSize: 10,
                        opacity: 0.2,
                        active: false
                    )
                } else {
                    HStack(spacing: 10) {
                        ForEach(state.filteredActivities) {
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

struct SearchRecordActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordActivityView(state: .init { _ in })
    }
}
