import SwiftUI
import TimeTrackerAPI

struct ActivityFormView: View {
    @ObservedObject var activityViewModel: ActivityViewModel

    let activity: ActivityData!
    let mode: ActivityFormMode
    let categories: [CategoryData]
    let defaultCategoryId: UUID

    var body: some View {
        #if os(macOS)
        _ActivityFormView(
            activityViewModel: activityViewModel,
            activity: activity,
            mode: mode,
            categories: categories,
            defaultCategoryId: defaultCategoryId
        )
        #elseif os(iOS)
        _ActivityFormView(
            activityViewModel: activityViewModel,
            activity: activity,
            mode: mode,
            categories: categories,
            defaultCategoryId: defaultCategoryId
        )
        .navigationBarTitle("アクティビティ\(mode == .add ? "作成" : "更新")", displayMode: .inline)
        #else
        EmptyView()
        #endif
    }
}

struct _ActivityFormView: View {
    @ObservedObject var activityViewModel: ActivityViewModel

    @State private var selectedCategory: UUID!
    @State private var name: String = ""
    @State private var selectedColor: Color = .white
    @State private var color: String = "#FFFFFF"

    @Environment(\.dismiss) private var dismiss

    let activity: ActivityData!
    let mode: ActivityFormMode
    let categories: [CategoryData]
    let defaultCategoryId: UUID

    var body: some View {
        VStack {
            Form {
                Section(header: Text("アクティビティ作成項目")) {
                    Picker("カテゴリー名", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                    TextField("アクティビティ名", text: $name)
                    ColorPicker("カラー選択", selection: $selectedColor)
                }

                Section(header: Text("")) {
                    HStack(alignment: .center, spacing: 30) {
                        Spacer()
                        Button {
                            switch mode {
                            case .add:
                                activityViewModel.create(
                                    id: UUID(),
                                    categoryId: selectedCategory,
                                    name: name,
                                    color: color
                                )
                            case .edit:
                                activityViewModel.update(
                                    id: activity.id,
                                    categoryId: selectedCategory,
                                    name: name,
                                    color: color
                                )
                            }
                            dismiss()
                        } label: {
                            Text(mode == .add ? "Add" : "Update")
                        }

                        Button { dismiss() } label: { Text("Cancel") }
                    }
                }
            }
        }
        .onAppear {
            selectedCategory = defaultCategoryId
            guard mode == .edit else { return }
            selectedCategory = activity.category.id
            name = activity.name
            selectedColor = Color(hex: activity.color)
            color = activity.color
        }
        .onChange(of: selectedColor) { newColor in
            color = newColor.toHex()
        }
    }
}

enum ActivityFormMode {
    case add, edit
}
