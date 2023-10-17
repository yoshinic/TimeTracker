import SwiftUI

struct SettingsView: View {
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel

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
                        categoryViewModel: categoryViewModel
                    )
                } label: {
                    Text("一覧")
                }
                NavigationLink {
                    ActivityFormView(
                        activityViewModel: activityViewModel,
                        categoryViewModel: categoryViewModel,
                        activity: nil,
                        mode: .add
                    )
                } label: {
                    Text("作成")
                }
            }
        }
        .navigationBarTitle("設定", displayMode: .inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(activityViewModel: .init(), categoryViewModel: .init())
    }
}
