import SwiftUI

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

    var body: some View {
        Form {
            Section(header: Text("")) {
                NavigationLink {
                    GeneralSettingsView()
                } label: {
                    Text("一般")
                }
            }

            Section(header: Text("カテゴリー")) {
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
                        categories: categoryViewModel.categories,
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
            Task { try await categoryViewModel.fetch() }
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
