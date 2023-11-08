import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class SearchRecordDateViewState: ObservableObject {
    @Published var selectedDatetime: Date
    @Published private(set) var showDatePicker = false
    @Published private(set) var showTimePicker = false

    let title: String
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter

    let onDateChanged: (@MainActor (Date) -> Void)?

    private var cancellables: Set<AnyCancellable> = []

    init(
        _ title: String,
        _ selectedDatetime: Date?,
        _ onDateChanged: (@MainActor (Date) -> Void)? = nil
    ) {
        self.title = title
        self.selectedDatetime = selectedDatetime ?? .init()
        self.onDateChanged = onDateChanged

        let locale: Locale = .init(identifier: "ja_JP")
        let timezone: TimeZone = .init(identifier:  "Asia/Tokyo") ?? .current

        var templateFormatter: DateFormatter {
            let formatter: DateFormatter = .init()
            formatter.calendar = .init(identifier: .gregorian)
            formatter.locale = locale
            formatter.timeZone = timezone
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

        if let onDateChanged {
            $selectedDatetime
                .receive(on: DispatchQueue.main)
                .sink { onDateChanged($0) }
                .store(in: &cancellables)
        }
    }
    
    func formatedDateString(_ date: Date?) -> String {
        date == nil ? "" : dateFormatter.string(from: date!)
    }
    
    func formatedTimeString(_ date: Date?) -> String {
        date == nil ? "" : timeFormatter.string(from: date!)
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
