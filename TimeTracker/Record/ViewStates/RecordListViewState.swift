import Foundation
import Combine
import TimeTrackerAPI

@MainActor
class RecordListViewState: ObservableObject {
    @Published var records: [RecordData] = []
    @Published var selectedRecord: RecordData!

    init() {
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
}

@MainActor
class RecordListDateViewState: ObservableObject {
    let formatedDateString: String
    let formatedTimeString: String

    init(_ date: Date? = nil) {
        let createTemplateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
            return formatter
        }

        let yyyymmddFormatter: DateFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "MM/dd(E)",
                options: 0,
                locale: Locale(identifier: "ja_JP")
            )
            return formatter
        }()

        let HHmmssFormatter: DateFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "HHmmss",
                options: 0,
                locale: Locale(identifier: "ja_JP")
            )
            return formatter
        }()

        self.formatedDateString
            = date == nil ? "" : yyyymmddFormatter.string(from: date!)
        self.formatedTimeString
            = date == nil ? "" : HHmmssFormatter.string(from: date!)
    }
}
