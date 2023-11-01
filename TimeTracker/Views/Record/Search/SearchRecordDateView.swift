import SwiftUI

struct SearchRecordDateView: View {
    @Binding var selectedDatetime: Date

    @State private var showDatePicker = false
    @State private var showTimePicker = false

    let title: String

    let locale: Locale = .init(identifier: "ja_JP")
    let timezone: TimeZone? = .init(identifier:  "Asia/Tokyo") ?? TimeZone.current

    var body: some View {
        HStack {
            SearchTitleView(title)
            Text(selectedDatetime, formatter: dateFormatter)
                .titleProps(opacity: 0.1)
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                        showTimePicker = false
                    }
                }
            Text(selectedDatetime, formatter: timeFormatter)
                .titleProps(opacity: 0.1)
                .onTapGesture {
                    withAnimation {
                        showTimePicker.toggle()
                        showDatePicker = false
                    }
                }
        }
        if showDatePicker {
            DatePicker(
                "",
                selection: $selectedDatetime,
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .labelsHidden()
        }
        if showTimePicker {
            DatePicker(
                "",
                selection: $selectedDatetime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
        }
    }

    private var templateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = locale
        formatter.timeZone = timezone
        return formatter
    }

    private var dateFormatter: DateFormatter {
        let formatter = templateFormatter
        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "YYYY/MM/dd(E)",
            options: 0,
            locale: locale
        )
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = templateFormatter
        formatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "HHmm",
            options: 0,
            locale: locale
        )
        return formatter
    }
}

struct SearchRecordDateView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordDateView(
            selectedDatetime: .constant(Date()),
            title: "sample"
        )
    }
}
