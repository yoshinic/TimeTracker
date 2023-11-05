import SwiftUI
import TimeTrackerAPI

struct ActivityListView: View {
    @StateObject var state: ActivityListViewState

    var body: some View {
        List {
            ForEach(state.categories) { category in
                Section(category.name) {
                    if let a = state.activities[category.id], a.first != nil {
                        ActivityListDetailView(
                            state: .init(activities: a, categoryId: category.id)
                        )
                    } else {
                        Text("(設定なし)")
                    }
                }
            }
        }
        .environment(
            \.editMode,
            state.isEditMode ? .constant(.active) : .constant(.inactive)
        )
        .sheet(isPresented: $state.isModalPresented) {
            ActivityFormView(state: .init())
        }
        .navigationBarTitle("アクティビティ一覧", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                Button {
                    state.onTapEditButton()
                } label: {
                    Text(state.isEditMode ? "完了" : "編集")
                }
                Button {
                    state.onTapAddButton()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            }
        )
    }
}

struct ActivityListDetailView: View {
    @StateObject var state: ActivityListDetailViewState

    var body: some View {
        ForEach(state.activities) { activity in
            NavigationLink {
                ActivityFormView(state: .init(activity))
            } label: {
                HStack {
                    Text(activity.name)
                    Spacer()
                    Circle()
                        .fill(Color(hex: activity.color))
                        .frame(width: 24, height: 24)
                }
            }
        }
        .onDelete { idx in Task { await state.onDelete(at: idx) }}
        .onMove { idx, i in Task { await state.onMove(from: idx, to: i) }}
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView(state: .init())
    }
}
