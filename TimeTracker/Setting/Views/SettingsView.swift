import SwiftUI

struct SettingsView: View {
    @StateObject var state: SettingsViewState

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("")) {
                    NavigationLink {
                        GeneralSettingsView(state: .init())
                    } label: {
                        Text("一般")
                    }
                }

                Section(header: Text("カテゴリ")) {
                    NavigationLink {
                        CategoryListView(state: .init())
                    } label: {
                        Text("一覧")
                    }
                    NavigationLink {
                        CategoryFormView(state: .init())
                    } label: {
                        Text("作成")
                    }
                }

                Section(header: Text("アクティビティ")) {
                    NavigationLink {
                        ActivityListView(state: .init())
                    } label: {
                        Text("一覧")
                    }
                    NavigationLink {
                        ActivityFormView(state: .init())
                    } label: {
                        Text("作成")
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(state: .init())
    }
}
