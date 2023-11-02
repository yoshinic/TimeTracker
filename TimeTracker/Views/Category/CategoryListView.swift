import SwiftUI
import TimeTrackerAPI

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryViewModel

    @State private var isModalPresented: Bool = false
    @State private var isEditMode: Bool = false
    @State private var selectedCategory: CategoryData! = nil
    @State private var selectedMode: CategoryFormMode = .add

    var body: some View {
        #if os(macOS)
        _CategoryListView(
            viewModel: viewModel,
            isModalPresented: $isModalPresented,
            isEditMode: $isEditMode,
            selectedCategory: $selectedCategory,
            selectedMode: $selectedMode
        )
        #elseif os(iOS)
        _CategoryListView(
            viewModel: viewModel,
            isModalPresented: $isModalPresented,
            isEditMode: $isEditMode,
            selectedCategory: $selectedCategory,
            selectedMode: $selectedMode
        )
        .navigationBarTitle("カテゴリ一覧", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                editButton
                addButton
            }
        )
        #else
        EmptyView()
        #endif
    }

    private var editButton: some View {
        Button {
            isEditMode.toggle()
        } label: {
            Text(isEditMode ? "Done" : "Edit")
        }
    }

    private var addButton: some View {
        Button {
            selectedCategory = nil
            selectedMode = .add
            isModalPresented = true
        } label: {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(.blue)
        }
    }
}

struct _CategoryListView: View {
    @ObservedObject var viewModel: CategoryViewModel

    @Binding var isModalPresented: Bool
    @Binding var isEditMode: Bool
    @Binding var selectedCategory: CategoryData!
    @Binding var selectedMode: CategoryFormMode

    @State private var newCategoryName: String = ""
    @State private var newCategoryColor: Color = .white

    var body: some View {
        VStack {
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
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(viewModel: .init())
    }
}
