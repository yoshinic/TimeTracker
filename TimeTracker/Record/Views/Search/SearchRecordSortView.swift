import SwiftUI
import TimeTrackerAPI

struct SearchRecordSortView: View {
    @StateObject var state: SearchRecordSortViewState

    var body: some View {
        HStack {
            SearchRecordTitleView("ソート")
            RadioTextTitleView(state: .init(state.selectedSortType))
        }
    }
}

struct RadioTextTitleView: View {
    @StateObject var state: RadioTextTitleViewState

    var body: some View {
        TextTitle(
            "種別",
            color: .gray,
            active: state.selectedSortType == .kind
        )
        .onTapGesture { state.onTapKindSortButton() }
        TextTitle(
            "時間",
            color: .gray,
            active: state.selectedSortType == .time
        )
        .onTapGesture { state.onTapTimeSortButton() }
    }
}

struct RadioTextTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordSortView(state: .init(.time) { _ in })
    }
}
