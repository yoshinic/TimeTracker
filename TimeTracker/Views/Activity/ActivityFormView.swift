import SwiftUI
import TimeTrackerAPI

struct ActivityFormView: View {
    @StateObject var viewModel: ActivityViewModel
    let activity: ActivityData!
    let mode: ActivityFormMode

    @State private var name: String = ""
    @State private var selectedColor: Color = .white
    @State private var color: String = "#FFFFFF"

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TextField("Activity Name", text: $name)
                .padding()
            ColorPicker("Choose a color", selection: $selectedColor)
                .padding()

            HStack(alignment: .center, spacing: 10) {
                Button {
                    switch mode {
                    case .add:
                        viewModel.addActivity(id: UUID(), name: name, color: color)
                    case .edit:
                        viewModel.updateActivity(
                            id: activity.id,
                            name: name,
                            color: color
                        )
                    }
                    dismiss()
                } label: {
                    Text(mode == .add ? "Add" : "Update")
                }
                .padding()

                Button { dismiss() } label: { Text("Cancel") }
            }
        }
        .navigationTitle("\(mode == .add ? "Add" : "Update") Activities")
        .onAppear {
            guard mode == .edit else { return }
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
