import SwiftUI
import TimeTrackerAPI

@MainActor
class RecordGraphViewState: ObservableObject {
    @Published var records: [RecordData] = []

    let calendar: Calendar

    init() {
        self.calendar = {
            var calendar: Calendar = .init(identifier: .gregorian)
            calendar.locale = .current
            calendar.timeZone = .current
            return calendar
        }()

        RecordStore.shared.$values.assign(to: &$records)
    }

    func division(_ startDate: Date, _ endDate: Date) -> [DateRange] {
        var currentDate = startDate
        var res: [DateRange] = []
        while currentDate < endDate {
            let endOfDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
            let currentEndDate = min(endOfDay, endDate)
            res.append(.init(start: currentDate, end: currentEndDate))
            currentDate = endOfDay
        }

        return res
    }

    func diferrent(_ from: Date, _ to: Date) -> Int {
        let c = calendar.dateComponents([.minute], from: from, to: to)
        return c.minute ?? 0
    }

    func color(hex: String?) -> Color {
        hex == nil ? .red : .init(hex: hex!)
    }

    struct DateRange: Identifiable {
        let id: UUID = .init()
        let start: Date
        let end: Date
    }
}
