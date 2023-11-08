import SwiftUI

struct SearchRecordDateView: View {
    @StateObject var state: SearchRecordDateViewState

    var body: some View {
        HStack {
            TextTitle(state.title, width: 80)
            Text(verbatim: state.formatedDateString(state.selectedDatetime))
                .titleProps(opacity: 0.1)
                .onTapGesture { withAnimation { state.onTapDatePicker() }}
            Text(verbatim: state.formatedTimeString(state.selectedDatetime))
                .titleProps(opacity: 0.1)
                .onTapGesture { withAnimation { state.onTapTimePicker() }}
        }
        if state.showDatePicker {
            DatePicker(
                "",
                selection: $state.selectedDatetime,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
        }
        if state.showTimePicker {
            DatePicker(
                "",
                selection: $state.selectedDatetime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
        }
    }
}

struct SearchRecordDateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordDateView(state: .init("開始", .init()) { _ in })
    }
}
