import SwiftUI
import TimeTrackerAPI

struct SearchRecordSortView: View {
    @Binding var records: [RecordData]

    var body: some View {
        HStack {
            SearchTitleView("ソート")
            RadioTextTitle([
                .init("種別") { _, _ in },
                .init("時間") {
                    guard $0 != $1 else { return }
                    records.sort {
                        if $0.endedAt == nil, $1.endedAt == nil {
                            $0.startedAt > $1.startedAt
                        } else if let d0 = $0.endedAt, let d1 = $1.endedAt {
                            d0 == d1 ? $0.startedAt > $1.startedAt : d0 > d1
                        } else {
                            $0.endedAt == nil
                        }
                    }
                },
            ])
        }
    }
}

struct SearchRecordSortView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordSortView(records: .constant([]))
    }
}
