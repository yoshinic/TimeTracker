import SwiftUI

struct ActivityListView: View {
    @StateObject var state: ActivityListViewState

    var body: some View {
        List {
            ForEach(state.categories) { category in
                Section(category.name) {
                    if let a = state.activities[category.id], a.first != nil {
                        ForEach(a) { activity in
                            NavigationLink {
                                ActivityFormView(state: .init(activity))
                            } label: {
                                HStack {
                                    if activity.icon.isEmpty {
                                        CustomCircle(color: activity.color)
                                    } else {
                                        CustomSystemImage(activity.icon, color: activity.color)
                                    }
                                    Text(activity.name)
                                }
                            }
                        }
                        .onDelete { idx in
                            Task { await state.onDelete(at: idx, category.id) }
                        }
                        .onMove { idx, i in
                            Task { await state.onMove(from: idx, to: i, category.id) }
                        }
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
        .navigationTitle("アクティビティ一覧")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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
        }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView(state: .init())
    }
}
