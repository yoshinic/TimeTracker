import SwiftUI
import TimeTrackerAPI

struct ActivityListView: View {
    @ObservedObject var activityViewModel: ActivityViewModel

    @State private var isEditMode: Bool = false

    let categories: [CategoryData]
    let defaultCategoryId: UUID

    var body: some View {
        #if os(macOS)
        _ActivityListView(
            activityViewModel: activityViewModel,
            isEditMode: $isEditMode,
            categories: categories,
            defaultCategoryId: defaultCategoryId
        )
        #elseif os(iOS)
        _ActivityListView(
            activityViewModel: activityViewModel,
            isEditMode: $isEditMode,
            categories: categories,
            defaultCategoryId: defaultCategoryId
        )
        .navigationBarTitle("アクティビティ一覧", displayMode: .inline)
        .navigationBarItems(trailing: Button {
            isEditMode.toggle()
        } label: {
            Text(isEditMode ? "Done" : "Edit")
        })
        #else
        EmptyView()
        #endif
    }
}

private struct _ActivityListView: View {
    @ObservedObject var activityViewModel: ActivityViewModel

    @Binding var isEditMode: Bool
    @State private var isModalPresented: Bool = false
    @State private var newActivityName: String = ""
    @State private var newActivityColor: Color = .white
    @State private var selectedActivity: ActivityData! = nil
    @State private var selectedMode: ActivityFormMode = .add

    let categories: [CategoryData]
    let defaultCategoryId: UUID

    var body: some View {
        VStack {
            addButton
            #if os(macOS)
            DataList
            #elseif os(iOS)
            DataList
                .environment(\.editMode, isEditMode ? .constant(.active) : .constant(.inactive))
            #else
            EmptyView()
            #endif
        }
        .sheet(isPresented: $isModalPresented) {
            ActivityFormView(
                activityViewModel: activityViewModel,
                activity: selectedActivity,
                mode: selectedMode,
                categories: categories,
                defaultCategoryId: defaultCategoryId
            )
        }
        .onAppear { activityViewModel.fetch() }
    }

    private var DataList: some View {
        List {
            ForEach(activityViewModel.activities) { activity in
                NavigationLink {
                    ActivityFormView(
                        activityViewModel: activityViewModel,
                        activity: activity,
                        mode: .edit,
                        categories: categories,
                        defaultCategoryId: defaultCategoryId
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
            categories: [],
            defaultCategoryId: UUID()
        )
    }
}
