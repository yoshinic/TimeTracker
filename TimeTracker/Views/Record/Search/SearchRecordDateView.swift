import SwiftUI

struct SearchRecordDateView: View {
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date

    @State private var showDatePicker = false
    @State private var showTimePicker = false

    let title: String

    var body: some View {
        HStack {
            SearchTitleView(title: title)
            RecordDateView(selectedDate, dateFormatter) { _ in
                showDatePicker.toggle()
                showTimePicker = false
            }
            RecordDateView(selectedTime, timeFormatter) { _ in
                showTimePicker.toggle()
                showDatePicker = false
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

    private struct RecordDateView: View {
        let date: Date
        let formatter: Formatter
        let onTapGesture: ((Bool) -> Void)?

        init(
            _ date: Date,
            _ formatter: Formatter,
            _ onTapGesture: ((Bool) -> Void)?
        ) {
            self.date = date
            self.formatter = formatter
            self.onTapGesture = onTapGesture
        }

        var body: some View {
            Text(date, formatter: formatter)
                .titleProps(.gray, 0.1) { b in
                    withAnimation { onTapGesture?(b) }
                }
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
