import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordListViewState: ObservableObject {
    @Published private(set) var records: [RecordData] = []
    @Published var selectedRecord: RecordData!

    private let yyyymmddFormatter: DateFormatter
    private let HHmmssFormatter: DateFormatter

    init() {
        let createTemplateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
            return formatter
        }

        self.yyyymmddFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "MM/dd(E)",
                options: 0,
                locale: Locale(identifier: "ja_JP")
            )
            return formatter
        }()

        self.HHmmssFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "HHmmss",
                options: 0,
                locale: Locale(identifier: "ja_JP")
            )
            return formatter
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
        date == nil ? "" : yyyymmddFormatter.string(from: date!)
    }

    func formatedTimeString(_ date: Date?) -> String {
        date == nil ? "" : HHmmssFormatter.string(from: date!)
    }
}
