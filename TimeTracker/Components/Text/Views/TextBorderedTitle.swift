import SwiftUI

struct TextBorderedTitle: View {
    let title: String
    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let paddingH: CGFloat
    let paddingV: CGFloat
    let lineLimit: Int?
    let active: Bool

    init(
        _ title: String,
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true
    ) {
        self.title = title
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.paddingH = paddingH
        self.paddingV = paddingV
        self.lineLimit = lineLimit
        self.active = active
    }

    init(
        _ title: String,
        color: String = "",
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true
    ) {
        self.init(
            title,
            color: Color(hex: color),
            fontSize: fontSize,
            opacity: opacity,
            paddingH: paddingH,
            paddingV: paddingV,
            lineLimit: lineLimit,
            active: active
        )
    }

    var body: some View {
        Text(title)
            .titleProps(
                color: color,
                fontSize: fontSize,
                opacity: opacity,
                paddingH: paddingH,
                paddingV: paddingV,
                lineLimit: lineLimit,
                active: active
            )
    }
}
