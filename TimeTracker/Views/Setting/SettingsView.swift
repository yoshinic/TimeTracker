import SwiftUI
import TimeTrackerAPI

struct SettingsView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel

    var body: some View {
        #if os(macOS)
        _SettingsView(
            categoryViewModel: categoryViewModel,
            activityViewModel: activityViewModel
        )
        #elseif os(iOS)
        _SettingsView(
            categoryViewModel: categoryViewModel,
            activityViewModel: activityViewModel
        )
        .navigationBarTitle("設定", displayMode: .inline)
        #else
        EmptyView()
        #endif
    }
}

struct _SettingsView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel

    @State private var categories: [CategoryData] = []
    @State private var activities: [UUID: [ActivityData]] = [:]

    var body: some View {
        Form {
            Section(header: Text("")) {
                NavigationLink {
                    GeneralSettingsView()
                } label: {
                    Text("一般")
                }
            }

            Section(header: Text("カテゴリ")) {
                NavigationLink {
                    CategoryListView(viewModel: categoryViewModel)
                } label: {
                    Text("一覧")
                }
                NavigationLink {
                    CategoryFormView(viewModel: categoryViewModel, category: nil, mode: .add)
                } label: {
                    Text("作成")
                }
            }

            Section(header: Text("アクティビティ")) {
                NavigationLink {
                    ActivityListView(
                        activityViewModel: activityViewModel,
                        categories: $categories,
                        activities: $activities,
                        defaultCategoryId: categoryViewModel.defaultId
                    )
                } label: {
                    Text("一覧")
                }
                NavigationLink {
                    ActivityFormView(
                        activityViewModel: activityViewModel,
                        activity: nil,
                        mode: .add,
                        categories: categoryViewModel.categories,
                        defaultCategoryId: categoryViewModel.defaultId
                    )
                } label: {
                    Text("作成")
                }
            }
        }
        .onAppear {
            Task {
                try await categoryViewModel.fetch()
                categories = categoryViewModel.categories

                try await activityViewModel.fetch()
                activities = activityViewModel.activities.toUUIDDic
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            categoryViewModel: .init(),
            activityViewModel: .init()
        )
    }
}
