import Foundation
import Combine

@MainActor
class CustomSystemImageState: ObservableObject {
    @Published var systemName: String
    @Published var width: CGFloat?
    @Published var height: CGFloat?
    @Published var color: String

    init(
        _ systemName: String,
        width: CGFloat? = 23,
        height: CGFloat? = nil,
        color: String = "#0000DD"
    ) {
        self.systemName = systemName
        self.width = width
        self.height = height
        self.color = color
    }
}
