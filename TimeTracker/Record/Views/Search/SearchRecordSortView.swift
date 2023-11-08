import SwiftUI

struct SearchRecordSortView: View {
    @StateObject var state: SearchRecordSortViewState

    var body: some View {
        HStack {
            TextTitle(state.viewTitle, width: state.viewTitleWidth)
            Spacer()
            RadioButton(state: .init(
                selectedIdx: state.selectedIdx,
                titles: state.sortNames,
                color: state.radioColor,
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
