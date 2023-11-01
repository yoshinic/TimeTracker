import SwiftUI
import TimeTrackerAPI

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryViewModel
    @State private var isEditMode: Bool = false

    var body: some View {
        #if os(macOS)
        _CategoryListView(viewModel: viewModel, isEditMode: $isEditMode)
        #elseif os(iOS)
        _CategoryListView(viewModel: viewModel, isEditMode: $isEditMode)
            .navigationBarTitle("カテゴリ一覧", displayMode: .inline)
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

struct _CategoryListView: View {
    @ObservedObject var viewModel: CategoryViewModel
    @Binding var isEditMode: Bool
    @State private var isModalPresented: Bool = false
    @State private var newCategoryName: String = ""
    @State private var newCategoryColor: Color = .white
    @State private var selectedCategory: CategoryData! = nil
    @State private var selectedMode: CategoryFormMode = .add

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
            CategoryFormView(
                viewModel: viewModel,
                category: selectedCategory,
                mode: selectedMode
            )
        }
        .onAppear {
            Task { try await viewModel.fetch() }
        }
    }

    private var DataList: some View {
        List {
            Section("") {
                ForEach(viewModel.categories) { category in
                    NavigationLink {
                        CategoryFormView(viewModel: viewModel, category: category, mode: .edit)
                    } label: {
                        HStack {
                            Text(category.name)
                            Spacer()
                            Circle()
                                .fill(Color(hex: category.color))
                                .frame(width: 24, height: 24)
                        }
                    }
                    .contextMenu {
                        Button {
                            selectedCategory = category
                            selectedMode = .edit
                            isModalPresented = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button {
                            Task { try await viewModel.delete(id: category.id) }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete { idx in Task { try await viewModel.delete(at: idx) } }
                .onMove { idx, i in Task { try await viewModel.move(from: idx, to: i) } }
            }
        }
    }

    private var addButton: some View {
        Button {
            selectedCategory = nil
            selectedMode = .add
            isModalPresented = true
        } label: {
            Image(systemName: "plus.circle")
                .imageScale(.large)
                .padding()
                .foregroundColor(.blue)
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(viewModel: .init())
    }
}
