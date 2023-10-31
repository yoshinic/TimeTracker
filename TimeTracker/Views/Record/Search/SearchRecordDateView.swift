import SwiftUI

struct SearchRecordDateView: View {
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date

    @State private var showDatePicker = false
    @State private var showTimePicker = false

    let title: String

    var body: some View {
        HStack {
            SearchTitleView(title)
            Text(selectedDate, formatter: dateFormatter)
                .titleProps(opacity: 0.1)
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                        showTimePicker = false
                    }
                }
            Text(selectedTime, formatter: timeFormatter)
                .titleProps(opacity: 0.1)
                .onTapGesture {
                    withAnimation {
                        showTimePicker.toggle()
                        showDatePicker = false
                    }
                }
        }
        if showDatePicker {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
        }
        if showTimePicker {
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
        }
    }

    private var templateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        return formatter
    }

    private var dateFormatter: DateFormatter {
        let formatter = templateFormatter
        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "YYYY/MM/dd(E)",
            options: 0,
            locale: Locale(identifier: "ja_JP")
        )
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = templateFormatter
        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "HHmm",
            options: 0,
            locale: Locale(identifier: "ja_JP")
        )
        return formatter
    }
}

struct SearchRecordDateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordDateView(
            selectedDate: .constant(Date()),
            selectedTime: .constant(Date()),
            title: "sample"
        )
    }
}
