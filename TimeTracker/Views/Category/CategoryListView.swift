import SwiftUI
import TimeTrackerAPI

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryViewModel
    
    @State private var isModalPresented: Bool = false
    @State private var newCategoryName: String = ""
    @State private var newCategoryColor: Color = .white
    @State private var isEditMode: Bool = false
    @State private var selectedCategory: CategoryData! = nil
    @State private var selectedMode: CategoryFormMode = .add

    var body: some View {
        VStack {
            addButton
            List {
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
                            viewModel.deleteCategory(id: category.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteCategories)
                .onMove(perform: viewModel.moveCategories)
            }
            .listStyle(PlainListStyle())
            .environment(\.editMode, isEditMode ? .constant(.active) : .constant(.inactive))
        }
        .navigationBarTitle("カテゴリー一覧", displayMode: .inline)
        .navigationBarItems(trailing: Button {
            isEditMode.toggle()
        } label: {
            Text(isEditMode ? "Done" : "Edit")
        })
        .sheet(isPresented: $isModalPresented) {
            CategoryFormView(
                viewModel: viewModel,
                category: selectedCategory,
                mode: selectedMode
            )
        }
        .onAppear { viewModel.fetchCategories() }
    }

    private var addButton: some View {
        Button {
            selectedCategory = nil
            selectedMode = .add
            isModalPresented = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Category")
            }
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
