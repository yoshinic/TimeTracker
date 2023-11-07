import Foundation
import Combine

@MainActor
class CustomCircleState: ObservableObject {
    @Published var width: CGFloat?
    @Published var height: CGFloat?
    @Published var color: String

    init(
        width: CGFloat? = 23,
        height: CGFloat? = nil,
        color: String = "#0000DD"
    ) {
        self.width = width
        self.height = height
        self.color = color
    }
}
