import SwiftUI

struct CustomSystemImage: View {
    let systemName: String
    let width: CGFloat?
    let height: CGFloat?
    let color: String

    init(
        _ systemName: String,
        width: CGFloat? = 23,
        height: CGFloat? = nil,
        color: String = "0000DD"
    ) {
        self.systemName = systemName
        self.width = width
        self.height = height
        self.color = color
    }

    var body: some View {
        Image(systemName: systemName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .foregroundColor(.init(hex: color))
    }
}

struct BindingSystemImage: View {
    @ObservedObject var state: CustomSystemImageState

    var body: some View {
        CustomSystemImage(
            state.systemName,
            width: state.width,
            height: state.height,
            color: state.color
        )
    }
}
