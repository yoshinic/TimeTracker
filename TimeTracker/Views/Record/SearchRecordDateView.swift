import SwiftUI

struct SearchRecordDateView: View {
    @Binding var selectedDate: Date
    @Binding var selectedTime: Date

    @State private var showDatePicker = false
    @State private var showTimePicker = false

    let title: String

    let textBgcolor: Color = .gray.opacity(0.1)

    var body: some View {
        HStack {
            SearchTitleView(title: title)
            Text("\(selectedDate, formatter: dateFormatter)")
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding([.horizontal], 14)
                .padding([.vertical], 5)
                .background(RoundedRectangle(cornerRadius: 4).fill(textBgcolor))
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                        showTimePicker = false
                    }
                }

            Text("\(selectedTime, formatter: timeFormatter)")
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding([.horizontal], 14)
                .padding([.vertical], 5)
                .background(RoundedRectangle(cornerRadius: 4).fill(textBgcolor))
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

//struct SearchRecordDateView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchRecordDateView(
//            viewModel: .init()
//        )
//    }
//}
