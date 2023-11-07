import SwiftUI

struct SearchRecordSortView: View {
    @StateObject var state: SearchRecordSortViewState

    var body: some View {
        HStack {
            SearchRecordTitleView("ソート")
            RadioButton(state: .init(
                selectedIdx: state.selectedSortType == .kind ? 0 : 1,
                titles: state.titles,
                onTapItem: state.onTapRadioButton
            ))
        }
    }
}

struct SearchRecordSortView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordSortView(state: .init())
    }
}
