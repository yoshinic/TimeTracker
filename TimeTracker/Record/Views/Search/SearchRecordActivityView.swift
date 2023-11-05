import SwiftUI
import TimeTrackerAPI

struct SearchRecordActivityView: View {
    @StateObject var state: SearchRecordActivityViewState

    var body: some View {
        NavigationLink {
            SearchRecordActivitySelectionView(state: .init(state.selectedActivities))
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text("アクティビティ")
                if state.activities.count == state.selectedActivities.count {
                    TextTitle(
                        "全て",
                        color: .gray,
                        fontSize: 10,
                        opacity: 0.2,
                        active: false
                    )
                } else {
                    HStack(spacing: 10) {
                        ForEach(state.filteredActivities) {
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

private struct SearchRecordActivitySelectionView: View {
    @StateObject var state: SearchRecordActivitySelectionViewState

    var body: some View {
        NavigationView {
            List(selection: $state.selectedActivities) {
                ForEach(state.categories) { category in
                    Section(category.name) {
                        ForEach(state.activities[category.id] ?? []) { activity in
                            HStack {
                                Circle()
                                    .fill(Color(hex: activity.color))
                                    .frame(width: 24, height: 24)
                                Text(activity.name)
                            }
                            .tag(activity.id)
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationBarTitle("アクティビティの絞込み", displayMode: .inline)
        }
    }
}

struct SearchRecordActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordActivityView(state: .init([]))
    }
}
