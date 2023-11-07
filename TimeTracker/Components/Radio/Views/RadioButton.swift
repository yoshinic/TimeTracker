import SwiftUI

struct RadioButton: View {
    @StateObject var state: RadioButtonState

    var body: some View {
        HStack(spacing: 20) {
            ForEach(state.titles.indices,id: \.self) { i in
                TextTitle(
                    state.titles[i],
                    color: .gray,
                    opacity: 0.2,
                    active: state.selectedIdx == i
                )
                .onTapGesture { state.onTapRadioItem(i) }
            }
        }
    }
}
