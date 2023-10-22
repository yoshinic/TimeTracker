import SwiftUI
import TimeTrackerAPI

struct ActivityListView: View {
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel

    @State private var isModalPresented: Bool = false
    @State private var newActivityName: String = ""
    @State private var newActivityColor: Color = .white
    @State private var isEditMode: Bool = false
    @State private var selectedActivity: ActivityData! = nil
    @State private var selectedMode: ActivityFormMode = .add

    var body: some View {
        VStack {
            addButton
            List {
                ForEach(activityViewModel.activities) { activity in
                    NavigationLink {
                        ActivityFormView(
                            activityViewModel: activityViewModel,
                            categoryViewModel: categoryViewModel,
                            activity: activity, mode: .edit
                        )
                    } label: {
                        HStack {
                            Text(activity.category.name)
                            Text(activity.name)
                            Spacer()
                            Circle()
                                .fill(Color(hex: activity.color))
                                .frame(width: 24, height: 24)
                        }
                    }
                    .contextMenu {
                        Button {
                            selectedActivity = activity
                            selectedMode = .edit
                            isModalPresented = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button {
                            activityViewModel.delete(id: activity.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: activityViewModel.delete)
                .onMove(perform: activityViewModel.move)
            }
            .listStyle(PlainListStyle())
//            .environment(\.editMode, isEditMode ? .constant(.active) : .constant(.inactive))
        }
//        .navigationBarTitle("アクティビティ一覧", displayMode: .inline)
//        .navigationBarItems(trailing: Button {
//            isEditMode.toggle()
//        } label: {
//            Text(isEditMode ? "Done" : "Edit")
//        })
        .sheet(isPresented: $isModalPresented) {
            ActivityFormView(
                activityViewModel: activityViewModel,
                categoryViewModel: categoryViewModel,
                activity: selectedActivity,
                mode: selectedMode
            )
        }
        .onAppear { activityViewModel.fetch() }
    }

    private var addButton: some View {
        Button {
            selectedActivity = nil
            selectedMode = .add
            isModalPresented = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Activity")
            }
            .padding()
            .foregroundColor(.blue)
        }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView(
            activityViewModel: .init(),
            categoryViewModel: .init()
        )
    }
}
