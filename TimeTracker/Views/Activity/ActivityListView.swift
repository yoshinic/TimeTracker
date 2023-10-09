import SwiftUI
import TimeTrackerAPI

struct ActivityListView: View {
    @StateObject private var viewModel = ActivityViewModel()
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
                ForEach(viewModel.activities) { activity in
                    NavigationLink {
                        ActivityFormView(viewModel: viewModel, activity: activity, mode: .edit)
                    } label: {
                        HStack {
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
                            viewModel.deleteActivity(id: activity.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteActivities)
                .onMove(perform: viewModel.moveActivities)
            }
            .listStyle(PlainListStyle())
            .environment(\.editMode, isEditMode ? .constant(.active) : .constant(.inactive))
            
        }
        .navigationTitle("Activities")
        .navigationBarItems(trailing: Button {
            isEditMode.toggle()
        } label: {
            Text(isEditMode ? "Done" : "Edit")
        })
        .sheet(isPresented: $isModalPresented) {
            ActivityFormView(viewModel: viewModel, activity: selectedActivity, mode: selectedMode)
        }
        .onAppear { viewModel.fetchActivities() }
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
        ActivityListView()
    }
}
