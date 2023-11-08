import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordListViewState: ObservableObject {
    @Published private(set) var records: [RecordData] = []
    @Published var selectedRecord: RecordData!

    private let yyyymmddHHmmFormatter: DateFormatter
    private let HHmmFormatter: DateFormatter
    private let calendar: Calendar

    init() {
        let locale: Locale = .init(identifier: "ja_JP")
        let timezone: TimeZone = .init(identifier:  "Asia/Tokyo") ?? .current
        let createTemplateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = locale
            formatter.timeZone = timezone
            return formatter
        }

        self.yyyymmddHHmmFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "MM/dd(E)HHmm",
                options: 0,
                locale: locale
            )
            return formatter
        }()

        self.HHmmFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "HHmm",
                options: 0,
                locale: locale
            )
            return formatter
        }()

        self.calendar = {
            var calendar: Calendar = .current
            calendar.locale = locale
            calendar.timeZone = timezone
            return calendar
        }()

        RecordStore.shared.$values.assign(to: &$records)
    }

    func onTapRecordRow(_ record: RecordData) {
        selectedRecord = record
    }

    func onDelete(_ idx: IndexSet) async {
        do {
            try await RecordStore.shared.delete(at: idx)
        } catch {
            print(error)
        }
    }

    func formatedDateString(_ date: Date?) -> String {
        date == nil ? "" : yyyymmddHHmmFormatter.string(from: date!)
    }

    func calcProgressString(
        _ startDate: Date,
        _ endDate: Date?
    ) -> String {
        let dcs = calendar
            .dateComponents(
                [.hour, .minute],
                from: startDate,
                to: endDate ?? .init()
            )

        let hour = "00\(dcs.hour ?? 0)".suffix(2)
        let minute = "00\(dcs.minute ?? 0)".suffix(2)

        return "\(hour):\(minute)"
    }
}
