import SwiftUI

struct CustomCircle: View {
    let width: CGFloat?
    let height: CGFloat?
    let color: String

    init(
        width: CGFloat? = 23,
        height: CGFloat? = nil,
        color: String = "0000DD"
    ) {
        self.width = width
        self.height = height
        self.color = color
    }

    var body: some View {
        Circle()
            .fill(Color(hex: color))
            .frame(width: width, height: height)
    }
}

struct BindingCircle: View {
    @ObservedObject var state: CustomCircleState

    var body: some View {
        CustomCircle(
            width: state.width,
            height: state.height,
            color: state.color
        )
    }
}
