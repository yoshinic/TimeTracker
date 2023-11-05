import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordDateViewState: ObservableObject {
    @Published var selectedDatetime: Date
    @Published private(set) var showDatePicker = false
    @Published private(set) var showTimePicker = false

    let title: String

    let dateFormatter: DateFormatter
    let timeFormatter: DateFormatter

    init(
        _ title: String,
        _ selectedDatetime: Date?
    ) {
        self.title = title
        self.selectedDatetime = selectedDatetime ?? .init()

        let locale: Locale = .init(identifier: "ja_JP")

        var templateFormatter: DateFormatter {
            let formatter: DateFormatter = .init()
            formatter.calendar = .init(identifier: .gregorian)
            formatter.locale = locale
            formatter.timeZone = .init(identifier:  "Asia/Tokyo") ?? TimeZone.current
            return formatter
        }

        self.dateFormatter = {
            let formatter = templateFormatter
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "YYYY/MM/dd(E)",
                options: 0,
                locale: locale
            )
            return formatter
        }()

        self.timeFormatter = {
            let formatter = templateFormatter
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "HHmm",
                options: 0,
                locale: locale
            )
            return formatter
        }()
    }

    func onTapDatePicker() {
        showDatePicker.toggle()
        showTimePicker = false
    }

    func onTapTimePicker() {
        showDatePicker = false
        showTimePicker.toggle()
    }
}
