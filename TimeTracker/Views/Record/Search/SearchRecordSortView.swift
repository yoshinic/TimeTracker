import SwiftUI
import TimeTrackerAPI

struct SearchRecordSortView: View {
    @Binding var sortType: RecordDataSortType

    var body: some View {
        HStack {
            SearchTitleView("ソート")
            RadioTextTitle(
                activeIndex: 1,
                [
                    .init("種別") { _, _ in
                        sortType = .kind
                    },
                    .init("時間") {
                        guard $0 != $1 else { return }
                        sortType = .time
                    },
                ]
            )
        }
    }
}

struct SearchRecordSortView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordSortView(sortType: .constant(.time))
    }
}
